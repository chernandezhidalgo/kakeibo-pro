import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/kakeibo_user.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/auth_repository.dart';

/// Implementación concreta de [AuthRepository] usando [SupabaseAuthDatasource].
///
/// Actúa como adaptador entre la abstracción del dominio y la fuente
/// de datos concreta de Supabase. En esta versión delega directamente;
/// en el futuro podría agregar caché local con Drift.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final SupabaseAuthDatasource _datasource;

  @override
  Future<AuthResult<KakeiboUser>> signIn(String email, String password) =>
      _datasource.signIn(email, password);

  @override
  Future<AuthResult<KakeiboUser>> signUp(String email, String password) =>
      _datasource.signUp(email, password);

  @override
  Future<AuthResult<Unit>> signOut() => _datasource.signOut();

  @override
  Future<AuthResult<KakeiboUser?>> getCurrentUser() =>
      _datasource.getCurrentUser();

  @override
  Stream<KakeiboUser?> get authStateChanges => _datasource.authStateChanges;
}
