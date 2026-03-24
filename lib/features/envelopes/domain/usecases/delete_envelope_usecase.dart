import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/envelopes/domain/repositories/envelope_repository.dart';

class DeleteEnvelopeUseCase {
  final EnvelopeRepository _repository;
  const DeleteEnvelopeUseCase(this._repository);

  Future<AppResult<Unit>> call(String id) => _repository.deleteEnvelope(id);
}
