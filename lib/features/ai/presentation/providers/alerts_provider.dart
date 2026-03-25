import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kakeibo_pro/features/ai/domain/services/anomaly_detector.dart';
import 'package:kakeibo_pro/features/ai/domain/services/spending_predictor.dart';
import 'package:kakeibo_pro/features/home/presentation/providers/summary_provider.dart';

/// Modelo de alerta financiera generada por la IA local.
class FinancialAlert {
  final AlertType type;
  final String title;
  final String description;
  final AlertSeverity severity;

  const FinancialAlert({
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
  });
}

enum AlertType { anomaly, projection, budget }

enum AlertSeverity { info, warning, danger }

/// Agrega anomalías y proyección de gasto para una familia en el mes actual.
final financialAlertsProvider = FutureProvider.autoDispose
    .family<List<FinancialAlert>, ({String familyId})>(
  (ref, p) async {
    final summary =
        await ref.watch(monthlySummaryProvider((familyId: p.familyId)).future);

    final alerts = <FinancialAlert>[];
    final now = DateTime.now();
    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;

    // ── 1. Proyección de gasto ──────────────────────────────────────────────
    final projection = SpendingPredictor.predict(
      totalSpentSoFar: summary.totalExpense,
      currentDay: now.day,
      daysInMonth: daysInMonth,
      monthlyBudget: summary.totalBudget,
    );

    if (projection.willExceedBudget) {
      alerts.add(FinancialAlert(
        type: AlertType.projection,
        title: 'Riesgo de exceder presupuesto',
        description: projection.summary,
        severity: AlertSeverity.danger,
      ));
    } else if (projection.surplusOrDeficit <
        summary.totalBudget * 0.1) {
      // Menos del 10% de margen → advertencia
      alerts.add(FinancialAlert(
        type: AlertType.projection,
        title: 'Margen de presupuesto ajustado',
        description: projection.summary,
        severity: AlertSeverity.warning,
      ));
    }

    // ── 2. Sobres con presupuesto excedido ─────────────────────────────────
    for (final envelope in summary.envelopes) {
      if (envelope.currentSpent > envelope.monthlyBudget &&
          envelope.monthlyBudget > 0) {
        final pct = ((envelope.currentSpent - envelope.monthlyBudget) /
                envelope.monthlyBudget *
                100)
            .toStringAsFixed(0);
        alerts.add(FinancialAlert(
          type: AlertType.budget,
          title: '${envelope.iconEmoji} ${envelope.name} excedido',
          description:
              'Gastaste $pct% más que tu presupuesto en este sobre.',
          severity: AlertSeverity.warning,
        ));
      }
    }

    // ── 3. Anomalías (z-score 1.5σ) ────────────────────────────────────────
    // Proxy: usamos el gasto del mes actual vs presupuesto como referencia
    // ya que no tenemos historial de 3 meses en este proveedor.
    // TODO(F4): conectar con historial real de meses anteriores.
    final currentSpend = <String, double>{};
    for (final env in summary.envelopes) {
      if (env.currentSpent > 0) {
        currentSpend[env.name] = env.currentSpent;
      }
    }

    // Creamos historial sintético con el presupuesto como referencia mensual.
    // TODO(F4): conectar con historial real de meses anteriores.
    final historicalProxy = [
      <String, double>{
        for (final e in summary.envelopes) e.name: e.monthlyBudget * 0.9
      },
      <String, double>{
        for (final e in summary.envelopes) e.name: e.monthlyBudget
      },
      <String, double>{
        for (final e in summary.envelopes) e.name: e.monthlyBudget * 1.05
      },
    ];

    final anomalies = AnomalyDetector.detect(
      currentSpend: currentSpend,
      historicalSpend: historicalProxy,
    );

    for (final anomaly in anomalies) {
      alerts.add(FinancialAlert(
        type: AlertType.anomaly,
        title: 'Gasto inusual en ${anomaly.category}',
        description: anomaly.description,
        severity: AlertSeverity.warning,
      ));
    }

    return alerts;
  },
);

/// Extensión helper para el emoji de severidad
extension AlertSeverityExt on AlertSeverity {
  String get emoji {
    return switch (this) {
      AlertSeverity.info => 'ℹ️',
      AlertSeverity.warning => '⚠️',
      AlertSeverity.danger => '🚨',
    };
  }
}

/// Extensión helper para el color de severidad (devuelve un string de clave)
extension AlertSeverityColor on AlertSeverity {
  String get colorKey {
    return switch (this) {
      AlertSeverity.info => 'blue',
      AlertSeverity.warning => 'gold',
      AlertSeverity.danger => 'error',
    };
  }
}
