import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository _repository;
  const DeleteTransactionUseCase(this._repository);

  Future<AppResult<Unit>> call(String id) =>
      _repository.deleteTransaction(id);
}
