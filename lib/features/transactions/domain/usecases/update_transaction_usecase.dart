import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/domain/repositories/transaction_repository.dart';

/// Actualiza una transacción existente y aplica el delta diferencial
/// al [spentAmount] del sobre correspondiente.
class UpdateTransactionUseCase {
  final TransactionRepository _repository;
  const UpdateTransactionUseCase(this._repository);

  Future<AppResult<Unit>> call(Transaction transaction) =>
      _repository.updateTransaction(transaction);
}
