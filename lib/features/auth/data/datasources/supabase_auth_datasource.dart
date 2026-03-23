import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/kakeibo_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Fuente de datos de autenticación respaldada por Supabase Auth.
///
/// La URL y la ANON_KEY se inyectan en tiempo de compilación mediante
/// `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
/// y se leen con [String.fromEnvironment] en [main.dart].
///
/// Nota: el tipo [User] utilizado internamente pertenece a supabase_flutter
/// y es distinto de [KakeiboUser] (entidad de dominio propia).
class SupabaseAuthDatasource {
  const SupabaseAuthDatasource(this._client);

  final SupabaseClient _client;

  // ── Mapeo Supabase → dominio ──────────────────────────────────────────

  KakeiboUser _mapUser(User user) => KakeiboUser(
        id: user.id,
        email: user.email ?? '',
        isEmailVerified: user.emailConfirmedAt != null,
        createdAt: DateTime.parse(user.createdAt),
      );

  // ── Operaciones de autenticación ──────────────────────────────────────

  Future<AuthResult<KakeiboUser>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return (
          data: null,
          failure: const AuthFailure(
            'No se pudo obtener el usuario tras el inicio de sesión.',
          ),
        );
      }
      return (data: _mapUser(user), failure: null);
    } on AuthException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error inesperado al iniciar sesión: $e'),
      );
    }
  }

  Future<AuthResult<KakeiboUser>> signUp(
    String email,
    String password,
  ) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return (
          data: null,
          failure: const AuthFailure(
            'No se pudo crear el usuario. Intenta de nuevo.',
          ),
        );
      }
      return (data: _mapUser(user), failure: null);
    } on AuthException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error inesperado al registrarse: $e'),
      );
    }
  }

  Future<AuthResult<Unit>> signOut() async {
    try {
      await _client.auth.signOut();
      return (data: Unit.value, failure: null);
    } on AuthException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error al cerrar sesión: $e'),
      );
    }
  }

  Future<AuthResult<KakeiboUser?>> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      return (data: user == null ? null : _mapUser(user), failure: null);
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error al obtener usuario actual: $e'),
      );
    }
  }

  Stream<KakeiboUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((authState) {
      final user = authState.session?.user;
      return user == null ? null : _mapUser(user);
    });
  }
}
