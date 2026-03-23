// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$familyRepositoryHash() => r'1e3a7d7f320f40a4b7bbc7f599b807815abbd5bf';

/// See also [familyRepository].
@ProviderFor(familyRepository)
final familyRepositoryProvider = Provider<FamilyRepository>.internal(
  familyRepository,
  name: r'familyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$familyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FamilyRepositoryRef = ProviderRef<FamilyRepository>;
String _$createFamilyUseCaseHash() =>
    r'a7f8bbd961693f08107ec3ef64d78355d283243c';

/// See also [createFamilyUseCase].
@ProviderFor(createFamilyUseCase)
final createFamilyUseCaseProvider =
    AutoDisposeProvider<CreateFamilyUseCase>.internal(
      createFamilyUseCase,
      name: r'createFamilyUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createFamilyUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateFamilyUseCaseRef = AutoDisposeProviderRef<CreateFamilyUseCase>;
String _$generateInvitationUseCaseHash() =>
    r'b00f791b7a6971d45153dc28de2f7c8d4c15af6e';

/// See also [generateInvitationUseCase].
@ProviderFor(generateInvitationUseCase)
final generateInvitationUseCaseProvider =
    AutoDisposeProvider<GenerateInvitationUseCase>.internal(
      generateInvitationUseCase,
      name: r'generateInvitationUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$generateInvitationUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GenerateInvitationUseCaseRef =
    AutoDisposeProviderRef<GenerateInvitationUseCase>;
String _$acceptInvitationUseCaseHash() =>
    r'463497e3ec9db470f997b7c7be184cbad7474402';

/// See also [acceptInvitationUseCase].
@ProviderFor(acceptInvitationUseCase)
final acceptInvitationUseCaseProvider =
    AutoDisposeProvider<AcceptInvitationUseCase>.internal(
      acceptInvitationUseCase,
      name: r'acceptInvitationUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$acceptInvitationUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AcceptInvitationUseCaseRef =
    AutoDisposeProviderRef<AcceptInvitationUseCase>;
String _$currentFamilyHash() => r'2ebd8b1c9e9f7f9dd03f894584112584c25b3a43';

/// Carga la familia del usuario autenticado actualmente.
/// Retorna null si el usuario no pertenece a ninguna familia aún.
/// Es un [FutureProvider] porque la consulta a Supabase es asíncrona.
///
/// Copied from [currentFamily].
@ProviderFor(currentFamily)
final currentFamilyProvider =
    AutoDisposeFutureProvider<KakeiboFamily?>.internal(
      currentFamily,
      name: r'currentFamilyProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentFamilyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentFamilyRef = AutoDisposeFutureProviderRef<KakeiboFamily?>;
String _$familyMembersHash() => r'bc16b076bdfebcf9eac45bfcf0a2a0d12864ee65';

/// Retorna todos los miembros de la familia actual.
///
/// Copied from [familyMembers].
@ProviderFor(familyMembers)
final familyMembersProvider =
    AutoDisposeFutureProvider<List<FamilyMember>>.internal(
      familyMembers,
      name: r'familyMembersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$familyMembersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FamilyMembersRef = AutoDisposeFutureProviderRef<List<FamilyMember>>;
String _$currentMemberRoleHash() => r'dbe53980ad582c589818bab846b4a0e00f6fdeaf';

/// Retorna el rol del usuario autenticado dentro de su familia.
///
/// Es un [Provider] síncrono que observa los [AsyncValue] de los providers
/// de arriba y devuelve null mientras cargan o si no hay datos.
///
/// Copied from [currentMemberRole].
@ProviderFor(currentMemberRole)
final currentMemberRoleProvider =
    AutoDisposeProvider<FamilyMemberRole?>.internal(
      currentMemberRole,
      name: r'currentMemberRoleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentMemberRoleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMemberRoleRef = AutoDisposeProviderRef<FamilyMemberRole?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
