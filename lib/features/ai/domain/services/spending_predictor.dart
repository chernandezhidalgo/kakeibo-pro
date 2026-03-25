/// Proyecta el gasto total al final del mes basado en la tasa diaria actual.
class SpendingPredictor {
  /// Calcula la proyección de gasto para el mes actual.
  ///
  /// [totalSpentSoFar] — total gastado hasta hoy
  /// [currentDay] — día del mes actual (1-31)
  /// [daysInMonth] — días totales del mes (28-31)
  /// [monthlyBudget] — presupuesto total del mes
  static SpendingProjection predict({
    required double totalSpentSoFar,
    required int currentDay,
    required int daysInMonth,
    required double monthlyBudget,
  }) {
    if (currentDay <= 0) {
      return SpendingProjection(
        dailyRate: 0,
        projectedTotal: totalSpentSoFar,
        remainingDays: daysInMonth,
        remainingBudget: monthlyBudget - totalSpentSoFar,
        willExceedBudget: false,
        surplusOrDeficit: monthlyBudget - totalSpentSoFar,
      );
    }

    final dailyRate = totalSpentSoFar / currentDay;
    final remainingDays = daysInMonth - currentDay;
    final projectedTotal = totalSpentSoFar + (dailyRate * remainingDays);
    final remainingBudget = monthlyBudget - totalSpentSoFar;
    final willExceedBudget = projectedTotal > monthlyBudget;
    final surplusOrDeficit = monthlyBudget - projectedTotal;

    return SpendingProjection(
      dailyRate: dailyRate,
      projectedTotal: projectedTotal,
      remainingDays: remainingDays,
      remainingBudget: remainingBudget,
      willExceedBudget: willExceedBudget,
      surplusOrDeficit: surplusOrDeficit,
    );
  }
}

class SpendingProjection {
  final double dailyRate;
  final double projectedTotal;
  final int remainingDays;
  final double remainingBudget;
  final bool willExceedBudget;

  /// Positivo = superávit, negativo = déficit proyectado
  final double surplusOrDeficit;

  const SpendingProjection({
    required this.dailyRate,
    required this.projectedTotal,
    required this.remainingDays,
    required this.remainingBudget,
    required this.willExceedBudget,
    required this.surplusOrDeficit,
  });

  String get summary {
    if (willExceedBudget) {
      return 'Al ritmo actual, excederás tu presupuesto en '
          '₡${surplusOrDeficit.abs().toStringAsFixed(0)}.';
    }
    return 'Al ritmo actual, terminarás el mes con '
        '₡${surplusOrDeficit.toStringAsFixed(0)} de sobra.';
  }
}
