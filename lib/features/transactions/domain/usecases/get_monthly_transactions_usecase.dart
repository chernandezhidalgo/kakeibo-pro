import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/domain/repositories/transaction_repository.dart';

class GetMonthlyTransactionsUseCase {
  final TransactionRepository _repository;
  const GetMonthlyTransactionsUseCase(this._repository);

  Future<AppResult<List<Transaction>>> call(String familyId) =>
      _repository.getThisMonth(familyId);
}
