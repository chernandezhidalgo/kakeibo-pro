// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'deacb610ba5a2a6164a9836f0ed10a1e9de80426';

/// Provee el [SupabaseClient] singleton de la aplicación.
/// keepAlive: true → vive durante toda la sesión de la app.
///
/// Copied from [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = Provider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseClientRef = ProviderRef<SupabaseClient>;
String _$authDatasourceHash() => r'd3c4191b5ee8daa6ef2bcb5c09c3ce2f215613f8';

/// Provee el datasource de autenticación de Supabase.
///
/// Copied from [authDatasource].
@ProviderFor(authDatasource)
final authDatasourceProvider = Provider<SupabaseAuthDatasource>.internal(
  authDatasource,
  name: r'authDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthDatasourceRef = ProviderRef<SupabaseAuthDatasource>;
String _$authRepositoryHash() => r'1da674f87c16a6fefd5cdf52122a83871ed174b5';

/// Provee la implementación del repositorio de autenticación.
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$signInUseCaseHash() => r'd8c4ca8799d3c785d724fcb12259fb8cb5c6f7aa';

/// See also [signInUseCase].
@ProviderFor(signInUseCase)
final signInUseCaseProvider = AutoDisposeProvider<SignInUseCase>.internal(
  signInUseCase,
  name: r'signInUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInUseCaseRef = AutoDisposeProviderRef<SignInUseCase>;
String _$signUpUseCaseHash() => r'4201daf5f96493848da629b32fddadef84544cd7';

/// See also [signUpUseCase].
@ProviderFor(signUpUseCase)
final signUpUseCaseProvider = AutoDisposeProvider<SignUpUseCase>.internal(
  signUpUseCase,
  name: r'signUpUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpUseCaseRef = AutoDisposeProviderRef<SignUpUseCase>;
String _$signOutUseCaseHash() => r'3e06d6c315dc4710dd995e6114538ae28f4c3336';

/// See also [signOutUseCase].
@ProviderFor(signOutUseCase)
final signOutUseCaseProvider = AutoDisposeProvider<SignOutUseCase>.internal(
  signOutUseCase,
  name: r'signOutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignOutUseCaseRef = AutoDisposeProviderRef<SignOutUseCase>;
String _$authStateHash() => r'bfd9848562eb215613b08caa643317d347ed3646';

/// Stream del usuario autenticado.
/// Emite [KakeiboUser] cuando hay sesión activa, null cuando no.
/// Usado por GoRouter para redirigir automáticamente tras login/logout.
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<KakeiboUser?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<KakeiboUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
