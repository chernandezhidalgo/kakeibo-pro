import 'package:kakeibo_pro/core/errors/failures.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';

/// Contrato del repositorio de transacciones.
abstract interface class TransactionRepository {
  /// Stream reactivo de transacciones de un sobre, por fecha descendente.
  Stream<List<Transaction>> watchByEnvelope(String envelopeId);

  /// Transacciones del mes en curso para una familia.
  Future<AppResult<List<Transaction>>> getThisMonth(String familyId);

  /// Crea o actualiza una transacción en la DB local y encola para sync.
  Future<AppResult<Unit>> saveTransaction(Transaction transaction);

  /// Soft-delete de una transacción.
  Future<AppResult<Unit>> deleteTransaction(String id);
}
