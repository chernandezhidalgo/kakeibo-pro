import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_worker.dart';

/// Escucha cambios de conectividad y dispara un sync inmediato
/// cada vez que el dispositivo recupera acceso a la red.
class ConnectivityListener {
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Inicia el listener. Llamar una vez en [main()] antes de [runApp()].
  static void start() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
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

  /// Detiene el listener y libera recursos.
  static void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}
