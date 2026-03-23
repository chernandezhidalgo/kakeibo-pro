import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';

part 'family.freezed.dart';

/// Entidad de dominio que representa la unidad familiar en KakeiboPro.
///
/// Contiene la lista de [FamilyMember] cargados. Una familia tiene
/// exactamente un miembro con rol [FamilyMemberRole.admin].
@freezed
class Family with _$Family {
  const factory Family({
    required String id,
    @Default('Familia Hernández-Romero') String name,
    required DateTime createdAt,
    @Default([]) List<FamilyMember> members,
  }) = _Family;
}
