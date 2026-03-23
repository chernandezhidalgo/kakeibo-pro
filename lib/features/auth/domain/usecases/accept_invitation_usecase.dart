import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/family_repository.dart';

/// Caso de uso: aceptar una invitación mediante su token.
///
/// Verifica validez y expiración del token, luego asigna el userId
/// del usuario autenticado al miembro pendiente.
class AcceptInvitationUseCase {
  const AcceptInvitationUseCase(this._repository);

  final FamilyRepository _repository;

  Future<AuthResult<FamilyMember>> call(String token) =>
      _repository.acceptInvitation(token);
}
