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

  KakeiboFamily _mapFamily(
    Map<String, dynamic> data,
    List<FamilyMember> members,
  ) =>
      KakeiboFamily(
        id: data['id'] as String,
        name: data['name'] as String,
        createdAt: _parseTimestamp(data['created_at']),
        members: members,
      );

  FamilyMember _mapMember(Map<String, dynamic> data) => FamilyMember(
        id: data['id'] as String,
        familyId: data['family_id'] as String,
        // user_id es nullable en DB (miembro pendiente de invitación)
        userId: data['user_id'] as String? ?? '',
        displayName: data['display_name'] as String? ?? 'Miembro',
        role: _roleFromString(data['role'] as String),
        avatarEmoji: data['avatar_emoji'] as String? ?? '👤',
        isActive: data['is_active'] as bool? ?? true,
        createdAt: _parseTimestamp(data['created_at']),
      );

  DateTime _parseTimestamp(Object? value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    return DateTime.now().toUtc();
  }

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
  Future<AuthResult<KakeiboFamily>> createFamily(String name) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        return (
          data: null,
          failure: const AuthFailure('Usuario no autenticado'),
        );
      }

      // La política de lectura de families exige ser miembro, y el
      // miembro todavía no existe. create_family inserta los dos.
      final raw = await _client.rpc(
        'create_family',
        params: {'p_name': name},
      );
      final payload = switch (raw) {
        final Map rawMap => Map<String, dynamic>.from(rawMap),
        _ => null,
      };
      final familyRaw = payload?['family'];
      final memberRaw = payload?['member'];
      if (familyRaw is! Map || memberRaw is! Map) {
        return (
          data: null,
          failure: const AuthFailure('No se pudo crear la familia'),
        );
      }

      return (
        data: _mapFamily(
          Map<String, dynamic>.from(familyRaw),
          [_mapMember(Map<String, dynamic>.from(memberRaw))],
        ),
        failure: null,
      );
    } on PostgrestException catch (e) {
      return (data: null, failure: AuthFailure(e.message));
    } catch (e) {
      return (data: null, failure: AuthFailure('Error al crear familia: $e'));
    }
  }

  @override
  Future<AuthResult<KakeiboFamily>> getFamily(String familyId) async {
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
  Future<AuthResult<KakeiboFamily?>> getFamilyForCurrentUser() async {
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

      // El esquema real guarda la invitación con las columnas confirmadas.
      await _client.from('family_members').insert({
        'family_id': familyId,
        'user_id': null,
        'role': _roleToString(role),
        'is_active': false,
        'invitation_token': token,
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

      // La fila pendiente no es visible por RLS. El RPC valida el token,
      // la caducidad y que el rol de la invitación no cambie.
      final raw = await _client.rpc(
        'accept_family_invitation',
        params: {'p_token': token.trim()},
      );
      final memberData = switch (raw) {
        final Map rawMap => Map<String, dynamic>.from(rawMap),
        _ => null,
      };
      if (memberData == null) {
        return (
          data: null,
          failure: const AuthFailure('Token de invitación inválido'),
        );
      }

      return (data: _mapMember(memberData), failure: null);
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
