import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/constants/app_strings.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/family_provider.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/pages/envelopes_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final familyAsync = ref.watch(currentFamilyProvider);

    return familyAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.green,
            strokeWidth: 2,
          ),
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
          // GoRouter debería haber redirigido — estado defensivo
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: SizedBox.shrink(),
          );
        }

        final pages = [
          EnvelopesPage(familyId: family.id),
          const _PlaceholderPage(
            label: AppStrings.navResumen,
            icon: Icons.pie_chart_outline,
          ),
          const _PlaceholderPage(
            label: AppStrings.navKakeibo,
            icon: Icons.auto_stories_outlined,
          ),
          const _PlaceholderPage(
            label: AppStrings.navPerfil,
            icon: Icons.person_outline,
          ),
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: _BottomNav(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        );
      },
    );
  }
}

// ── Barra de navegación inferior ──────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.green.withValues(alpha: 0.15),
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined),
            selectedIcon: Icon(Icons.wallet, color: AppColors.green),
            label: AppStrings.navSobres,
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart, color: AppColors.green),
            label: AppStrings.navResumen,
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories, color: AppColors.green),
            label: AppStrings.navKakeibo,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.green),
            label: AppStrings.navPerfil,
          ),
        ],
      ),
    );
  }
}

// ── Placeholder para tabs futuras (F2+) ──────────────────────────────────────

class _PlaceholderPage extends ConsumerWidget {
  final String label;
  final IconData icon;

  const _PlaceholderPage({required this.label, required this.icon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textMuted),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await ref.read(signOutUseCaseProvider).call();
            },
          ),
        ],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textMuted, size: 48),
            const SizedBox(height: 16),
            Text(
              '$label — próximamente',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
