import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/app_database.dart';
import 'sync_service.dart';

// Nombre único de la tarea — no cambiar después de publicar en producción
const kSyncTaskName = 'kakeibo_background_sync';
const kSyncTaskUniqueName = 'kakeibo_sync_periodic';

/// Callback ejecutado por WorkManager en un isolate de background.
///
/// IMPORTANTE: debe estar en top-level (no dentro de una clase) y marcado
/// con @pragma('vm:entry-point') para que no sea eliminado por tree-shaking.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != kSyncTaskName) return Future.value(true);

    try {
      // En background no hay contexto Flutter — inicializar Supabase manualmente
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

      // WorkManager espera true = éxito, false = reintentar
      return Future.value(!result.hasErrors);
    } catch (_) {
      // false hace que WorkManager reintente según su política exponencial
      return Future.value(false);
    }
  });
}

class SyncWorkerSetup {
  /// Llamar una vez al iniciar la app (en main.dart), antes de runApp().
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // cambiar a true en desarrollo para ver logs en logcat
    );
  }

  /// Registra la tarea periódica (cada 15 min — mínimo que permite WorkManager).
  ///
  /// [ExistingWorkPolicy.keep] garantiza que si ya existe una tarea registrada
  /// no la duplique al reiniciar la app.
  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      kSyncTaskUniqueName,
      kSyncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  /// Dispara un sync inmediato one-shot.
  ///
  /// Llamar cuando el usuario recupera conexión ([ConnectivityListener])
  /// o cuando realiza una operación que requiere sincronización urgente.
  static Future<void> triggerImmediateSync() async {
    await Workmanager().registerOneOffTask(
      '${kSyncTaskUniqueName}_immediate',
      kSyncTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }
}
