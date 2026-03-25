import 'package:kakeibo_pro/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:kakeibo_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/kakeibo_user.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:kakeibo_pro/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:kakeibo_pro/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:kakeibo_pro/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

// ── Infraestructura ───────────────────────────────────────────────────────────

/// Provee el [SupabaseClient] singleton de la aplicación.
/// keepAlive: true → vive durante toda la sesión de la app.
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

/// Provee el datasource de autenticación de Supabase.
@Riverpod(keepAlive: true)
SupabaseAuthDatasource authDatasource(AuthDatasourceRef ref) {
  return SupabaseAuthDatasource(ref.watch(supabaseClientProvider));
}

/// Provee la implementación del repositorio de autenticación.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authDatasourceProvider));
}

// ── Casos de uso ──────────────────────────────────────────────────────────────

@riverpod
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignUpUseCase signUpUseCase(SignUpUseCaseRef ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}

// ── Estado de autenticación ───────────────────────────────────────────────────

/// Stream del usuario autenticado.
/// Emite [KakeiboUser] cuando hay sesión activa, null cuando no.
/// Usado por GoRouter para redirigir automáticamente tras login/logout.
@riverpod
Stream<KakeiboUser?> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

/// ID del usuario autenticado actualmente.
/// Devuelve cadena vacía si aún no hay sesión activa.
/// Usar como: `ref.watch(currentUserIdProvider)`
final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.id ?? '';
});
