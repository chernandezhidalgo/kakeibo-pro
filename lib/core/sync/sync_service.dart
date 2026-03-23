import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';

class SyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;

  SyncService({required AppDatabase db, required SupabaseClient supabase})
      : _db = db,
        _supabase = supabase;

  /// Envía todas las operaciones pendientes de la cola a Supabase.
  /// Llama esto cuando hay conexión disponible.
  Future<SyncResult> pushPendingOperations() async {
    final pending = await _db.syncQueueDao.getPending();
    if (pending.isEmpty) return const SyncResult(synced: 0, failed: 0);

    int synced = 0;
    int failed = 0;

    for (final op in pending) {
      try {
        final payload = jsonDecode(op.payload) as Map<String, dynamic>;

        switch (op.operationType) {
          case 'INSERT':
          case 'UPDATE':
            await _supabase.from(op.tableName_).upsert(payload);
          case 'DELETE':
            await _supabase
                .from(op.tableName_)
                .delete()
                .eq('id', op.recordId);
          default:
            throw Exception(
                'Tipo de operación desconocido: ${op.operationType}');
        }

        await _db.syncQueueDao.markDone(op.id);
        synced++;
      } catch (e) {
        await _db.syncQueueDao.markFailed(op.id, e.toString());
        failed++;
        // No detenemos el loop — seguimos con las demás operaciones
      }
    }

    return SyncResult(synced: synced, failed: failed);
  }

  /// Delta sync: descarga registros modificados desde Supabase
  /// para las tablas principales. Usa [since] como cursor temporal.
  Future<void> pullRemoteChanges(String familyId, DateTime since) async {
    await _pullEnvelopes(familyId, since);
    await _pullTransactions(familyId, since);
  }

  Future<void> _pullEnvelopes(String familyId, DateTime since) async {
    try {
      final rows = await _supabase
          .from('envelopes')
          .select()
          .eq('family_id', familyId)
          .gte('updated_at', since.toIso8601String());

      for (final row in rows as List<dynamic>) {
        final map = row as Map<String, dynamic>;
        await _db.envelopesDao.upsertEnvelope(
          EnvelopesTableCompanion.insert(
            id: map['id'] as String,
            familyId: map['family_id'] as String,
            name: map['name'] as String,
            category: map['category'] as String,
            budgetedAmount:
                Value((map['budgeted_amount'] as num).toDouble()),
            spentAmount: Value((map['spent_amount'] as num).toDouble()),
            currency: Value(map['currency'] as String? ?? 'CRC'),
            isActive: Value(map['is_active'] as bool? ?? true),
            sortOrder: Value(map['sort_order'] as int? ?? 0),
            isSynced: const Value(true),
            updatedAt:
                Value(DateTime.parse(map['updated_at'] as String)),
          ),
        );
      }
    } catch (e) {
      // Best-effort: el pull no debe bloquear la app
      // TODO: integrar Sentry cuando esté disponible
      rethrow;
    }
  }

  Future<void> _pullTransactions(String familyId, DateTime since) async {
    try {
      final rows = await _supabase
          .from('transactions')
          .select()
          .eq('family_id', familyId)
          .gte('updated_at', since.toIso8601String());

      for (final row in rows as List<dynamic>) {
        final map = row as Map<String, dynamic>;
        await _db.transactionsDao.upsertTransaction(
          TransactionsTableCompanion.insert(
            id: map['id'] as String,
            familyId: map['family_id'] as String,
            createdByUserId: map['created_by_user_id'] as String,
            type: map['type'] as String,
            amount: (map['amount'] as num).toDouble(),
            description: map['description'] as String,
            transactionDate:
                DateTime.parse(map['transaction_date'] as String),
            envelopeId: Value(map['envelope_id'] as String?),
            currency: Value(map['currency'] as String? ?? 'CRC'),
            merchant: Value(map['merchant'] as String?),
            sourceType: Value(map['source_type'] as String?),
            isSynced: const Value(true),
            updatedAt:
                Value(DateTime.parse(map['updated_at'] as String)),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

class SyncResult {
  final int synced;
  final int failed;

  const SyncResult({required this.synced, required this.failed});

  bool get hasErrors => failed > 0;

  @override
  String toString() => 'SyncResult(synced: $synced, failed: $failed)';
}

// Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = Supabase.instance.client;
  return SyncService(db: db, supabase: supabase);
});
