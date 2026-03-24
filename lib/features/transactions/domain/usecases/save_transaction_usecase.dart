import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/domain/repositories/transaction_repository.dart';

class SaveTransactionUseCase {
  final TransactionRepository _repository;
  const SaveTransactionUseCase(this._repository);

  Future<AppResult<Unit>> call(Transaction transaction) =>
      _repository.saveTransaction(transaction);
}
