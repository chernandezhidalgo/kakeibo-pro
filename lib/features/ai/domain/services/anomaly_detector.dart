import 'dart:math';

/// Detecta anomalías de gasto usando z-score con umbral de 1.5σ.
///
/// Compara el gasto actual de una categoría con su media histórica
/// de los últimos 3 meses. Si el gasto supera media + 1.5 × stdDev,
/// se considera anómalo.
class AnomalyDetector {
  static const double _sigmaThreshold = 1.5;

  /// Devuelve las categorías con gasto anómalo.
  ///
  /// [currentSpend] — mapa {categoría: gasto_actual}
  /// [historicalSpend] — lista de mapas mensuales {categoría: gasto}
  ///   (idealmente los últimos 3 meses; si hay menos datos los resultados
  ///    son orientativos, no estadísticamente robustos)
  static List<SpendingAnomaly> detect({
    required Map<String, double> currentSpend,
    required List<Map<String, double>> historicalSpend,
  }) {
    if (historicalSpend.isEmpty) return [];

    final anomalies = <SpendingAnomaly>[];

    for (final entry in currentSpend.entries) {
      final category = entry.key;
      final current = entry.value;

      // Historial de esta categoría
      final history = historicalSpend
          .map((m) => m[category] ?? 0.0)
          .toList();

      final mean = _mean(history);
      final stdDev = _stdDev(history, mean);

      // Si stdDev ≈ 0, no hay varianza suficiente para detectar anomalía
      if (stdDev < 1.0) continue;

      final zScore = (current - mean) / stdDev;

      if (zScore > _sigmaThreshold) {
        anomalies.add(SpendingAnomaly(
          category: category,
          currentAmount: current,
          historicalMean: mean,
          zScore: zScore,
          percentageAboveMean:
              mean > 0 ? ((current - mean) / mean * 100) : 0,
        ));
      }
    }

    // Ordenar por z-score descendente (mayor anomalía primero)
    anomalies.sort((a, b) => b.zScore.compareTo(a.zScore));
    return anomalies;
  }

  static double _mean(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  static double _stdDev(List<double> values, double mean) {
    if (values.length < 2) return 0;
    final variance =
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) /
            (values.length - 1);
    return sqrt(variance);
  }
}

class SpendingAnomaly {
  final String category;
  final double currentAmount;
  final double historicalMean;
  final double zScore;
  final double percentageAboveMean;

  const SpendingAnomaly({
    required this.category,
    required this.currentAmount,
    required this.historicalMean,
    required this.zScore,
    required this.percentageAboveMean,
  });

  String get description =>
      'Gastaste ${percentageAboveMean.toStringAsFixed(0)}% más de lo '
      'habitual en $category este mes.';
}
