import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/core/utils/kakeibo_category_ui.dart';
import 'package:kakeibo_pro/features/ai/presentation/providers/alerts_provider.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/home/presentation/providers/summary_provider.dart';

class SummaryPage extends ConsumerWidget {
  final String familyId;

  const SummaryPage({super.key, required this.familyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (familyId: familyId);
    final summaryAsync = ref.watch(monthlySummaryProvider(params));
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy', 'es').format(now);

    return summaryAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(
              color: AppColors.green, strokeWidth: 2)),
      error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.error))),
      data: (data) => CustomScrollView(
        slivers: [
          // ── Alertas financieras ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FinancialAlertsWidget(familyId: familyId),
          ),

          // Encabezado del mes
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    monthName.toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8),
                  ),
                  Text(
                    'Ahorro: ${data.savingsRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: data.savingsRate >= 0
                            ? AppColors.green
                            : AppColors.error,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          // Tarjetas de resumen (ingreso / gasto / presupuesto)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _SummaryCard(
                      label: 'Ingresos',
                      amount: data.totalIncome,
                      color: AppColors.green),
                  const SizedBox(width: 10),
                  _SummaryCard(
                      label: 'Gastos',
                      amount: data.totalExpense,
                      color: AppColors.error),
                  const SizedBox(width: 10),
                  _SummaryCard(
                      label: 'Presupuesto',
                      amount: data.totalBudget,
                      color: AppColors.blue),
                ],
              ),
            ),
          ),

          // Gráfico de dona: gasto por categoría
          if (data.spentByCategory.values.any((v) => v > 0))
            SliverToBoxAdapter(child: _DonutChart(data: data)),

          // Gráfico de línea: gasto por día
          if (data.spentByDay.isNotEmpty)
            SliverToBoxAdapter(child: _LineChartWidget(data: data)),

          // Tabla de sobres
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Text(
                'SOBRES',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _EnvelopeRow(envelope: data.envelopes[i]),
              childCount: data.envelopes.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ── Tarjeta de resumen ────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryCard(
      {required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(amount),
                style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}

// ── Gráfico de dona: gasto por categoría ─────────────────────────────────────

class _DonutChart extends StatelessWidget {
  final MonthlySummaryData data;
  const _DonutChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final sections = data.spentByCategory.entries
        .where((e) => e.value > 0)
        .map((e) => PieChartSectionData(
              value: e.value,
              color: KakeiboCategoryUi.color(e.key),
              title: KakeiboCategoryUi.emoji(e.key),
              radius: 50,
              titleStyle: const TextStyle(fontSize: 16),
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GASTO POR CATEGORÍA',
            style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChart(PieChartData(
              sections: sections,
              centerSpaceRadius: 50,
              sectionsSpace: 2,
            )),
          ),
          const SizedBox(height: 12),
          // Leyenda
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: data.spentByCategory.entries
                .where((e) => e.value > 0)
                .map((e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: KakeiboCategoryUi.color(e.key),
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${KakeiboCategoryUi.label(e.key)} ${CurrencyFormatter.format(e.value)}',
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Gráfico de línea: gasto por día ──────────────────────────────────────────

class _LineChartWidget extends StatelessWidget {
  final MonthlySummaryData data;
  const _LineChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    final spots = data.spentByDay.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GASTO DIARIO',
            style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: LineChart(LineChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (v, m) => Text(
                      '${v.toInt()}',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 10),
                    ),
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  color: AppColors.blue,
                  barWidth: 2.5,
                  isCurved: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.blue.withValues(alpha: 0.08),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

// ── Fila de sobre en tabla de resumen ─────────────────────────────────────────

class _EnvelopeRow extends StatelessWidget {
  final Envelope envelope;
  const _EnvelopeRow({required this.envelope});

  @override
  Widget build(BuildContext context) {
    final pct = (envelope.spentPercentage / 100).clamp(0.0, 1.0);
    final isOver = envelope.isOverBudget;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isOver
                ? AppColors.error.withValues(alpha: 0.4)
                : AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(envelope.iconEmoji,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(envelope.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Text(
                '${CurrencyFormatter.format(envelope.currentSpent)} / ${CurrencyFormatter.format(envelope.monthlyBudget)}',
                style: TextStyle(
                    color: isOver ? AppColors.error : AppColors.textMuted,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isOver ? AppColors.error : AppColors.green),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget de alertas financieras ─────────────────────────────────────────────

class _FinancialAlertsWidget extends ConsumerWidget {
  final String familyId;
  const _FinancialAlertsWidget({required this.familyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync =
        ref.watch(financialAlertsProvider((familyId: familyId)));

    return alertsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (alerts) {
        if (alerts.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ALERTAS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              ...alerts.map((alert) => _AlertTile(alert: alert)),
              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }
}

class _AlertTile extends StatelessWidget {
  final FinancialAlert alert;
  const _AlertTile({required this.alert});

  Color _severityColor() {
    return switch (alert.severity) {
      AlertSeverity.info => AppColors.blue,
      AlertSeverity.warning => AppColors.gold,
      AlertSeverity.danger => AppColors.error,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _severityColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alert.severity.emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
