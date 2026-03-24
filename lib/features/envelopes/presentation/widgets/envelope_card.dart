import 'package:flutter/material.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/constants/app_strings.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/core/utils/kakeibo_category_ui.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';

class EnvelopeCard extends StatelessWidget {
  final Envelope envelope;
  final VoidCallback? onTap;

  const EnvelopeCard({
    super.key,
    required this.envelope,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = KakeiboCategoryUi.color(envelope.kakeiboCategory);
    final percent = (envelope.spentPercentage / 100).clamp(0.0, 1.0);
    final isOver = envelope.isOverBudget;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOver
                ? AppColors.error.withValues(alpha: 0.4)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: icono + nombre + monto disponible
              Row(
                children: [
                  // Icono del sobre
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        envelope.iconEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nombre y categoría
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          envelope.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          KakeiboCategoryUi.label(envelope.kakeiboCategory),
                          style: TextStyle(
                            color: categoryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Monto disponible / sobrepasado
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isOver
                            ? '-${CurrencyFormatter.format(envelope.currentSpent - envelope.monthlyBudget)}'
                            : CurrencyFormatter.format(envelope.remainingBudget),
                        style: TextStyle(
                          color: isOver ? AppColors.error : AppColors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        isOver
                            ? AppStrings.sobreSobrepasado
                            : AppStrings.sobreDisponible,
                        style: TextStyle(
                          color: isOver
                              ? AppColors.error.withValues(alpha: 0.7)
                              : AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Barra de progreso
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOver ? AppColors.error : categoryColor,
                  ),
                  minHeight: 5,
                ),
              ),

              const SizedBox(height: 10),

              // Fila inferior: gastado / porcentaje / presupuesto
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AmountLabel(
                    label: AppStrings.sobresGastado,
                    amount: envelope.currentSpent,
                  ),
                  Text(
                    '${envelope.spentPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: isOver ? AppColors.error : AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _AmountLabel(
                    label: AppStrings.sobresPresupuesto,
                    amount: envelope.monthlyBudget,
                    alignRight: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountLabel extends StatelessWidget {
  final String label;
  final double amount;
  final bool alignRight;

  const _AmountLabel({
    required this.label,
    required this.amount,
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
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        const SizedBox(height: 1),
        Text(
          CurrencyFormatter.format(amount),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
