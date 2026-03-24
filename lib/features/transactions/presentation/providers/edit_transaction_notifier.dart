import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:kakeibo_pro/features/transactions/presentation/providers/transaction_provider.dart';

// ── Estado del formulario de edición ─────────────────────────────────────────

class EditTransactionState {
  final double amount;
  final String description;
  final TransactionType type;
  final DateTime date;
  final String? merchantName;
  final bool isLoading;
  final String? errorMessage;
  final bool savedOk;

  EditTransactionState({
    required this.amount,
    required this.description,
    required this.type,
    required this.date,
    this.merchantName,
    this.isLoading = false,
    this.errorMessage,
    this.savedOk = false,
  });

  EditTransactionState copyWith({
    double? amount,
    String? description,
    TransactionType? type,
    DateTime? date,
    String? merchantName,
    bool clearMerchant = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? savedOk,
  }) {
    return EditTransactionState(
      amount: amount ?? this.amount,
      description: description ?? this.description,
      type: type ?? this.type,
      date: date ?? this.date,
      merchantName:
          clearMerchant ? null : (merchantName ?? this.merchantName),
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      savedOk: savedOk ?? this.savedOk,
    );
  }

  bool get isAmountValid => amount > 0;
  bool get isDescriptionValid => description.trim().length >= 2;
  bool get canSave => isAmountValid && isDescriptionValid && !isLoading;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class EditTransactionNotifier extends StateNotifier<EditTransactionState> {
  final UpdateTransactionUseCase _updateUseCase;
  final Transaction _original;

  EditTransactionNotifier({
    required UpdateTransactionUseCase updateUseCase,
    required Transaction original,
  })  : _updateUseCase = updateUseCase,
        _original = original,
        super(EditTransactionState(
          amount: original.amount,
          description: original.description,
          type: original.transactionType,
          date: original.transactionDate,
          merchantName: original.merchantName,
        ));

  void setAmount(String raw) {
    final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final value = double.tryParse(clean) ?? 0;
    state = state.copyWith(amount: value, clearError: true);
  }

  void setDescription(String value) =>
      state = state.copyWith(description: value, clearError: true);

  void setType(TransactionType value) => state = state.copyWith(type: value);

  void setDate(DateTime value) => state = state.copyWith(date: value);

  void setMerchant(String value) => state = state.copyWith(
        merchantName: value.trim().isEmpty ? null : value.trim(),
        clearMerchant: value.trim().isEmpty,
      );

  Future<void> save() async {
    if (!state.canSave) return;
    state = state.copyWith(isLoading: true, clearError: true);

    // Construye la transacción actualizada manteniendo id, familyId,
    // envelopeId, registeredBy, status y source del original.
    final updated = _original.copyWith(
      amount: state.amount,
      description: state.description.trim(),
      transactionType: state.type,
      transactionDate: state.date,
      merchantName: state.merchantName,
    );

    final result = await _updateUseCase(updated);

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

/// Provider de edición de transacción.
/// La clave es la [Transaction] original (Freezed garantiza igualdad por valor).
/// [autoDispose] descarta el estado al salir de la pantalla de edición.
final editTransactionProvider = StateNotifierProvider.autoDispose.family<
    EditTransactionNotifier, EditTransactionState, Transaction>(
  (ref, tx) {
    return EditTransactionNotifier(
      updateUseCase:
          UpdateTransactionUseCase(ref.watch(transactionRepositoryProvider)),
      original: tx,
    );
  },
);
