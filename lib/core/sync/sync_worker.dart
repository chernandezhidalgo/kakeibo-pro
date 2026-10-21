import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/app_database.dart';
import 'sync_service.dart';

const kSyncTaskName = 'kakeibo_background_sync';
const kSyncTaskUniqueName = 'kakeibo_sync_periodic';

// Logger compartido para el callback en background. Se declara a nivel de
// archivo porque `executeTask` corre en un isolate separado, donde no hay
// instancia de Riverpod/Sentry todavía.
final _log = Logger();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != kSyncTaskName) return Future.value(true);
    try {
      await Supabase.initialize(
        url: const String.fromEnvironment('SUPABASE_URL'),
        anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      );
      final db = await AppDatabase.open();
      final service = SyncService(
        db: db,
        supabase: Supabase.instance.client,
      );
      final result = await service.pushPendingOperations();
      return Future.value(!result.hasErrors);
    } catch (error, stackTrace) {
      // WorkManager descarta el stacktrace si solo devolvemos false; loguear
      // aquí es la única forma de diagnosticar fallos intermitentes de sync.
      _log.e(
        'SyncWorker falló al ejecutar tarea "$taskName"',
        error: error,
        stackTrace: stackTrace,
      );
      return Future.value(false);
    }
  });
}

class SyncWorkerSetup {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      kSyncTaskUniqueName,
      kSyncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  static Future<void> triggerImmediateSync() async {
    await Workmanager().registerOneOffTask(
      '${kSyncTaskUniqueName}_immediate',
      kSyncTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }
}
