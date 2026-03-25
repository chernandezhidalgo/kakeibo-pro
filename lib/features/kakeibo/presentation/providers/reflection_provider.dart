import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/core/database/database_provider.dart';
import 'package:kakeibo_pro/features/ai/data/services/claude_service_impl.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:kakeibo_pro/features/home/presentation/providers/summary_provider.dart';
import 'package:uuid/uuid.dart';

// ── Estado ────────────────────────────────────────────────────────────────────

class ReflectionState {
  final String q1, q2, q3, q4;
  final double savingsTarget;
  final bool isLoading;
  final bool savedOk;
  final String? errorMessage;

  const ReflectionState({
    this.q1 = '',
    this.q2 = '',
    this.q3 = '',
    this.q4 = '',
    this.savingsTarget = 0,
    this.isLoading = false,
    this.savedOk = false,
    this.errorMessage,
  });

  ReflectionState copyWith({
    String? q1,
    String? q2,
    String? q3,
    String? q4,
    double? savingsTarget,
    bool? isLoading,
    bool? savedOk,
    String? errorMessage,
    bool clearError = false,
  }) =>
      ReflectionState(
        q1: q1 ?? this.q1,
        q2: q2 ?? this.q2,
        q3: q3 ?? this.q3,
        q4: q4 ?? this.q4,
        savingsTarget: savingsTarget ?? this.savingsTarget,
        isLoading: isLoading ?? this.isLoading,
        savedOk: savedOk ?? this.savedOk,
        errorMessage:
            clearError ? null : (errorMessage ?? this.errorMessage),
      );

  /// Válido si al menos la pregunta 1 y la 4 tienen contenido.
  bool get canSave =>
      q1.trim().length >= 3 && q4.trim().length >= 3;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ReflectionNotifier extends StateNotifier<ReflectionState> {
  final Ref _ref;
  final String familyId;
  final int year;
  final int month;

  ReflectionNotifier({
    required Ref ref,
    required this.familyId,
    required this.year,
    required this.month,
  })  : _ref = ref,
        super(const ReflectionState());

  void setQ1(String v) => state = state.copyWith(q1: v);
  void setQ2(String v) => state = state.copyWith(q2: v);
  void setQ3(String v) => state = state.copyWith(q3: v);
  void setQ4(String v) => state = state.copyWith(q4: v);

  void setSavingsTarget(String raw) {
    final v =
        double.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    state = state.copyWith(savingsTarget: v);
  }

  Future<void> save({
    required double incomeTotal,
    required double expenseTotal,
  }) async {
    if (!state.canSave) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final db = _ref.read(appDatabaseProvider);
      const uuid = Uuid();
      final insertedId = uuid.v4();

      // Nombres de campos reales de kakeibo_reflections_table.dart:
      //   questionHowMuch → q1   |   questionSave  → q2
      //   questionSpent   → q3   |   questionImprove → q4
      final userId = _ref.read(currentUserIdProvider);

      await db.into(db.kakeiboReflectionsTable).insert(
            KakeiboReflectionsTableCompanion.insert(
              id: insertedId,
              familyId: familyId,
              userId: userId,
              year: year,
              month: month,
              incomeTotal: Value(incomeTotal),
              expenseTotal: Value(expenseTotal),
              savingsTarget: Value(state.savingsTarget),
              savingsActual: Value(incomeTotal - expenseTotal),
              questionHowMuch: Value(state.q1.trim()),
              questionSave: Value(state.q2.trim()),
              questionSpent: Value(state.q3.trim()),
              questionImprove: Value(state.q4.trim()),
              updatedAt: Value(DateTime.now()),
            ),
          );

      state = state.copyWith(isLoading: false, savedOk: true);

      // ── Insight de IA (no-bloqueante) ───────────────────────────────────
      // Se ejecuta después de guardar y actualiza aiInsight en la DB.
      _generateInsightAsync(
        id: insertedId,
        db: db,
        incomeTotal: incomeTotal,
        expenseTotal: expenseTotal,
      );
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Error al guardar: $e');
    }
  }

  Future<void> _generateInsightAsync({
    required String id,
    required AppDatabase db,
    required double incomeTotal,
    required double expenseTotal,
  }) async {
    try {
      // Obtener gasto real por categoría Kakeibo desde el resumen mensual.
      Map<String, double> spentByCategory = {};
      try {
        final summary = await _ref
            .read(monthlySummaryProvider((familyId: familyId)).future);
        spentByCategory =
            summary.spentByCategory.map((k, v) => MapEntry(k.name, v));
      } catch (_) {
        // Si el resumen no está disponible, usamos mapa vacío (no crítico).
      }

      final insight = await ClaudeServiceImpl().generateReflectionInsight(
        incomeTotal: incomeTotal,
        expenseTotal: expenseTotal,
        savingsTarget: state.savingsTarget,
        savingsActual: incomeTotal - expenseTotal,
        q1: state.q1,
        q2: state.q2,
        q3: state.q3,
        q4: state.q4,
        spentByCategory: spentByCategory,
      );
      await (db.update(db.kakeiboReflectionsTable)
            ..where((t) => t.id.equals(id)))
          .write(
        KakeiboReflectionsTableCompanion(
          aiInsight: Value(insight.summary),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (_) {
      // Insight es opcional; no interrumpir el flujo principal.
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

typedef ReflectionParams = ({String familyId, int year, int month});

final reflectionProvider = StateNotifierProvider.autoDispose
    .family<ReflectionNotifier, ReflectionState, ReflectionParams>(
  (ref, p) => ReflectionNotifier(
      ref: ref, familyId: p.familyId, year: p.year, month: p.month),
);
