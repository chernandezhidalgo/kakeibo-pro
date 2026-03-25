import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/features/email/presentation/providers/outlook_provider.dart';

class OutlookConnectPage extends ConsumerWidget {
  const OutlookConnectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outlookProvider);
    final notifier = ref.read(outlookProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textMuted, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Conectar Outlook',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.mail_outlined,
                  size: 40, color: Color(0xFF0078D4)), // azul Microsoft
            ),
            const SizedBox(height: 24),
            const Text(
              'Importa transacciones desde Outlook',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'KakeiboPro leerá solo correos de alertas bancarias (BN, BAC, '
              'Davivienda, Scotiabank) en tu cuenta de Outlook/Microsoft 365.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Banner de estado pendiente
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.construction_outlined,
                      color: AppColors.gold, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Integración en configuración. Se requiere registrar '
                      'la app en Azure Portal. Contáctanos para activarla.',
                      style:
                          TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (state.isSignedIn) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cuenta conectada',
                            style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            state.userEmail ?? '',
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: notifier.signOut,
                child: const Text(
                  'Desconectar cuenta',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ] else ...[
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Conectar con Microsoft'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0078D4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: notifier.signIn,
                ),
            ],

            if (state.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                style:
                    const TextStyle(color: AppColors.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
