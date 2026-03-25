import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/providers/envelope_provider.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/presentation/providers/transaction_provider.dart';

/// Modelo de datos agregados para el dashboard mensual.
class MonthlySummaryData {
  final double totalIncome;
  final double totalExpense;
  final double totalBudget;
  final Map<KakeiboCategory, double> spentByCategory;
  final Map<int, double> spentByDay; // día del mes → total gasto
  final List<Envelope> envelopes;

  const MonthlySummaryData({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalBudget,
    required this.spentByCategory,
    required this.spentByDay,
    required this.envelopes,
  });

  /// Tasa de ahorro en porcentaje (puede ser negativa si hay déficit).
  double get savingsRate =>
      totalIncome > 0 ? ((totalIncome - totalExpense) / totalIncome * 100) : 0;
}

/// Provider que agrega los datos del mes actual para el dashboard.
///
/// Uso: `ref.watch(monthlySummaryProvider((familyId: familyId)))`
final monthlySummaryProvider =
    FutureProvider.family<MonthlySummaryData, ({String familyId})>(
  (ref, p) async {
    // envelopesProvider es StreamProvider — .future obtiene el primer valor
    final envelopes = await ref.watch(envelopesProvider(p.familyId).future);
    final transactions =
        await ref.watch(monthlyTransactionsProvider(p.familyId).future);

    // Totales generales
    final totalIncome = transactions
        .where((t) => t.transactionType == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);

    final totalExpense = transactions
        .where((t) =>
            t.transactionType == TransactionType.expense ||
            t.transactionType == TransactionType.investment ||
            t.transactionType == TransactionType.transfer)
        .fold(0.0, (s, t) => s + t.amount);

    final totalBudget = envelopes.fold(0.0, (s, e) => s + e.monthlyBudget);

    // Gasto por categoría Kakeibo
    final spentByCategory = <KakeiboCategory, double>{};
    for (final env in envelopes) {
      spentByCategory[env.kakeiboCategory] =
          (spentByCategory[env.kakeiboCategory] ?? 0) + env.currentSpent;
    }

    // Gasto por día del mes
    final spentByDay = <int, double>{};
    for (final tx in transactions) {
      if (tx.transactionType == TransactionType.expense) {
        final day = tx.transactionDate.day;
        spentByDay[day] = (spentByDay[day] ?? 0) + tx.amount;
      }
    }

    return MonthlySummaryData(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      totalBudget: totalBudget,
      spentByCategory: spentByCategory,
      spentByDay: spentByDay,
      envelopes: envelopes,
    );
  },
);
