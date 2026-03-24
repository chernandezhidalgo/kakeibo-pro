import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/envelopes_table.dart';

part 'envelopes_dao.g.dart';

@DriftAccessor(tables: [EnvelopesTable])
class EnvelopesDao extends DatabaseAccessor<AppDatabase>
    with _$EnvelopesDaoMixin {
  EnvelopesDao(super.db);

  // Todos los sobres activos de una familia
  Stream<List<EnvelopesTableData>> watchEnvelopes(String familyId) {
    return (select(envelopesTable)
          ..where((t) =>
              t.familyId.equals(familyId) & t.localStatus.equals('active'))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  // Un sobre por ID
  Future<EnvelopesTableData?> getEnvelopeById(String id) {
    return (select(envelopesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Insertar o reemplazar (upsert)
  Future<void> upsertEnvelope(EnvelopesTableCompanion envelope) {
    return into(envelopesTable).insertOnConflictUpdate(envelope);
  }

  // Marcar como sincronizado
  Future<void> markSynced(String id) {
    return (update(envelopesTable)..where((t) => t.id.equals(id)))
        .write(const EnvelopesTableCompanion(isSynced: Value(true)));
  }

  // Sobres pendientes de sync
  Future<List<EnvelopesTableData>> getPendingSync() {
    return (select(envelopesTable)
          ..where((t) => t.isSynced.equals(false)))
        .get();
  }

  // Soft delete
  Future<void> softDelete(String id) {
    return (update(envelopesTable)..where((t) => t.id.equals(id))).write(
      EnvelopesTableCompanion(
        localStatus: const Value('pending_delete'),
        isSynced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Ajustar el gasto acumulado del sobre (delta positivo = gasto, negativo = ingreso/reversión)
  Future<void> adjustSpent(String id, double delta) async {
    final envelope = await getEnvelopeById(id);
    if (envelope == null) return;
    await (update(envelopesTable)..where((t) => t.id.equals(id))).write(
      EnvelopesTableCompanion(
        spentAmount: Value(envelope.spentAmount + delta),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }
}
