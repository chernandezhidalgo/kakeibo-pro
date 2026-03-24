import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/database/database_provider.dart';
import 'package:kakeibo_pro/core/sync/sync_repository.dart';
import 'package:kakeibo_pro/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:kakeibo_pro/features/transactions/domain/usecases/delete_transaction_usecase.dart';

/// Instancia del repositorio de transacciones.
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionRepositoryImpl(
    db: db,
    sync: SyncRepository(db),
  );
});

/// Stream de transacciones de un sobre, en tiempo real.
///
/// Uso: `ref.watch(transactionsByEnvelopeProvider(envelopeId))`
final transactionsByEnvelopeProvider =
    StreamProvider.family<List<Transaction>, String>((ref, envelopeId) {
  return ref
      .watch(transactionRepositoryProvider)
      .watchByEnvelope(envelopeId);
});

/// Transacciones del mes en curso para una familia.
///
/// Uso: `ref.watch(monthlyTransactionsProvider(familyId))`
final monthlyTransactionsProvider =
    FutureProvider.family<List<Transaction>, String>((ref, familyId) async {
  final result =
      await ref.watch(transactionRepositoryProvider).getThisMonth(familyId);
  if (result.failure != null) return [];
  return result.data ?? [];
});

/// Caso de uso para eliminar una transacción con reversión atómica de spentAmount.
///
/// Uso: `ref.read(deleteTransactionUseCaseProvider).call(id)`
final deleteTransactionUseCaseProvider = Provider<DeleteTransactionUseCase>((ref) {
  return DeleteTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

/// Gasto total del mes en la familia (solo transacciones de tipo expense).
///
/// Uso: `ref.watch(monthlyExpenseTotalProvider(familyId))`
final monthlyExpenseTotalProvider =
    FutureProvider.family<double, String>((ref, familyId) async {
  final transactions =
      await ref.watch(monthlyTransactionsProvider(familyId).future);
  return transactions
      .where((t) => t.transactionType == TransactionType.expense)
      .fold<double>(0.0, (sum, t) => sum + t.amount);
});
