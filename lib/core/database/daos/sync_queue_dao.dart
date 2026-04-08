import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueueTable])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  // Agrega una operación a la cola
  Future<int> enqueue({
    required String operationType,
    required String tableName,
    required String recordId,
    required String payload,
  }) {
    return into(syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        operationType: operationType,
        tableName_: tableName,
        recordId: recordId,
        payload: payload,
      ),
    );
  }

  // Operaciones pendientes, en orden FIFO
  Future<List<SyncQueueTableData>> getPending() {
    return (select(syncQueueTable)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  // Marcar como procesada exitosamente
  Future<void> markDone(int queueId) {
    return (update(syncQueueTable)..where((t) => t.id.equals(queueId)))
        .write(SyncQueueTableCompanion(
      status: const Value('done'),
      processedAt: Value(DateTime.now()),
    ));
  }

  // Marcar como fallida con motivo, incrementando el contador de intentos
  Future<void> markFailed(int queueId, String error) async {
    final row = await (select(syncQueueTable)
          ..where((t) => t.id.equals(queueId)))
        .getSingleOrNull();
    final currentCount = row?.attemptCount ?? 0;
    await (update(syncQueueTable)..where((t) => t.id.equals(queueId)))
        .write(SyncQueueTableCompanion(
      status: const Value('failed'),
      lastError: Value(error),
      attemptCount: Value(currentCount + 1),
    ));
  }

  // Limpiar operaciones done (llamar al cerrar sesión del mes)
  Future<int> clearDone() {
    return (delete(syncQueueTable)
          ..where((t) => t.status.equals('done')))
        .go();
  }

  // Cantidad de operaciones pendientes (para badge de UI)
  Stream<int> watchPendingCount() {
    final countExp = syncQueueTable.id.count();
    return (selectOnly(syncQueueTable)
          ..addColumns([countExp])
          ..where(syncQueueTable.status.equals('pending')))
        .map((row) => row.read(countExp) ?? 0)
        .watchSingle();
  }
}
