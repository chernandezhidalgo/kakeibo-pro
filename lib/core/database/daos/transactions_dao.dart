import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [TransactionsTable])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  // Transacciones de un sobre, ordenadas por fecha descendente
  Stream<List<TransactionsTableData>> watchByEnvelope(String envelopeId) {
    return (select(transactionsTable)
          ..where((t) =>
              t.envelopeId.equals(envelopeId) &
              t.localStatus.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  // Transacciones del mes actual para una familia
  Future<List<TransactionsTableData>> getThisMonth(String familyId) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    return (select(transactionsTable)
          ..where((t) =>
              t.familyId.equals(familyId) &
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerThanValue(end) &
              t.localStatus.equals('active')))
        .get();
  }

  Future<void> upsertTransaction(TransactionsTableCompanion tx) {
    return into(transactionsTable).insertOnConflictUpdate(tx);
  }

  Future<void> markSynced(String id) {
    return (update(transactionsTable)..where((t) => t.id.equals(id)))
        .write(const TransactionsTableCompanion(isSynced: Value(true)));
  }

  Future<List<TransactionsTableData>> getPendingSync() {
    return (select(transactionsTable)
          ..where((t) => t.isSynced.equals(false)))
        .get();
  }

  Future<void> softDelete(String id) {
    return (update(transactionsTable)..where((t) => t.id.equals(id))).write(
      TransactionsTableCompanion(
        localStatus: const Value('pending_delete'),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
