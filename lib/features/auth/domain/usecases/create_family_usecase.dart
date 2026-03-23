import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family.dart';
import 'package:kakeibo_pro/features/auth/domain/repositories/family_repository.dart';

/// Caso de uso: crear una nueva familia con el usuario actual como Admin.
class CreateFamilyUseCase {
  const CreateFamilyUseCase(this._repository);

  final FamilyRepository _repository;

  Future<AuthResult<KakeiboFamily>> call(String familyName) =>
      _repository.createFamily(familyName);
}
