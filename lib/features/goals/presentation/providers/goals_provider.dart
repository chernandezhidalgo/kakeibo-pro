import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/core/database/database_provider.dart';
import 'package:kakeibo_pro/features/goals/domain/entities/savings_goal.dart';

// ── Mapper: fila DB → entidad de dominio ──────────────────────────────────────

SavingsGoal _toEntity(SavingsGoalsTableData row) => SavingsGoal(
      id: row.id,
      familyId: row.familyId,
      name: row.name,
      emoji: row.emoji,
      targetAmount: row.targetAmount,
      currentAmount: row.currentAmount,
      deadline: row.deadline,
      isCompleted: row.isCompleted,
      isSynced: row.isSynced,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );

// ── Stream de metas ───────────────────────────────────────────────────────────

/// Stream reactivo de metas de ahorro para una familia.
/// Uso: `ref.watch(goalsStreamProvider(familyId))`
final goalsStreamProvider =
    StreamProvider.autoDispose.family<List<SavingsGoal>, String>(
  (ref, familyId) {
    final db = ref.watch(appDatabaseProvider);
    return db.savingsGoalsDao
        .watchGoals(familyId)
        .map((rows) => rows.map(_toEntity).toList());
  },
);

// ── Estado para crear / editar una meta ──────────────────────────────────────

class GoalFormState {
  final String name;
  final String emoji;
  final double targetAmount;
  final DateTime? deadline;
  final bool isLoading;
  final String? errorMessage;
  final bool savedOk;

  const GoalFormState({
    this.name = '',
    this.emoji = '🎯',
    this.targetAmount = 0,
    this.deadline,
    this.isLoading = false,
    this.errorMessage,
    this.savedOk = false,
  });

  bool get canSave => name.trim().length >= 2 && targetAmount > 0;

  GoalFormState copyWith({
    String? name,
    String? emoji,
    double? targetAmount,
    DateTime? deadline,
    bool? isLoading,
    String? errorMessage,
    bool? savedOk,
  }) {
    return GoalFormState(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      targetAmount: targetAmount ?? this.targetAmount,
      deadline: deadline ?? this.deadline,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      savedOk: savedOk ?? this.savedOk,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

typedef GoalFormParams = ({String familyId});

class GoalFormNotifier extends StateNotifier<GoalFormState> {
  GoalFormNotifier(this._db, this._familyId) : super(const GoalFormState());

  final AppDatabase _db;
  final String _familyId;
  final _uuid = const Uuid();

  void setName(String v) => state = state.copyWith(name: v);
  void setEmoji(String v) => state = state.copyWith(emoji: v);
  void setDeadline(DateTime? v) =>
      state = state.copyWith(deadline: v, savedOk: false);

  void setTargetAmount(String raw) {
    final parsed = double.tryParse(raw.replaceAll(',', '.')) ?? 0;
    state = state.copyWith(targetAmount: parsed);
  }

  Future<void> save() async {
    if (!state.canSave) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _db.savingsGoalsDao.upsertGoal(
        SavingsGoalsTableCompanion.insert(
          id: _uuid.v4(),
          familyId: _familyId,
          name: state.name.trim(),
          emoji: Value(state.emoji),
          targetAmount: state.targetAmount,
          deadline: Value(state.deadline),
        ),
      );
      state = state.copyWith(isLoading: false, savedOk: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al guardar la meta: $e',
      );
    }
  }

  Future<void> deleteGoal(String id) async {
    await _db.savingsGoalsDao.deleteGoal(id);
  }

  Future<void> addToGoal(String id, double amount) async {
    await _db.savingsGoalsDao.addToGoal(id, amount);
  }
}

final goalFormProvider =
    StateNotifierProvider.autoDispose.family<GoalFormNotifier, GoalFormState,
        GoalFormParams>(
  (ref, p) => GoalFormNotifier(ref.watch(appDatabaseProvider), p.familyId),
);
