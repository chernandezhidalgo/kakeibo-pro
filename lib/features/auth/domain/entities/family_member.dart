import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_member.freezed.dart';

/// Roles disponibles para un miembro de familia en KakeiboPro.
enum FamilyMemberRole {
  admin,
  coAdmin,
  adolescent,
  child,
  viewer,
}

/// Entidad de dominio que representa a un miembro de la familia.
///
/// Inmutable gracias a [freezed]. Provee [copyWith], [==] y [hashCode]
/// de forma automática.
@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String id,
    required String familyId,
    required String userId,
    required String displayName,
    required FamilyMemberRole role,
    @Default('👤') String avatarEmoji,
    required bool isActive,
    required DateTime createdAt,
  }) = _FamilyMember;
}
