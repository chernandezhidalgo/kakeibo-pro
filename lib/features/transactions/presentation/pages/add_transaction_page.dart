import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/features/ai/domain/models/ai_categorization_request.dart';
import 'package:kakeibo_pro/features/ai/presentation/providers/ai_provider.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/providers/envelope_provider.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/presentation/providers/add_transaction_notifier.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  final Envelope envelope;
  final String familyId;

  const AddTransactionPage({
    super.key,
    required this.envelope,
    required this.familyId,
  });

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _merchantController = TextEditingController();

  late final TxKey _key;

  @override
  void initState() {
    super.initState();
    _key = (familyId: widget.familyId, envelopeId: widget.envelope.id);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addTransactionProvider(_key));
    final notifier = ref.read(addTransactionProvider(_key).notifier);

    // Regresar automáticamente cuando se guarda con éxito
    ref.listen(addTransactionProvider(_key), (prev, next) {
      if (prev?.savedOk != true && next.savedOk) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMuted),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Nuevo movimiento',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: state.canSave
                  ? () => _save(context, notifier)
                  : null,
              child: state.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: AppColors.green,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Guardar',
                      style: TextStyle(
                        color: state.canSave
                            ? AppColors.green
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Resumen del sobre ─────────────────────────────────────────
            _EnvelopeSummaryTile(
              envelope: widget.envelope,
              previewAmount: state.amount,
              previewType: state.type,
            ),

            const SizedBox(height: 28),

            // ── Tipo de movimiento ────────────────────────────────────────
            _Field(
              label: 'Tipo',
              child: _TypeSelector(
                selected: state.type,
                onChanged: notifier.setType,
              ),
            ),

            const SizedBox(height: 28),

            // ── Monto ─────────────────────────────────────────────────────
            _Field(
              label: 'Monto (₡)',
              child: TextField(
                controller: _amountController,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                decoration: _inputDecoration('0').copyWith(
                  prefixText: '₡ ',
                  prefixStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 24,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: notifier.setAmount,
              ),
            ),

            // Preview del monto formateado
            if (state.amount > 0) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  CurrencyFormatter.format(state.amount),
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),

            // ── Descripción ───────────────────────────────────────────────
            _Field(
              label: 'Descripción',
              child: TextField(
                controller: _descriptionController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('Ej: Compras del mes'),
                onChanged: notifier.setDescription,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 120,
                buildCounter: (_, {required currentLength,
                        required isFocused, maxLength}) =>
                    null,
              ),
            ),

            const SizedBox(height: 12),

            // ── Botón "Sugerir sobre" ──────────────────────────────────────
            Consumer(
              builder: (context, ref, _) {
                final catState = ref.watch(
                    categorizationProvider(widget.envelope.id));
                final catNotifier = ref.read(
                    categorizationProvider(widget.envelope.id).notifier);
                final envelopes = ref
                    .watch(envelopesProvider(widget.familyId))
                    .valueOrNull ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      icon: catState is CategorizationLoading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.blue,
                              ),
                            )
                          : const Icon(Icons.auto_awesome_outlined,
                              size: 16, color: AppColors.blue),
                      label: Text(
                        catState is CategorizationLoading
                            ? 'Consultando IA…'
                            : 'Sugerir sobre con IA',
                        style: const TextStyle(
                            color: AppColors.blue, fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.blue),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: (catState is CategorizationLoading ||
                              !state.isDescriptionValid)
                          ? null
                          : () {
                              final options = envelopes
                                  .map((e) => EnvelopeOption(
                                        id: e.id,
                                        name: e.name,
                                        category: e.kakeiboCategory.name,
                                        emoji: e.iconEmoji,
                                      ))
                                  .toList();
                              catNotifier.categorize(
                                AiCategorizationRequest(
                                  description: state.description,
                                  merchantName:
                                      (state.merchantName ?? '').isNotEmpty
                                          ? state.merchantName
                                          : null,
                                  amount: state.amount,
                                  currency: 'CRC',
                                  availableEnvelopes: options,
                                ),
                              );
                            },
                    ),
                    if (catState is CategorizationSuccess) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_outline,
                                color: AppColors.blue, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sugerido: ${catState.result.envelopeName}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    catState.result.reasoning,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  size: 16, color: AppColors.textMuted),
                              onPressed: catNotifier.reset,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (catState is CategorizationError) ...[
                      const SizedBox(height: 8),
                      Text(
                        catState.message,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 12),
                      ),
                    ],
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            // ── Comercio (opcional) ───────────────────────────────────────
            _Field(
              label: 'Comercio (opcional)',
              child: TextField(
                controller: _merchantController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration('Ej: Walmart, CAJA, Netflix…'),
                onChanged: notifier.setMerchant,
                textCapitalization: TextCapitalization.words,
                maxLength: 80,
                buildCounter: (_, {required currentLength,
                        required isFocused, maxLength}) =>
                    null,
              ),
            ),

            const SizedBox(height: 28),

            // ── Fecha ─────────────────────────────────────────────────────
            _Field(
              label: 'Fecha',
              child: _DatePickerTile(
                date: state.date,
                onChanged: notifier.setDate,
              ),
            ),

            // ── Mensaje de error ──────────────────────────────────────────
            if (state.errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),

            // ── Botón guardar ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.canSave
                    ? () => _save(context, notifier)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.border,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Registrar movimiento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(BuildContext context, AddTransactionNotifier notifier) {
    final userId =
        ref.read(authStateProvider).valueOrNull?.id ?? 'unknown';
    notifier.save(userId);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.green, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

// ── Selector de tipo de movimiento ────────────────────────────────────────────

class _TypeSelector extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const _TypeSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TypeChip(
          label: 'Gasto',
          icon: Icons.arrow_upward_rounded,
          color: AppColors.error,
          type: TransactionType.expense,
          selected: selected,
          onTap: onChanged,
        ),
        const SizedBox(width: 10),
        _TypeChip(
          label: 'Ingreso',
          icon: Icons.arrow_downward_rounded,
          color: AppColors.green,
          type: TransactionType.income,
          selected: selected,
          onTap: onChanged,
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final TransactionType type;
  final TransactionType selected;
  final ValueChanged<TransactionType> onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = type == selected;
    return GestureDetector(
      onTap: () => onTap(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : AppColors.textMuted,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tile de resumen del sobre con preview de impacto ──────────────────────────

class _EnvelopeSummaryTile extends StatelessWidget {
  final Envelope envelope;
  final double previewAmount;
  final TransactionType previewType;

  const _EnvelopeSummaryTile({
    required this.envelope,
    required this.previewAmount,
    required this.previewType,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular el nuevo gasto hipotético después de este movimiento
    final delta = previewType == TransactionType.income
        ? -previewAmount
        : previewAmount;
    final projected = envelope.currentSpent + delta;
    final projectedRemaining = envelope.monthlyBudget - projected;
    final isOverAfter = projected > envelope.monthlyBudget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOverAfter && previewAmount > 0
              ? AppColors.error.withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                envelope.iconEmoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                ),
                const SizedBox(height: 2),
                Text(
                  previewAmount > 0
                      ? (isOverAfter
                          ? 'Se excederá el presupuesto'
                          : 'Disponible tras este movimiento: ${CurrencyFormatter.format(projectedRemaining)}')
                      : 'Disponible: ${CurrencyFormatter.format(envelope.remainingBudget)}',
                  style: TextStyle(
                    color: isOverAfter && previewAmount > 0
                        ? AppColors.error
                        : AppColors.textMuted,
                    fontSize: 12,
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

// ── Date Picker ───────────────────────────────────────────────────────────────

class _DatePickerTile extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _DatePickerTile({
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('d MMM yyyy', 'es').format(date);
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.green,
                  onPrimary: Colors.black,
                  surface: AppColors.surface,
                  onSurface: AppColors.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: AppColors.textMuted, size: 18),
            const SizedBox(width: 10),
            Text(
              formatted,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Wrapper de campo con label ────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final String label;
  final Widget child;

  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
