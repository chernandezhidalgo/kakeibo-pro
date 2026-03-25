import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/purchases/purchases_provider.dart';

/// Pantalla de paywall que se muestra cuando el usuario
/// intenta acceder a una feature de pago sin suscripción activa.
class PaywallPage extends ConsumerStatefulWidget {
  /// Nombre de la feature que disparó el paywall (se muestra en el mensaje).
  final String featureName;

  const PaywallPage({super.key, required this.featureName});

  @override
  ConsumerState<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends ConsumerState<PaywallPage> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final offeringsAsync = ref.watch(offeringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMuted),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('✨', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            const Text(
              'KakeiboPro Premium',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.featureName} es parte del plan de pago.',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            const _BenefitRow(
              icon: Icons.family_restroom,
              text: 'Familia completa — hasta 6 miembros',
            ),
            const _BenefitRow(
              icon: Icons.auto_awesome,
              text: 'Asistente financiero con IA (Claude)',
            ),
            const _BenefitRow(
              icon: Icons.email_outlined,
              text: 'Detección automática de correos bancarios',
            ),
            const _BenefitRow(
              icon: Icons.document_scanner_outlined,
              text: 'OCR de recibos y comprobantes',
            ),
            const _BenefitRow(
              icon: Icons.upload_file_outlined,
              text: 'Importación de CSV bancarios (BN y BAC)',
            ),
            const _BenefitRow(
              icon: Icons.sync,
              text: 'Sincronización entre dispositivos',
            ),

            const SizedBox(height: 32),

            offeringsAsync.when(
              loading: () => const CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 2,
              ),
              error: (_, __) => const Text(
                'No se pudieron cargar los planes. Verificá tu conexión.',
                style: TextStyle(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              data: (offerings) {
                if (offerings.isEmpty) {
                  // Fallback estático hasta que RevenueCat esté configurado
                  return _PlanCard(
                    title: 'Plan Familiar',
                    price: '₡4,990/mes',
                    description: 'Para toda la familia',
                    isRecommended: true,
                    onTap: () => _purchase('kakeibopro_familiar_monthly'),
                    isLoading: _isLoading,
                  );
                }
                return Column(
                  children: offerings
                      .map((o) => _PlanCard(
                            title: o['title'] as String? ?? o['identifier'] as String,
                            price: o['price'] as String? ?? '',
                            description: '',
                            isRecommended:
                                o['identifier'] == r'$rc_monthly',
                            onTap: () => _purchase(o['identifier'] as String),
                            isLoading: _isLoading,
                          ))
                      .toList(),
                );
              },
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 16),

            TextButton(
              onPressed: _restorePurchases,
              child: const Text(
                'Restaurar compras anteriores',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Se cobra a través de Google Play.\n'
              'Cancelá en cualquier momento desde la Play Store.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchase(String packageId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final ok = await ref.read(purchasesServiceProvider).purchase(packageId);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() =>
          _errorMessage = 'No se pudo completar la compra. Intentá de nuevo.');
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);
    final ok = await ref.read(purchasesServiceProvider).restorePurchases();
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(
          () => _errorMessage = 'No se encontraron compras anteriores.');
    }
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BenefitRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool isRecommended;
  final VoidCallback onTap;
  final bool isLoading;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.description,
    required this.isRecommended,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRecommended
            ? AppColors.green.withValues(alpha: 0.08)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecommended ? AppColors.green : AppColors.border,
          width: isRecommended ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isRecommended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'RECOMENDADO',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.green,
                          strokeWidth: 2,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.textMuted,
                            size: 14,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
