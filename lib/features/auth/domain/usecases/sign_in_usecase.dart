import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/kakeibo_user.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso: iniciar sesión con email y contraseña.
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthResult<KakeiboUser>> call(String email, String password) =>
      _repository.signIn(email, password);
}
