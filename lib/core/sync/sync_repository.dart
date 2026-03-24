import 'dart:convert';
import 'package:kakeibo_pro/core/database/app_database.dart';

/// Wrapper liviano sobre [SyncQueueDao].
///
/// Los repositorios de features usan esta clase en lugar del DAO
/// directamente, para no acoplar la capa de datos al detalle de Drift.
class SyncRepository {
  final AppDatabase _db;

  const SyncRepository(this._db);

  /// Encola una operación de inserción.
  Future<void> enqueueInsert({
    required String tableName,
    required String recordId,
    required Map<String, dynamic> payload,
  }) =>
      _db.syncQueueDao.enqueue(
        operationType: 'INSERT',
        tableName: tableName,
        recordId: recordId,
        payload: jsonEncode(payload),
      );

  /// Encola una operación de actualización.
  Future<void> enqueueUpdate({
    required String tableName,
    required String recordId,
    required Map<String, dynamic> payload,
  }) =>
      _db.syncQueueDao.enqueue(
        operationType: 'UPDATE',
        tableName: tableName,
        recordId: recordId,
        payload: jsonEncode(payload),
      );

  /// Encola una operación de eliminación.
  Future<void> enqueueDelete({
    required String tableName,
    required String recordId,
  }) =>
      _db.syncQueueDao.enqueue(
        operationType: 'DELETE',
        tableName: tableName,
        recordId: recordId,
        payload: jsonEncode({'id': recordId}),
      );
}
