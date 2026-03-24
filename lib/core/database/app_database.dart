import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/envelopes_table.dart';
import 'tables/transactions_table.dart';
import 'tables/family_members_table.dart';
import 'tables/kakeibo_reflections_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/user_profiles_table.dart';
import 'daos/envelopes_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/sync_queue_dao.dart';
import 'daos/user_profiles_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    EnvelopesTable,
    TransactionsTable,
    FamilyMembersTable,
    KakeiboReflectionsTable,
    SyncQueueTable,
    UserProfilesTable,
  ],
  daos: [
    EnvelopesDao,
    TransactionsDao,
    SyncQueueDao,
    UserProfilesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super._openConnection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Migraciones futuras se agregan aquí por número de versión.
        // Ejemplo: if (from < 2) { await m.addColumn(envelopesTable, envelopesTable.newColumn); }
      },
      beforeOpen: (details) async {
        // Activa claves foráneas en SQLite/SQLCipher
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Abre la base de datos con nombre 'kakeibo_pro'.
  ///
  /// ⚠️ ESTADO: Por ahora usa driftDatabase() estándar de drift_flutter.
  /// La integración de encriptación con SQLCipher requiere verificar la API
  /// exacta según la versión instalada. Ver:
  /// https://drift.simonbinder.eu/docs/platforms/encryption/
  ///
  /// Una vez confirmada la API, se deberá pasar la clave obtenida de
  /// [_getOrCreateEncryptionKey()] al conector nativo de SQLCipher.
  static Future<AppDatabase> open() async {
    // En plataformas nativas preparamos la clave de encriptación (SQLCipher).
    // En web este paso se omite porque FlutterSecureStorage no está disponible.
    if (!kIsWeb) {
      await _getOrCreateEncryptionKey();
    }

    return AppDatabase(
      driftDatabase(
        name: 'kakeibo_pro',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
          onResult: (result) {
            if (result.missingFeatures.isNotEmpty) {
              debugPrint(
                'Drift web: usando implementación de respaldo '
                'por falta de: ${result.missingFeatures}',
              );
            }
          },
        ),
      ),
    );
  }

  /// Genera y persiste una clave de 256 bits en Flutter Secure Storage.
  /// En producción se debe usar [dart:math Random.secure()] en lugar de
  /// la semilla basada en timestamp.
  static Future<String> _getOrCreateEncryptionKey() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    const keyName = 'kakeibo_db_encryption_key';

    final existingKey = await storage.read(key: keyName);
    if (existingKey != null) return existingKey;

    // TODO (producción): reemplazar por Random.secure() de dart:math
    final bytes = List<int>.generate(
      32,
      (i) => (DateTime.now().microsecondsSinceEpoch + i) % 256,
    );
    final newKey =
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    await storage.write(key: keyName, value: newKey);
    return newKey;
  }

  /// Retorna la ruta absoluta del archivo de base de datos en el dispositivo.
  static Future<String> getDatabasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'kakeibo_pro.db');
  }
}
