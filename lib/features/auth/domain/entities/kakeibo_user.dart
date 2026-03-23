import 'package:freezed_annotation/freezed_annotation.dart';

part 'kakeibo_user.freezed.dart';

/// Entidad de dominio que representa al usuario autenticado en KakeiboPro.
///
/// Renombrado de `AuthUser` → `KakeiboUser` para evitar conflicto con
/// `AuthUser` del paquete `supabase_flutter`.
///
/// Es una proyección mínima de los datos de Supabase Auth — no contiene
/// información de perfil familiar (eso es [FamilyMember]).
@freezed
class KakeiboUser with _$KakeiboUser {
  const factory KakeiboUser({
    required String id,
    required String email,
    required bool isEmailVerified,
    required DateTime createdAt,
  }) = _KakeiboUser;
}
