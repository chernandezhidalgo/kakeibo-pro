import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/purchases/purchases_provider.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPremiumAsync = ref.watch(hasPremiumProvider);
    final hasFamiliarAsync = ref.watch(hasFamiliarPlanProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(color: AppColors.textMuted),
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Suscripción ────────────────────────────────────────────────────
          const _SectionHeader(title: 'SUSCRIPCIÓN'),
          hasPremiumAsync.when(
            loading: () => const _LoadingTile(),
            error: (_, __) => const _ErrorTile(),
            data: (hasPremium) => hasPremium
                ? hasFamiliarAsync.when(
                    loading: () => const _LoadingTile(),
                    error: (_, __) => const _ErrorTile(),
                    data: (isFamiliar) => _SettingsTile(
                      icon: Icons.star,
                      iconColor: AppColors.gold,
                      title: isFamiliar
                          ? 'Plan Familiar activo'
                          : 'Plan Individual activo',
                      subtitle: 'Administrá tu suscripción en Google Play',
                      trailing: const Icon(
                        Icons.check_circle,
                        color: AppColors.green,
                        size: 20,
                      ),
                      onTap: null,
                    ),
                  )
                : _SettingsTile(
                    icon: Icons.upgrade_rounded,
                    iconColor: AppColors.green,
                    title: 'Actualizar a Premium',
                    subtitle: 'Desbloquear todas las funciones',
                    onTap: () => context.push('/paywall?feature=Premium'),
                  ),
          ),

          const SizedBox(height: 24),

          // ── Correos conectados ─────────────────────────────────────────────
          const _SectionHeader(title: 'CORREOS CONECTADOS'),
          _SettingsTile(
            icon: Icons.email_outlined,
            iconColor: AppColors.blue,
            title: 'Gmail',
            subtitle: 'Detecta transacciones en correos bancarios',
            onTap: () => context.push('/correos/gmail'),
          ),
          _SettingsTile(
            icon: Icons.mail_outlined,
            iconColor: AppColors.blue,
            title: 'Outlook / Hotmail',
            subtitle: 'Conectar cuenta Microsoft',
            onTap: () => context.push('/correos/outlook'),
          ),

          const SizedBox(height: 24),

          // ── Cuenta ────────────────────────────────────────────────────────
          const _SectionHeader(title: 'CUENTA'),
          _SettingsTile(
            icon: Icons.family_restroom,
            iconColor: AppColors.textMuted,
            title: 'Miembros de la familia',
            subtitle: 'Gestionar invitaciones y roles',
            onTap: () => context.push('/invite'),
          ),
          _SettingsTile(
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            title: 'Cerrar sesión',
            subtitle: null,
            onTap: () => _confirmSignOut(context, ref),
          ),

          const SizedBox(height: 24),

          // ── Acerca de ──────────────────────────────────────────────────────
          const _SectionHeader(title: 'ACERCA DE'),
          const _SettingsTile(
            icon: Icons.info_outline,
            iconColor: AppColors.textMuted,
            title: 'KakeiboPro v1.0',
            subtitle: 'Familia Hernández-Romero · 2026',
            onTap: null,
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Tus datos locales se mantienen. '
          'Podrás volver a iniciar sesión cuando quieras.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(signOutUseCaseProvider).call();
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(
                  color: AppColors.error, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12),
              )
            : null,
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right,
                    color: AppColors.textMuted, size: 18)
                : null),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: CircularProgressIndicator(
              color: AppColors.green, strokeWidth: 2),
        ),
      );
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile();
  @override
  Widget build(BuildContext context) => const Text(
        'Error al cargar el estado de suscripción.',
        style: TextStyle(color: AppColors.error, fontSize: 12),
      );
}
