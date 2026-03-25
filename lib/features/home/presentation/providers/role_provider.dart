import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/family_provider.dart';

/// Rol simplificado para la UI: distingue entre usuario adulto y adolescente.
///
/// Un adolescente recibe la pantalla [TeenHomeScreen] en lugar de [HomeScreen].
enum AppRole { adult, teen }

/// Proveedor del rol del usuario autenticado dentro de su familia actual.
///
/// Devuelve [AppRole.teen] cuando el rol es [FamilyMemberRole.adolescent].
/// En cualquier otro caso (null, admin, coAdmin, child, viewer) devuelve [AppRole.adult].
final currentRoleProvider = Provider<AppRole>((ref) {
  final role = ref.watch(currentMemberRoleProvider);
  return role == FamilyMemberRole.adolescent ? AppRole.teen : AppRole.adult;
});

/// Atajo booleano — true cuando el usuario actual es adolescente.
final isTeenProvider = Provider<bool>((ref) {
  return ref.watch(currentRoleProvider) == AppRole.teen;
});
