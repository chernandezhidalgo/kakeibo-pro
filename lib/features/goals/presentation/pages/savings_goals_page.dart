import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/features/goals/domain/entities/savings_goal.dart';
import 'package:kakeibo_pro/features/goals/presentation/providers/goals_provider.dart';

class SavingsGoalsPage extends ConsumerWidget {
  final String familyId;

  const SavingsGoalsPage({super.key, required this.familyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsStreamProvider(familyId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Metas de ahorro',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.green),
            tooltip: 'Nueva meta',
            onPressed: () => _showNewGoalSheet(context, familyId),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
                color: AppColors.green, strokeWidth: 2)),
        error: (e, _) => Center(
            child: Text('Error: $e',
                style: const TextStyle(color: AppColors.error))),
        data: (goals) {
          if (goals.isEmpty) {
            return const _EmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: goals.length,
            itemBuilder: (ctx, i) => _GoalCard(
              goal: goals[i],
              onAdd: () => _showAddAmountSheet(ctx, goals[i], ref),
              onDelete: () => ref
                  .read(goalFormProvider((familyId: familyId)).notifier)
                  .deleteGoal(goals[i].id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Nueva meta',
            style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () => _showNewGoalSheet(context, familyId),
      ),
    );
  }

  void _showNewGoalSheet(BuildContext context, String familyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _NewGoalSheet(familyId: familyId),
    );
  }

  void _showAddAmountSheet(
      BuildContext context, SavingsGoal goal, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AddAmountSheet(goal: goal, ref: ref),
    );
  }
}

// ── Tarjeta de meta ───────────────────────────────────────────────────────────

class _GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  const _GoalCard(
      {required this.goal, required this.onAdd, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final pct = goal.progressPercent / 100;
    final isCompleted = goal.isCompleted;
    final isExpired = goal.isExpired;

    Color progressColor = AppColors.green;
    if (isCompleted) progressColor = AppColors.green;
    if (isExpired) progressColor = AppColors.error;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpired
              ? AppColors.error.withValues(alpha: 0.4)
              : isCompleted
                  ? AppColors.green.withValues(alpha: 0.4)
                  : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: emoji + nombre + menú
          Row(
            children: [
              Text(goal.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    if (goal.deadline != null)
                      Text(
                        'Fecha límite: ${DateFormat('d MMM yyyy', 'es').format(goal.deadline!)}',
                        style: TextStyle(
                            color: isExpired
                                ? AppColors.error
                                : AppColors.textMuted,
                            fontSize: 11),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.textMuted, size: 20),
                color: AppColors.surfaceVariant,
                onSelected: (v) {
                  if (v == 'add') onAdd();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'add',
                    child: Text('Agregar monto',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar',
                        style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Montos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CurrencyFormatter.format(goal.currentAmount),
                style: TextStyle(
                    color: isCompleted ? AppColors.green : AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                'de ${CurrencyFormatter.format(goal.targetAmount)}',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 6),

          // % + restante
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCompleted
                    ? '✅ Meta alcanzada'
                    : '${goal.progressPercent.toStringAsFixed(1)}%',
                style: TextStyle(
                    color: isCompleted ? AppColors.green : AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              if (!isCompleted)
                Text(
                  'Faltan ${CurrencyFormatter.format(goal.remaining)}',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hoja para agregar monto a una meta ────────────────────────────────────────

class _AddAmountSheet extends StatefulWidget {
  final SavingsGoal goal;
  final WidgetRef ref;
  const _AddAmountSheet({required this.goal, required this.ref});

  @override
  State<_AddAmountSheet> createState() => _AddAmountSheetState();
}

class _AddAmountSheetState extends State<_AddAmountSheet> {
  final _ctrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount =
        double.tryParse(_ctrl.text.replaceAll(',', '.')) ?? 0;
    if (amount <= 0) return;
    setState(() => _loading = true);
    await widget.ref
        .read(goalFormProvider((familyId: widget.goal.familyId)).notifier)
        .addToGoal(widget.goal.id, amount);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agregar a "${widget.goal.name}"',
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d,.]'))
            ],
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: const TextStyle(
                  color: AppColors.textMuted, fontSize: 24),
              prefixText: '₡ ',
              prefixStyle: const TextStyle(
                  color: AppColors.textMuted, fontSize: 18),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppColors.green, width: 1.5)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.black, strokeWidth: 2.5))
                  : const Text('Agregar',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Hoja para crear una nueva meta ────────────────────────────────────────────

class _NewGoalSheet extends ConsumerStatefulWidget {
  final String familyId;
  const _NewGoalSheet({required this.familyId});

  @override
  ConsumerState<_NewGoalSheet> createState() => _NewGoalSheetState();
}

class _NewGoalSheetState extends ConsumerState<_NewGoalSheet> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  late final GoalFormParams _params;

  @override
  void initState() {
    super.initState();
    _params = (familyId: widget.familyId);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalFormProvider(_params));
    final notifier = ref.read(goalFormProvider(_params).notifier);

    ref.listen(goalFormProvider(_params), (_, next) {
      if (next.savedOk) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meta creada'),
          backgroundColor: AppColors.green,
        ));
        Navigator.of(context).pop();
      }
    });

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nueva meta de ahorro',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            // Nombre
            TextField(
              controller: _nameCtrl,
              onChanged: notifier.setName,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 15),
              decoration: _inputDeco('Nombre de la meta', ''),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 14),

            // Monto objetivo
            TextField(
              controller: _amountCtrl,
              onChanged: notifier.setTargetAmount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d,.]'))
              ],
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              decoration: _inputDeco('Monto objetivo', '₡ '),
            ),
            const SizedBox(height: 14),

            // Fecha límite
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.now().add(const Duration(days: 90)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2040),
                  builder: (ctx, child) => Theme(
                    data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                            primary: AppColors.green)),
                    child: child!,
                  ),
                );
                if (picked != null) notifier.setDeadline(picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.textMuted, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      state.deadline != null
                          ? DateFormat('d MMM yyyy', 'es')
                              .format(state.deadline!)
                          : 'Fecha límite (opcional)',
                      style: TextStyle(
                          color: state.deadline != null
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            if (state.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(state.errorMessage!,
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 13)),
            ],

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.canSave && !state.isLoading
                    ? notifier.save
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.border,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.black, strokeWidth: 2.5))
                    : const Text('Crear meta',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, String prefix) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixText: prefix.isEmpty ? null : prefix,
        prefixStyle:
            const TextStyle(color: AppColors.textMuted, fontSize: 16),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.green, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
}

// ── Estado vacío ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎯', style: TextStyle(fontSize: 52)),
          SizedBox(height: 16),
          Text(
            'Todavía no tenés metas de ahorro',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Tocá + para crear tu primera meta',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
