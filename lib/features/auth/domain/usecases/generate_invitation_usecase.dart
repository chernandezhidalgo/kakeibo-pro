import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/family_repository.dart';

/// Caso de uso: generar un token de invitación válido por 48 horas.
///
/// El token se asocia a un miembro "pendiente" en family_members
/// que será activado cuando alguien lo acepte con [AcceptInvitationUseCase].
class GenerateInvitationUseCase {
  const GenerateInvitationUseCase(this._repository);

  final FamilyRepository _repository;

  Future<AuthResult<String>> call(
    String familyId,
    FamilyMemberRole role,
  ) =>
      _repository.generateInvitationToken(familyId, role);
}
