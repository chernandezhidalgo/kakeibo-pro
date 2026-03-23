import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_worker.dart';

/// Escucha cambios de conectividad y dispara un sync inmediato
/// cada vez que el dispositivo recupera acceso a la red.
class ConnectivityListener {
  /// Inicia el listener. Llamar una vez en [main()] antes de [runApp()].
  ///
  /// No retorna — la suscripción vive durante todo el ciclo de vida de la app.
  static void start() {
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any(
        (r) =>
            r == ConnectivityResult.mobile ||
            r == ConnectivityResult.wifi ||
            r == ConnectivityResult.ethernet,
      );

      if (hasConnection) {
        // Dispara sync inmediato al recuperar conexión
        SyncWorkerSetup.triggerImmediateSync();
      }
    });
  }
}
