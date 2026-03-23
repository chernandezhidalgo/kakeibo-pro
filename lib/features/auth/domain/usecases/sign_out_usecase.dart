import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso: cerrar la sesión activa.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthResult<Unit>> call() => _repository.signOut();
}
