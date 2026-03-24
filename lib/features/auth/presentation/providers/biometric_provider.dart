import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_provider.g.dart';

// ── Estado ────────────────────────────────────────────────────────────────────

/// Estado inmutable de autenticación biométrica.
@immutable
class BiometricState {
  const BiometricState({
    required this.isSupported,
    required this.isAuthenticated,
    this.isLoading = false,
  });

  /// El dispositivo tiene hardware biométrico disponible.
  final bool isSupported;

  /// El usuario pasó el desafío biométrico en esta sesión.
  final bool isAuthenticated;

  /// Hay una operación biométrica en curso.
  final bool isLoading;

  BiometricState copyWith({
    bool? isSupported,
    bool? isAuthenticated,
    bool? isLoading,
  }) =>
      BiometricState(
        isSupported: isSupported ?? this.isSupported,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BiometricState &&
          other.isSupported == isSupported &&
          other.isAuthenticated == isAuthenticated &&
          other.isLoading == isLoading);

  @override
  int get hashCode => Object.hash(isSupported, isAuthenticated, isLoading);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Gestiona el estado biométrico y el auto-bloqueo por inactividad.
///
/// Auto-bloqueo: si la app pasa a background por más de [_lockDuration],
/// [isAuthenticated] vuelve a false automáticamente al regresar al primer plano.
@riverpod
class Biometric extends _$Biometric with WidgetsBindingObserver {
  final _localAuth = LocalAuthentication();
  DateTime? _pausedAt;

  static const _lockDuration = Duration(minutes: 5);

  @override
  BiometricState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));

    // Verificar soporte de forma asíncrona sin bloquear build()
    _checkSupport();

    return const BiometricState(
      isSupported: false,
      isAuthenticated: false,
      isLoading: true,
    );
  }

  // ── Métodos públicos ────────────────────────────────────────────────────

  /// Lanza el diálogo nativo de biometría / PIN.
  Future<void> authenticateWithBiometrics() async {
    if (!state.isSupported) return;
    state = state.copyWith(isLoading: true);
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason:
            'Desbloquea KakeiboPro con tu huella digital o Face ID',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      state = state.copyWith(isAuthenticated: authenticated, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Bloquea la app manualmente (ej. botón "Bloquear ahora").
  void lockApp() => state = state.copyWith(isAuthenticated: false);

  // ── Auto-bloqueo ────────────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 'state' aquí es el parámetro del ciclo de vida (AppLifecycleState).
    // El estado del notifier se accede con 'this.state' para evitar ambigüedad.
    switch (state) {
      case AppLifecycleState.paused:
        _pausedAt = DateTime.now();
      case AppLifecycleState.resumed:
        if (_pausedAt != null) {
          final elapsed = DateTime.now().difference(_pausedAt!);
          if (elapsed >= _lockDuration && this.state.isAuthenticated) {
            this.state = this.state.copyWith(isAuthenticated: false);
          }
          _pausedAt = null;
        }
      default:
        break;
    }
  }

  // ── Privado ─────────────────────────────────────────────────────────────

  Future<void> _checkSupport() async {
    // local_auth no está disponible en web — biometría deshabilitada.
    if (kIsWeb) {
      // await Future.value() cede el control al event loop, permitiendo que
      // build() retorne y el provider quede inicializado antes de tocar state.
      await Future.value();
      state = state.copyWith(isSupported: false, isLoading: false);
      return;
    }
    final canCheck = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    state = state.copyWith(
      isSupported: canCheck || isDeviceSupported,
      isLoading: false,
    );
  }
}
