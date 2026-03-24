import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/core/utils/kakeibo_category_ui.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/providers/envelope_provider.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/presentation/providers/transaction_provider.dart';

class EnvelopeDetailPage extends ConsumerWidget {
  final String envelopeId;
  final String familyId;

  const EnvelopeDetailPage({
    super.key,
    required this.envelopeId,
    required this.familyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelopesAsync = ref.watch(envelopesProvider(familyId));
    final transactionsAsync =
        ref.watch(transactionsByEnvelopeProvider(envelopeId));

    // Buscar el sobre dentro de la lista de sobres de la familia
    final envelope = envelopesAsync.whenOrNull(
      data: (list) => list.where((e) => e.id == envelopeId).firstOrNull,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: envelope != null
          ? FloatingActionButton(
              onPressed: () {
                context.push(
                  '/sobres/$envelopeId/agregar-movimiento?familyId=$familyId',
                  extra: envelope,
                );
              },
              backgroundColor: AppColors.green,
              foregroundColor: Colors.black,
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: envelopesAsync.when(
          loading: () => const _LoadingState(),
          error: (e, _) => _ErrorState(message: e.toString()),
          data: (_) {
            if (envelope == null) {
              return const _ErrorState(message: 'Sobre no encontrado');
            }
            return _DetailContent(
              envelope: envelope,
              transactionsAsync: transactionsAsync,
            );
          },
        ),
      ),
    );
  }
}

// ── Contenido principal ───────────────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final Envelope envelope;
  final AsyncValue<List<Transaction>> transactionsAsync;

  const _DetailContent({
    required this.envelope,
    required this.transactionsAsync,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = KakeiboCategoryUi.color(envelope.kakeiboCategory);
    final percent = (envelope.spentPercentage / 100).clamp(0.0, 1.0);
    final isOver = envelope.isOverBudget;

    return CustomScrollView(
      slivers: [
        // ── AppBar con nombre del sobre ────────────────────────────────
        SliverAppBar(
          backgroundColor: AppColors.background,
          leading: BackButton(color: AppColors.textMuted),
          title: Row(
            children: [
              Text(
                envelope.iconEmoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                envelope.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          floating: true,
          snap: true,
          elevation: 0,
        ),

        // ── Tarjeta de resumen ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isOver
                      ? AppColors.error.withValues(alpha: 0.4)
                      : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance disponible
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(
                            envelope.remainingBudget.abs()),
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

                  // Barra de progreso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOver ? AppColors.error : categoryColor,
                      ),
                      minHeight: 8,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Gastado / Porcentaje / Presupuesto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gastado',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 12)),
                          Text(
                            CurrencyFormatter.format(envelope.currentSpent),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${envelope.spentPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: isOver ? AppColors.error : AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Presupuesto',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 12)),
                          Text(
                            CurrencyFormatter.format(envelope.monthlyBudget),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Encabezado de la lista de movimientos ─────────────────────
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'MOVIMIENTOS',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),

        // ── Lista de transacciones ────────────────────────────────────
        transactionsAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Error al cargar movimientos: $e',
                style: const TextStyle(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const SliverToBoxAdapter(
                child: _EmptyTransactions(),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _TransactionTile(transaction: transactions[index]),
                childCount: transactions.length,
              ),
            );
          },
        ),

        // Espacio para el FAB
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ── Tile de transacción ───────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.transactionType == TransactionType.expense ||
        transaction.transactionType == TransactionType.investment ||
        transaction.transactionType == TransactionType.transfer;
    final color = isExpense ? AppColors.error : AppColors.green;
    final sign = isExpense ? '-' : '+';
    final formattedDate =
        DateFormat('d MMM', 'es').format(transaction.transactionDate);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Icono de tipo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isExpense
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Descripción y comercio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (transaction.merchantName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.merchantName!,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Monto y fecha
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign${CurrencyFormatter.format(transaction.amount)}',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formattedDate,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Estado vacío de transacciones ─────────────────────────────────────────────

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('📋', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sin movimientos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toca el botón + para registrar\ntu primer movimiento.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Estados de carga/error ────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.green,
        strokeWidth: 2,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
