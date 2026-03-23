import 'package:kakeibo_pro/features/auth/data/repositories/family_repository_impl.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/family_repository.dart';
import 'package:kakeibo_pro/features/auth/domain/usecases/accept_invitation_usecase.dart';
import 'package:kakeibo_pro/features/auth/domain/usecases/create_family_usecase.dart';
import 'package:kakeibo_pro/features/auth/domain/usecases/generate_invitation_usecase.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_provider.g.dart';

// ── Repositorio ───────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
FamilyRepository familyRepository(FamilyRepositoryRef ref) {
  return FamilyRepositoryImpl(ref.watch(supabaseClientProvider));
}

// ── Casos de uso ──────────────────────────────────────────────────────────────

@riverpod
CreateFamilyUseCase createFamilyUseCase(CreateFamilyUseCaseRef ref) {
  return CreateFamilyUseCase(ref.watch(familyRepositoryProvider));
}

@riverpod
GenerateInvitationUseCase generateInvitationUseCase(
  GenerateInvitationUseCaseRef ref,
) {
  return GenerateInvitationUseCase(ref.watch(familyRepositoryProvider));
}

@riverpod
AcceptInvitationUseCase acceptInvitationUseCase(
  AcceptInvitationUseCaseRef ref,
) {
  return AcceptInvitationUseCase(ref.watch(familyRepositoryProvider));
}

// ── Estado de familia ─────────────────────────────────────────────────────────

/// Carga la familia del usuario autenticado actualmente.
/// Retorna null si el usuario no pertenece a ninguna familia aún.
/// Es un [FutureProvider] porque la consulta a Supabase es asíncrona.
@riverpod
Future<Family?> currentFamily(CurrentFamilyRef ref) async {
  // Dependemos del usuario autenticado: si cambia, recargamos
  final user = await ref.watch(authStateProvider.future);
  if (user == null) return null;

  final result =
      await ref.watch(familyRepositoryProvider).getFamilyForCurrentUser();

  // Si hay fallo de red o DB, devolvemos null (sin lanzar excepción)
  return result.data;
}

/// Retorna todos los miembros de la familia actual.
@riverpod
Future<List<FamilyMember>> familyMembers(FamilyMembersRef ref) async {
  final family = await ref.watch(currentFamilyProvider.future);
  if (family == null) return [];

  final result = await ref
      .watch(familyRepositoryProvider)
      .getFamilyMembers(family.id);

  return result.data ?? [];
}

/// Retorna el rol del usuario autenticado dentro de su familia.
///
/// Es un [Provider] síncrono que observa los [AsyncValue] de los providers
/// de arriba y devuelve null mientras cargan o si no hay datos.
@riverpod
FamilyMemberRole? currentMemberRole(CurrentMemberRoleRef ref) {
  final familyAsync = ref.watch(currentFamilyProvider);
  final userAsync = ref.watch(authStateProvider);

  final family = familyAsync.valueOrNull;
  final user = userAsync.valueOrNull;

  if (family == null || user == null) return null;

  return family.members
      .where((m) => m.userId == user.id)
      .firstOrNull
      ?.role;
}
