// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$biometricHash() => r'e8f7a2d6946921ef4bd9862c8e431a78a7219f1a';

/// Gestiona el estado biométrico y el auto-bloqueo por inactividad.
///
/// Auto-bloqueo: si la app pasa a background por más de [_lockDuration],
/// [isAuthenticated] vuelve a false automáticamente al regresar al primer plano.
///
/// Copied from [Biometric].
@ProviderFor(Biometric)
final biometricProvider =
    AutoDisposeNotifierProvider<Biometric, BiometricState>.internal(
      Biometric.new,
      name: r'biometricProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$biometricHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Biometric = AutoDisposeNotifier<BiometricState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
