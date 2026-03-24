import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/constants/app_strings.dart';
import 'package:kakeibo_pro/core/utils/kakeibo_category_ui.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/providers/envelope_provider.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/widgets/envelope_card.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/widgets/monthly_summary_header.dart';

class EnvelopesPage extends ConsumerWidget {
  final String familyId;

  const EnvelopesPage({super.key, required this.familyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envelopesAsync = ref.watch(envelopesProvider(familyId));
    final summary = ref.watch(envelopeSummaryProvider(familyId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: envelopesAsync.when(
          loading: () => const _LoadingState(),
          error: (e, _) => _ErrorState(message: e.toString()),
          data: (envelopes) {
            if (envelopes.isEmpty) return const _EmptyState();
            return _EnvelopesList(
              envelopes: envelopes,
              totalBudget: summary.totalBudget,
              totalSpent: summary.totalSpent,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: F2 — navegar a pantalla de crear sobre
        },
        backgroundColor: AppColors.green,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Lista de sobres ───────────────────────────────────────────────────────────

class _EnvelopesList extends StatelessWidget {
  final List<Envelope> envelopes;
  final double totalBudget;
  final double totalSpent;

  const _EnvelopesList({
    required this.envelopes,
    required this.totalBudget,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    // Agrupar por categoría para mostrar secciones
    final byCategory = <KakeiboCategory, List<Envelope>>{};
    for (final e in envelopes) {
      byCategory.putIfAbsent(e.kakeiboCategory, () => []).add(e);
    }

    // Orden fijo de categorías según la metodología Kakeibo
    const categoryOrder = [
      KakeiboCategory.survival,
      KakeiboCategory.culture,
      KakeiboCategory.leisure,
      KakeiboCategory.extras,
      KakeiboCategory.allowance,
      KakeiboCategory.investment,
    ];

    return CustomScrollView(
      slivers: [
        // AppBar flotante con título
        const SliverAppBar(
          backgroundColor: AppColors.background,
          title: Text(
            AppStrings.sobresTitle,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          floating: true,
          snap: true,
          elevation: 0,
        ),

        // Header de resumen mensual
        SliverToBoxAdapter(
          child: MonthlySummaryHeader(
            totalBudget: totalBudget,
            totalSpent: totalSpent,
          ),
        ),

        // Secciones por categoría
        for (final category in categoryOrder)
          if (byCategory.containsKey(category)) ...[
            _CategoryHeader(category: category),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final envelope = byCategory[category]![index];
                  return EnvelopeCard(
                    envelope: envelope,
                    onTap: () {
                      // TODO: F2 — navegar al detalle del sobre
                    },
                  );
                },
                childCount: byCategory[category]!.length,
              ),
            ),
          ],

        // Espacio para el FAB
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

// ── Header de sección de categoría ───────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final KakeiboCategory category;

  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Row(
          children: [
            Text(
              KakeiboCategoryUi.emoji(category),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              KakeiboCategoryUi.label(category).toUpperCase(),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Estados de la pantalla ────────────────────────────────────────────────────

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
            const Text(
              'No se pudo cargar los sobres',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('💰', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.sobresVacioTitle,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              AppStrings.sobresVacioSubtitle,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: F2 — crear sobre
              },
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.sobresCrearCta),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
