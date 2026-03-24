import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/core/sync/sync_repository.dart';
import 'package:kakeibo_pro/features/envelopes/data/mappers/envelope_mapper.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/domain/repositories/envelope_repository.dart';

class EnvelopeRepositoryImpl implements EnvelopeRepository {
  final AppDatabase _db;
  final SyncRepository _sync;

  const EnvelopeRepositoryImpl({
    required AppDatabase db,
    required SyncRepository sync,
  })  : _db = db,
        _sync = sync;

  @override
  Stream<List<Envelope>> watchEnvelopes(String familyId) {
    return _db.envelopesDao
        .watchEnvelopes(familyId)
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<AppResult<Envelope?>> getEnvelopeById(String id) async {
    try {
      final row = await _db.envelopesDao.getEnvelopeById(id);
      return appSuccess<Envelope?>(row?.toDomain());
    } catch (e) {
      return appFailure(Failure.database(e.toString()));
    }
  }

  @override
  Future<AppResult<Unit>> saveEnvelope(Envelope envelope) async {
    try {
      await _db.envelopesDao.upsertEnvelope(envelope.toCompanion());
      await _sync.enqueueUpdate(
        tableName: 'envelopes',
        recordId: envelope.id,
        payload: envelope.toSyncPayload(),
      );
      return appSuccess(Unit.value);
    } catch (e) {
      return appFailure(Failure.database(e.toString()));
    }
  }

  @override
  Future<AppResult<Unit>> deleteEnvelope(String id) async {
    try {
      await _db.envelopesDao.softDelete(id);
      await _sync.enqueueDelete(
        tableName: 'envelopes',
        recordId: id,
      );
      return appSuccess(Unit.value);
    } catch (e) {
      return appFailure(Failure.database(e.toString()));
    }
  }
}
