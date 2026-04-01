import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

Future<QueryExecutor> openDatabaseConnection(
  String name, {
  String? encryptionKey,
}) async {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: name,
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    if (result.missingFeatures.isNotEmpty) {
      debugPrint(
        'Drift web: usando implementación de respaldo '
        'por falta de: ${result.missingFeatures}',
      );
    }
    return result.resolvedExecutor;
  });
}
