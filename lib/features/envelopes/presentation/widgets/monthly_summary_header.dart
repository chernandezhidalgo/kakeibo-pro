import 'package:flutter/material.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';

class MonthlySummaryHeader extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;

  const MonthlySummaryHeader({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = totalBudget - totalSpent;
    final percent =
        totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;
    final isOver = totalSpent > totalBudget;

    // Mes actual en español
    final now = DateTime.now();
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    final mesLabel = '${months[now.month - 1].toUpperCase()} ${now.year}';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta del mes
          Text(
            mesLabel,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          // Monto disponible / sobrepasado en grande
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(remaining.abs()),
                style: TextStyle(
                  color: isOver ? AppColors.error : AppColors.green,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  isOver ? 'sobrepasado' : 'disponible',
                  style: TextStyle(
                    color: isOver
                        ? AppColors.error.withValues(alpha: 0.7)
                        : AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barra de progreso global
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOver ? AppColors.error : AppColors.green,
              ),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 12),

          // Gastado / Presupuesto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryCell(
                label: 'Gastado',
                value: CurrencyFormatter.format(totalSpent),
              ),
              _SummaryCell(
                label: 'Presupuesto',
                value: CurrencyFormatter.format(totalBudget),
                alignRight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;

  const _SummaryCell({
    required this.label,
    required this.value,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
