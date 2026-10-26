import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

Future<QueryExecutor> openDatabaseConnection(
  String name, {
  String? encryptionKey,
}) async {
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dir.path, '$name.db');

  // En el isolate principal: en Android viejo hace falta cargar sqlcipher
  // desde Java antes de que el isolate de Drift abra la base.
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
  }

  return NativeDatabase.createInBackground(
    File(dbPath),
    isolateSetup: () async {
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    },
    setup: (db) {
      final cipherRows = db.select('PRAGMA cipher_version');
      final cipherVersion = cipherRows.isEmpty
          ? ''
          : '${cipherRows.first.columnAt(0) ?? ''}'.trim();
      if (cipherVersion.isEmpty) {
        throw StateError(
          'SQLCipher no está disponible: PRAGMA cipher_version no devolvió '
          'versión. En Android hay que cargar libsqlcipher.so, no libsqlite3.so.',
        );
      }

      if (encryptionKey != null) {
        // PRAGMA no acepta parámetros ligados. La clave es hex; igual se
        // escapan comillas simples para que el literal SQL sea válido.
        final escapedKey = encryptionKey.replaceAll("'", "''");
        db.execute("PRAGMA key = '$escapedKey'");
      }
    },
  );
}
