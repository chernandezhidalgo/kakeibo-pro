import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/family_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Implementación de [FamilyRepository] respaldada por Supabase.
///
/// Tablas requeridas con RLS activo:
///   - families        (id, name, created_at)
///   - family_members  (id, family_id, user_id [nullable], display_name,
///                      role, avatar_emoji, is_active, created_at,
///                      invitation_token [nullable], invitation_expires_at [nullable])
class FamilyRepositoryImpl implements FamilyRepository {
  const FamilyRepositoryImpl(this._client);

  final SupabaseClient _client;

  // ── Mapeo Supabase → dominio ──────────────────────────────────────────

  Family _mapFamily(
    Map<String, dynamic> data,
    List<FamilyMember> members,
  ) =>
      Family(
        id: data['id'] as String,
        name: data['name'] as String,
        createdAt: DateTime.parse(data['created_at'] as String),
        members: members,
      );

  FamilyMember _mapMember(Map<String, dynamic> data) => FamilyMember(
        id: data['id'] as String,
        familyId: data['family_id'] as String,
        // user_id es nullable en DB (miembro pendiente de invitación)
        userId: data['user_id'] as String? ?? '',
        displayName: data['display_name'] as String,
        role: _roleFromString(data['role'] as String),
        avatarEmoji: data['avatar_emoji'] as String? ?? '👤',
        isActive: data['is_active'] as bool? ?? true,
        createdAt: DateTime.parse(data['created_at'] as String),
      );

  String _roleToString(FamilyMemberRole role) => switch (role) {
        FamilyMemberRole.admin => 'admin',
        FamilyMemberRole.coAdmin => 'co_admin',
        FamilyMemberRole.adolescent => 'adolescent',
        FamilyMemberRole.child => 'child',
        FamilyMemberRole.viewer => 'viewer',
      };

  FamilyMemberRole _roleFromString(String role) => switch (role) {
        'admin' => FamilyMemberRole.admin,
        'co_admin' => FamilyMemberRole.coAdmin,
        'adolescent' => FamilyMemberRole.adolescent,
        'child' => FamilyMemberRole.child,
        'viewer' => FamilyMemberRole.viewer,
        _ => FamilyMemberRole.viewer,
      };

  // ── Operaciones ───────────────────────────────────────────────────────

  @override
  Future<AuthResult<Family>> createFamily(String name) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        return (
          data: null,
          failure: const AuthFailure('Usuario no autenticado'),
        );
      }

      // 1. Insertar familia
      final familyData = await _client
          .from('families')
          .insert({'name': name})
          .select()
          .single();

      final familyId = familyData['id'] as String;

      // 2. Insertar al creador como admin
      // TODO: displayName debería venir del perfil de usuario en Fase 2
      final displayName =
          currentUser.email?.split('@').first ?? 'Admin';

      final memberData = await _client
          .from('family_members')
          .insert({
            'family_id': familyId,
            'user_id': currentUser.id,
            'display_name': displayName,
            'role': 'admin',
            'is_active': true,
          })
          .select()
          .single();

      return (
        data: _mapFamily(familyData, [_mapMember(memberData)]),
        failure: null,
      );
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (data: null, failure: AuthFailure('Error al crear familia: $e'));
    }
  }

  @override
  Future<AuthResult<Family>> getFamily(String familyId) async {
    try {
      final familyData = await _client
          .from('families')
          .select()
          .eq('id', familyId)
          .single();

      final membersData = await _client
          .from('family_members')
          .select()
          .eq('family_id', familyId);

      final members =
          membersData.map((m) => _mapMember(m)).toList();

      return (data: _mapFamily(familyData, members), failure: null);
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (data: null, failure: AuthFailure('Error al obtener familia: $e'));
    }
  }

  @override
  Future<AuthResult<Family?>> getFamilyForCurrentUser() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return (data: null, failure: null);

      // Buscar a qué familia pertenece el usuario actual
      final memberData = await _client
          .from('family_members')
          .select('family_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (memberData == null) return (data: null, failure: null);

      return getFamily(memberData['family_id'] as String);
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error al buscar familia del usuario: $e'),
      );
    }
  }

  @override
  Future<AuthResult<FamilyMember>> addMember({
    required String familyId,
    required String userId,
    required String displayName,
    required FamilyMemberRole role,
  }) async {
    try {
      final data = await _client
          .from('family_members')
          .insert({
            'family_id': familyId,
            'user_id': userId,
            'display_name': displayName,
            'role': _roleToString(role),
            'is_active': true,
          })
          .select()
          .single();

      return (data: _mapMember(data), failure: null);
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error al agregar miembro: $e'),
      );
    }
  }

  @override
  Future<AuthResult<String>> generateInvitationToken(
    String familyId,
    FamilyMemberRole role,
  ) async {
    try {
      final token = const Uuid().v4();
      final expiresAt = DateTime.now().toUtc().add(const Duration(hours: 48));

      // Crea un miembro "pendiente" sin userId, con el token de invitación
      await _client.from('family_members').insert({
        'family_id': familyId,
        'user_id': null,
        'display_name': 'Pendiente',
        'role': _roleToString(role),
        'is_active': false,
        'invitation_token': token,
        'invitation_expires_at': expiresAt.toIso8601String(),
      });

      return (data: token, failure: null);
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error al generar invitación: $e'),
      );
    }
  }

  @override
  Future<AuthResult<FamilyMember>> acceptInvitation(String token) async {
    try {
      final currentUserId = _client.auth.currentUser?.id;
      if (currentUserId == null) {
        return (
          data: null,
          failure: const AuthFailure('Usuario no autenticado'),
        );
      }

      // Buscar el miembro pendiente con ese token
      final memberData = await _client
          .from('family_members')
          .select()
          .eq('invitation_token', token)
          .maybeSingle();

      if (memberData == null) {
        return (
          data: null,
          failure: const AuthFailure('Token de invitación inválido'),
        );
      }

      // Verificar expiración
      final expiresAt =
          DateTime.parse(memberData['invitation_expires_at'] as String);
      if (DateTime.now().isAfter(expiresAt)) {
        return (
          data: null,
          failure: const AuthFailure('El token de invitación ha expirado'),
        );
      }

      // Asignar el userId al miembro pendiente y activarlo
      final updated = await _client
          .from('family_members')
          .update({
            'user_id': currentUserId,
            'is_active': true,
            'invitation_token': null,
            'invitation_expires_at': null,
          })
          .eq('id', memberData['id'] as String)
          .select()
          .single();

      return (data: _mapMember(updated), failure: null);
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error al aceptar invitación: $e'),
      );
    }
  }

  @override
  Future<AuthResult<List<FamilyMember>>> getFamilyMembers(
    String familyId,
  ) async {
    try {
      final data = await _client
          .from('family_members')
          .select()
          .eq('family_id', familyId);

      final members = data.map((m) => _mapMember(m)).toList();
      return (data: members, failure: null);
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (
        data: null,
        failure: AuthFailure('Error al obtener miembros: $e'),
      );
    }
  }
}
