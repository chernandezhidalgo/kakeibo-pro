import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:kakeibo_pro/features/transactions/presentation/providers/transaction_provider.dart';

// ── Clave compuesta para el provider (familyId + envelopeId) ─────────────────

/// Clave pública utilizada por [addTransactionProvider].
/// Se declara como typedef para poder importarla desde otras páginas.
typedef TxKey = ({String familyId, String envelopeId});

// ── Estado del formulario ─────────────────────────────────────────────────────

class AddTransactionState {
  final double amount;
  final String description;
  final TransactionType type;
  final DateTime date;
  final String? merchantName;
  final bool isLoading;
  final String? errorMessage;
  final bool savedOk;

  AddTransactionState({
    this.amount = 0,
    this.description = '',
    this.type = TransactionType.expense,
    DateTime? date,
    this.merchantName,
    this.isLoading = false,
    this.errorMessage,
    this.savedOk = false,
  }) : date = date ?? DateTime.now();

  AddTransactionState copyWith({
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
    return AddTransactionState(
      amount: amount ?? this.amount,
      description: description ?? this.description,
      type: type ?? this.type,
      date: date ?? this.date,
      merchantName: clearMerchant ? null : (merchantName ?? this.merchantName),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedOk: savedOk ?? this.savedOk,
    );
  }

  bool get isAmountValid => amount > 0;
  bool get isDescriptionValid => description.trim().length >= 2;
  bool get canSave => isAmountValid && isDescriptionValid && !isLoading;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class AddTransactionNotifier extends StateNotifier<AddTransactionState> {
  final SaveTransactionUseCase _saveUseCase;
  final String _familyId;
  final String _envelopeId;

  AddTransactionNotifier({
    required SaveTransactionUseCase saveUseCase,
    required String familyId,
    required String envelopeId,
  })  : _saveUseCase = saveUseCase,
        _familyId = familyId,
        _envelopeId = envelopeId,
        super(AddTransactionState());

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

  Future<void> save(String registeredBy) async {
    if (!state.canSave) return;
    state = state.copyWith(isLoading: true, clearError: true);

    final transaction = Transaction(
      id: const Uuid().v4(),
      familyId: _familyId,
      envelopeId: _envelopeId,
      registeredBy: registeredBy,
      amount: state.amount,
      description: state.description.trim(),
      merchantName: state.merchantName,
      transactionDate: state.date,
      transactionType: state.type,
      status: TransactionStatus.confirmed,
      source: TransactionSource.manual,
    );

    final result = await _saveUseCase(transaction);

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

final addTransactionProvider = StateNotifierProvider.family<
    AddTransactionNotifier, AddTransactionState, TxKey>(
  (ref, key) {
    final saveUseCase = SaveTransactionUseCase(
      ref.watch(transactionRepositoryProvider),
    );
    return AddTransactionNotifier(
      saveUseCase: saveUseCase,
      familyId: key.familyId,
      envelopeId: key.envelopeId,
    );
  },
);
