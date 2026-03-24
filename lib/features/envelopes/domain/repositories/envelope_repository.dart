import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';

/// Contrato del repositorio de sobres.
///
/// Todas las operaciones mutantes siguen la convención [AppResult]:
/// - Éxito → `(data: valor, failure: null)`
/// - Fallo → `(data: null, failure: DatabaseFailure(mensaje))`
///
/// Los streams no envuelven errores — los errores se capturan
/// con [AsyncValue] de Riverpod en la capa de presentación.
abstract interface class EnvelopeRepository {
  /// Stream reactivo de sobres activos de la familia, ordenados por [sortOrder].
  /// Emite automáticamente cada vez que cambia la DB local.
  Stream<List<Envelope>> watchEnvelopes(String familyId);

  /// Un sobre por ID. Retorna `null` en data si no existe.
  Future<AppResult<Envelope?>> getEnvelopeById(String id);

  /// Crea o actualiza un sobre en la DB local y encola para sincronización.
  Future<AppResult<Unit>> saveEnvelope(Envelope envelope);

  /// Soft-delete: marca el sobre como eliminado y encola para sincronización.
  Future<AppResult<Unit>> deleteEnvelope(String id);
}
