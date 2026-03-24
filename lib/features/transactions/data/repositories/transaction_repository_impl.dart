import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/core/sync/sync_repository.dart';
import 'package:kakeibo_pro/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;
  final SyncRepository _sync;

  const TransactionRepositoryImpl({
    required AppDatabase db,
    required SyncRepository sync,
  })  : _db = db,
        _sync = sync;

  @override
  Stream<List<Transaction>> watchByEnvelope(String envelopeId) {
    return _db.transactionsDao
        .watchByEnvelope(envelopeId)
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<AppResult<List<Transaction>>> getThisMonth(String familyId) async {
    try {
      final rows = await _db.transactionsDao.getThisMonth(familyId);
      return appSuccess(rows.map((r) => r.toDomain()).toList());
    } catch (e) {
      return appFailure(Failure.database(e.toString()));
    }
  }

  @override
  Future<AppResult<Unit>> saveTransaction(Transaction transaction) async {
    try {
      // Calcular delta: gastos e inversiones suman al spentAmount;
      // ingresos restan (permiten compensar gastos en el sobre).
      final delta = switch (transaction.transactionType) {
        TransactionType.expense => transaction.amount,
        TransactionType.income => -transaction.amount,
        TransactionType.transfer => transaction.amount,
        TransactionType.investment => transaction.amount,
      };

      // Guardar transacción y ajustar el sobre en una transacción atómica
      if (transaction.envelopeId != null) {
        await _db.saveTransactionAtomic(
          tx: transaction.toCompanion(),
          envelopeId: transaction.envelopeId!,
          delta: delta,
        );
      } else {
        await _db.transactionsDao.upsertTransaction(transaction.toCompanion());
      }

      await _sync.enqueueUpdate(
        tableName: 'transactions',
        recordId: transaction.id,
        payload: transaction.toSyncPayload(),
      );
      return appSuccess(Unit.value);
    } catch (e) {
      return appFailure(Failure.database(e.toString()));
    }
  }

  @override
  Future<AppResult<Unit>> deleteTransaction(String id) async {
    try {
      // Soft-delete + reversión atómica del spentAmount del sobre
      await _db.deleteTransactionAtomic(id);
      await _sync.enqueueDelete(
        tableName: 'transactions',
        recordId: id,
      );
      return appSuccess(Unit.value);
    } catch (e) {
      return appFailure(Failure.database(e.toString()));
    }
  }
}
