import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/domain/repositories/envelope_repository.dart';

class SaveEnvelopeUseCase {
  final EnvelopeRepository _repository;
  const SaveEnvelopeUseCase(this._repository);

  Future<AppResult<Unit>> call(Envelope envelope) =>
      _repository.saveEnvelope(envelope);
}
