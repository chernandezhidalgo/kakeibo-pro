import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';

/// Contrato del repositorio de familia.
///
/// Todas las operaciones siguen la convención [AuthResult]:
/// - Éxito → `(data: valor, failure: null)`
/// - Fallo → `(data: null, failure: AuthFailure(mensaje))`
abstract interface class FamilyRepository {
  /// Crea una nueva familia con el usuario actual como Admin.
  Future<AuthResult<KakeiboFamily>> createFamily(String name);

  /// Retorna la familia con sus miembros dado un [familyId].
  Future<AuthResult<KakeiboFamily>> getFamily(String familyId);

  /// Retorna la familia del usuario autenticado actualmente,
  /// o `null` si aún no pertenece a ninguna.
  Future<AuthResult<KakeiboFamily?>> getFamilyForCurrentUser();

  /// Añade un miembro existente (con userId conocido) a la familia.
  Future<AuthResult<FamilyMember>> addMember({
    required String familyId,
    required String userId,
    required String displayName,
    required FamilyMemberRole role,
  });

  /// Genera un token UUID de invitación válido 48 h y crea un miembro
  /// "pendiente" en la tabla family_members (sin userId aún).
  /// Retorna el token generado.
  Future<AuthResult<String>> generateInvitationToken(
    String familyId,
    FamilyMemberRole role,
  );

  /// Acepta una invitación: verifica el token, comprueba que no haya
  /// expirado y asigna el userId del usuario autenticado al miembro.
  Future<AuthResult<FamilyMember>> acceptInvitation(String token);

  /// Retorna todos los miembros activos de una familia.
  Future<AuthResult<List<FamilyMember>>> getFamilyMembers(String familyId);
}
