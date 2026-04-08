import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/presentation/providers/edit_transaction_notifier.dart';

class EditTransactionPage extends ConsumerStatefulWidget {
  final Transaction transaction;

  const EditTransactionPage({
    super.key,
    required this.transaction,
  });

  @override
  ConsumerState<EditTransactionPage> createState() =>
      _EditTransactionPageState();
}

class _EditTransactionPageState extends ConsumerState<EditTransactionPage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _merchantController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _amountController.text = tx.amount.toStringAsFixed(
      tx.amount == tx.amount.roundToDouble() ? 0 : 2,
    );
    _descriptionController.text = tx.description;
    _merchantController.text = tx.merchantName ?? '';
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
    final state = ref.watch(editTransactionProvider(widget.transaction));
    final notifier =
        ref.read(editTransactionProvider(widget.transaction).notifier);

    // Regresar automáticamente al guardar con éxito
    ref.listen(editTransactionProvider(widget.transaction), (prev, next) {
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
          'Editar movimiento',
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
              onPressed: state.canSave ? notifier.save : null,
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
                  border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3)),
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
                onPressed: state.canSave ? notifier.save : null,
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
                        'Guardar cambios',
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
            Icon(icon,
                size: 16,
                color: isSelected ? color : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : AppColors.textMuted,
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
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
