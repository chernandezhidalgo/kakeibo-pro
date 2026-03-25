import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/constants/app_strings.dart';
import 'package:kakeibo_pro/features/ai/presentation/pages/chat_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/family_provider.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/pages/envelopes_page.dart';
import 'package:kakeibo_pro/features/home/presentation/pages/summary_page.dart';

/// Pantalla de inicio para Windows 11 con [NavigationRail] lateral.
///
/// Ofrece la misma funcionalidad que [HomeScreen] pero con una disposición
/// adaptada al escritorio: panel de navegación a la izquierda y contenido
/// principal expandido a la derecha.
class WindowsHomeScreen extends ConsumerStatefulWidget {
  const WindowsHomeScreen({super.key});

  @override
  ConsumerState<WindowsHomeScreen> createState() => _WindowsHomeScreenState();
}

class _WindowsHomeScreenState extends ConsumerState<WindowsHomeScreen> {
  int _selectedIndex = 0;

  static const _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.wallet_outlined),
      selectedIcon: Icon(Icons.wallet, color: AppColors.green),
      label: Text(AppStrings.navSobres),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.pie_chart_outline),
      selectedIcon: Icon(Icons.pie_chart, color: AppColors.green),
      label: Text(AppStrings.navResumen),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.auto_stories_outlined),
      selectedIcon: Icon(Icons.auto_stories, color: AppColors.green),
      label: Text(AppStrings.navKakeibo),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.auto_awesome_outlined),
      selectedIcon: Icon(Icons.auto_awesome, color: AppColors.gold),
      label: Text('Kakei IA'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            'Error al cargar la familia: $e',
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

        final pages = [
          EnvelopesPage(familyId: family.id),
          SummaryPage(familyId: family.id),
          _KakeiboHubPlaceholder(familyId: family.id),
          const ChatPage(),
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              // ── Rail de navegación ─────────────────────────────────────────
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    right: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: NavigationRail(
                  backgroundColor: Colors.transparent,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (i) =>
                      setState(() => _selectedIndex = i),
                  extended: true, // muestra etiquetas + íconos
                  minExtendedWidth: 180,
                  indicatorColor: AppColors.green.withValues(alpha: 0.15),
                  selectedIconTheme:
                      const IconThemeData(color: AppColors.green),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  unselectedIconTheme:
                      const IconThemeData(color: AppColors.textMuted),
                  unselectedLabelTextStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Row(
                      children: const [
                        Icon(Icons.account_balance_wallet,
                            color: AppColors.green, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'KakeiboPro',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  destinations: _destinations,
                  trailing: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                    child: TextButton.icon(
                      icon: const Icon(Icons.settings_outlined,
                          color: AppColors.textMuted, size: 18),
                      label: const Text(
                        'Configuración',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () => context.push('/settings'),
                    ),
                  ),
                ),
              ),

              // ── Contenido principal ────────────────────────────────────────
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: pages,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Placeholder para el hub de Kakeibo en Windows ────────────────────────────

class _KakeiboHubPlaceholder extends StatelessWidget {
  final String familyId;
  const _KakeiboHubPlaceholder({required this.familyId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Kakeibo',
        style: TextStyle(color: AppColors.textMuted, fontSize: 20),
      ),
    );
  }
}
