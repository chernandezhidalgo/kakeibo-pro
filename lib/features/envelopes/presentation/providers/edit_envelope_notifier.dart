import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/domain/usecases/save_envelope_usecase.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/providers/envelope_provider.dart';

// ── Estado del formulario de edición de sobre ─────────────────────────────────

class EditEnvelopeState {
  final String name;
  final KakeiboCategory category;
  final double budget;
  final String emoji;
  final bool isLoading;
  final String? errorMessage;
  final bool savedOk;

  const EditEnvelopeState({
    required this.name,
    required this.category,
    required this.budget,
    required this.emoji,
    this.isLoading = false,
    this.errorMessage,
    this.savedOk = false,
  });

  EditEnvelopeState copyWith({
    String? name,
    KakeiboCategory? category,
    double? budget,
    String? emoji,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? savedOk,
  }) {
    return EditEnvelopeState(
      name: name ?? this.name,
      category: category ?? this.category,
      budget: budget ?? this.budget,
      emoji: emoji ?? this.emoji,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      savedOk: savedOk ?? this.savedOk,
    );
  }

  bool get isNameValid => name.trim().length >= 2;
  bool get isBudgetValid => budget > 0;
  bool get canSave => isNameValid && isBudgetValid && !isLoading;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class EditEnvelopeNotifier extends StateNotifier<EditEnvelopeState> {
  final SaveEnvelopeUseCase _saveUseCase;
  final Envelope _original;

  EditEnvelopeNotifier({
    required SaveEnvelopeUseCase saveUseCase,
    required Envelope original,
  })  : _saveUseCase = saveUseCase,
        _original = original,
        super(EditEnvelopeState(
          name: original.name,
          category: original.kakeiboCategory,
          budget: original.monthlyBudget,
          emoji: original.iconEmoji,
        ));

  void setName(String value) =>
      state = state.copyWith(name: value, clearError: true);

  void setCategory(KakeiboCategory value) =>
      state = state.copyWith(category: value);

  void setBudget(String raw) {
    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final value = double.tryParse(clean) ?? 0;
    state = state.copyWith(budget: value, clearError: true);
  }

  void setEmoji(String value) => state = state.copyWith(emoji: value);

  Future<void> save() async {
    if (!state.canSave) return;
    state = state.copyWith(isLoading: true, clearError: true);

    // Conserva el mismo ID, familyId, currentSpent, sortOrder, isActive.
    // Solo actualiza los campos editables: nombre, categoría, presupuesto, emoji.
    final updated = _original.copyWith(
      name: state.name.trim(),
      kakeiboCategory: state.category,
      monthlyBudget: state.budget,
      iconEmoji: state.emoji,
    );

    final result = await _saveUseCase(updated);

    if (result.failure != null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _errorMessage(result.failure!),
      );
    } else {
      state = state.copyWith(isLoading: false, savedOk: true);
    }
  }

  String _errorMessage(Failure failure) {
    return switch (failure) {
      DatabaseFailure(:final message) => 'Error al guardar: $message',
      NetworkFailure(:final message) => 'Error de red: $message',
      _ => 'Error inesperado. Intenta de nuevo.',
    };
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Provider de edición de sobre.
/// La clave es el [Envelope] original (Freezed garantiza igualdad por valor).
/// [autoDispose] descarta el estado al salir de la pantalla de edición.
final editEnvelopeProvider = StateNotifierProvider.autoDispose.family<
    EditEnvelopeNotifier, EditEnvelopeState, Envelope>(
  (ref, envelope) {
    return EditEnvelopeNotifier(
      saveUseCase: SaveEnvelopeUseCase(ref.watch(envelopeRepositoryProvider)),
      original: envelope,
    );
  },
);
