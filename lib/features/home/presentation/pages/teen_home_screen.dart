import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/family_provider.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/providers/envelope_provider.dart';

/// Pantalla de inicio para miembros con rol `adolescent`.
///
/// Muestra solo los sobres asignados a la familia en una vista simplificada,
/// sin acceso a informes, configuración avanzada ni datos sensibles de la familia.
class TeenHomeScreen extends ConsumerWidget {
  const TeenHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyAsync = ref.watch(currentFamilyProvider);

    return familyAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.green, strokeWidth: 2),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Error al cargar: $e',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
      data: (family) {
        if (family == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: SizedBox.shrink(),
          );
        }
        return _TeenContent(familyId: family.id);
      },
    );
  }
}

// ── Contenido principal ───────────────────────────────────────────────────────

class _TeenContent extends ConsumerWidget {
  final String familyId;
  const _TeenContent({required this.familyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelopesAsync = ref.watch(envelopesProvider(familyId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encabezado ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Hola! 👋',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tu presupuesto',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // ── Lista de sobres ─────────────────────────────────────────────
            Expanded(
              child: envelopesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.green,
                    strokeWidth: 2,
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'No se pudieron cargar los sobres',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                data: (envelopes) {
                  if (envelopes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay sobres configurados aún.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: envelopes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _TeenEnvelopeCard(
                        envelope: envelopes[index],
                        familyId: familyId,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta de sobre (vista simplificada) ─────────────────────────────────────

class _TeenEnvelopeCard extends StatelessWidget {
  final Envelope envelope;
  final String familyId;

  const _TeenEnvelopeCard({
    required this.envelope,
    required this.familyId,
  });

  @override
  Widget build(BuildContext context) {
    final isOver = envelope.isOverBudget;
    final percent = (envelope.spentPercentage / 100).clamp(0.0, 1.0);
    final barColor = isOver ? AppColors.error : AppColors.green;

    return GestureDetector(
      onTap: () => context.push(
        '/sobres/${envelope.id}?familyId=$familyId',
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOver
                ? AppColors.error.withValues(alpha: 0.4)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre + emoji
            Row(
              children: [
                Text(
                  envelope.iconEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    envelope.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Disponible / excedido
                Text(
                  isOver ? 'Excedido' : 'Disponible',
                  style: TextStyle(
                    color: isOver ? AppColors.error : AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: AppColors.border,
                color: barColor,
                minHeight: 6,
              ),
            ),

            const SizedBox(height: 8),

            // Saldo disponible / sobrepasado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(envelope.currentSpent),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(envelope.monthlyBudget),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
