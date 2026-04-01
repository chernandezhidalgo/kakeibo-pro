import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<QueryExecutor> openDatabaseConnection(
  String name, {
  String? encryptionKey,
}) async {
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dir.path, '$name.db');
  return NativeDatabase.createInBackground(
    File(dbPath),
    setup: encryptionKey != null
        ? (db) => db.execute("PRAGMA key = '$encryptionKey'")
        : null,
  );
}
