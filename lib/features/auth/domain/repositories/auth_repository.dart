import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/kakeibo_user.dart';

/// Contrato del repositorio de autenticación.
///
/// La capa de dominio depende de esta abstracción; la implementación
/// concreta ([AuthRepositoryImpl]) vive en la capa de datos.
///
/// Convención de retorno: [AuthResult]
/// - Éxito → `(data: valor, failure: null)`
/// - Fallo → `(data: null, failure: AuthFailure(mensaje))`
abstract interface class AuthRepository {
  /// Inicia sesión con email y contraseña.
  Future<AuthResult<KakeiboUser>> signIn(String email, String password);

  /// Registra un nuevo usuario con email y contraseña.
  Future<AuthResult<KakeiboUser>> signUp(String email, String password);

  /// Cierra la sesión activa.
  Future<AuthResult<Unit>> signOut();

  /// Retorna el usuario actualmente autenticado, o null si no hay sesión.
  Future<AuthResult<KakeiboUser?>> getCurrentUser();

  /// Stream reactivo del estado de autenticación.
  /// Emite [KakeiboUser] cuando hay sesión activa, null cuando no la hay.
  Stream<KakeiboUser?> get authStateChanges;
}
