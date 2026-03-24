import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/domain/usecases/save_envelope_usecase.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/providers/envelope_provider.dart';

// ── Estado del formulario ─────────────────────────────────────────────────────

class CreateEnvelopeState {
  final String name;
  final KakeiboCategory category;
  final double budget;
  final String emoji;
  final bool isLoading;
  final String? errorMessage;
  final bool savedOk;

  const CreateEnvelopeState({
    this.name = '',
    this.category = KakeiboCategory.survival,
    this.budget = 0,
    this.emoji = '💰',
    this.isLoading = false,
    this.errorMessage,
    this.savedOk = false,
  });

  CreateEnvelopeState copyWith({
    String? name,
    KakeiboCategory? category,
    double? budget,
    String? emoji,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? savedOk,
  }) {
    return CreateEnvelopeState(
      name: name ?? this.name,
      category: category ?? this.category,
      budget: budget ?? this.budget,
      emoji: emoji ?? this.emoji,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedOk: savedOk ?? this.savedOk,
    );
  }

  bool get isNameValid => name.trim().length >= 2;
  bool get isBudgetValid => budget > 0;
  bool get canSave => isNameValid && isBudgetValid && !isLoading;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class CreateEnvelopeNotifier extends StateNotifier<CreateEnvelopeState> {
  final SaveEnvelopeUseCase _saveUseCase;
  final String _familyId;

  CreateEnvelopeNotifier({
    required SaveEnvelopeUseCase saveUseCase,
    required String familyId,
  })  : _saveUseCase = saveUseCase,
        _familyId = familyId,
        super(const CreateEnvelopeState());

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

    final envelope = Envelope(
      id: const Uuid().v4(),
      familyId: _familyId,
      name: state.name.trim(),
      kakeiboCategory: state.category,
      monthlyBudget: state.budget,
      currentSpent: 0,
      colorHex: '#5b9cf6',
      iconEmoji: state.emoji,
      sortOrder: 0,
      isActive: true,
      isEditable: true,
    );

    final result = await _saveUseCase(envelope);

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

final createEnvelopeProvider =
    StateNotifierProvider.family<CreateEnvelopeNotifier, CreateEnvelopeState,
        String>(
  (ref, familyId) {
    final saveUseCase = SaveEnvelopeUseCase(
      ref.watch(envelopeRepositoryProvider),
    );
    return CreateEnvelopeNotifier(
      saveUseCase: saveUseCase,
      familyId: familyId,
    );
  },
);
