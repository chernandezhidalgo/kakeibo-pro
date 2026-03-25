import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/features/email/presentation/providers/gmail_provider.dart';

class GmailConnectPage extends ConsumerWidget {
  const GmailConnectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gmailProvider);
    final notifier = ref.read(gmailProvider.notifier);

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
          'Conectar Gmail',
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
            // ── Icono ────────────────────────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.email_outlined,
                  size: 40, color: AppColors.blue),
            ),
            const SizedBox(height: 24),
            const Text(
              'Importa transacciones desde tus correos bancarios',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'KakeiboPro leerá solo correos de alertas bancarias (BN, BAC, '
              'Davivienda, Scotiabank) y extraerá el monto y comercio '
              'automáticamente. No accedemos a ningún otro correo.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // ── Estado conectado ─────────────────────────────────────────────
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
                              fontWeight: FontWeight.w600,
                            ),
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.inbox_outlined),
                label: const Text('Ver correos bancarios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.push('/correos/pendientes'),
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
              // ── Botón conectar ───────────────────────────────────────────
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Conectar con Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: notifier.signIn,
                ),
            ],

            // ── Error ────────────────────────────────────────────────────────
            if (state.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
