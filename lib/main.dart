import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/constants/app_strings.dart';
import 'package:kakeibo_pro/features/auth/presentation/pages/login_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/pages/register_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase lee las variables inyectadas en tiempo de compilación:
  // flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(const ProviderScope(child: KakeiboApp()));
}

// ── App raíz ──────────────────────────────────────────────────────────────────

class KakeiboApp extends ConsumerStatefulWidget {
  const KakeiboApp({super.key});

  @override
  ConsumerState<KakeiboApp> createState() => _KakeiboAppState();
}

class _KakeiboAppState extends ConsumerState<KakeiboApp> {
  late final GoRouter _router;
  late final _AuthChangeNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authNotifier = _AuthChangeNotifier();

    _router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _authNotifier,
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (_, __) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (_, __) => const RegisterPage(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (_, __) => const _DashboardPlaceholder(),
        ),
      ],
      redirect: (context, state) {
        final isAuthenticated = _authNotifier.isAuthenticated;
        final loc = state.matchedLocation;
        final isAuthRoute = loc == '/login' || loc == '/register';

        if (isAuthenticated && isAuthRoute) return '/dashboard';
        if (!isAuthenticated && !isAuthRoute) return '/login';
        return null; // Sin redirección
      },
    );
  }

  @override
  void dispose() {
    _authNotifier.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sincroniza el estado de auth con GoRouter para que las rutas
    // se reevalúen automáticamente tras login / logout.
    ref.listen(authStateProvider, (_, next) {
      _authNotifier.updateAuth(next.valueOrNull != null);
    });

    return MaterialApp.router(
      routerConfig: _router,
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildDarkTheme(),
    );
  }

  // ── Tema oscuro ────────────────────────────────────────────────────────

  ThemeData _buildDarkTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.surface,
          primary: AppColors.green,
          secondary: AppColors.blue,
          error: AppColors.error,
          onPrimary: Colors.black,
          onSurface: AppColors.textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          labelStyle: const TextStyle(color: AppColors.textMuted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          bodySmall: TextStyle(color: AppColors.textMuted),
        ),
      );
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// [ChangeNotifier] que conecta [authStateProvider] con el [refreshListenable]
/// de GoRouter, forzando la reevaluación de rutas al cambiar el estado de auth.
class _AuthChangeNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void updateAuth(bool value) {
    if (_isAuthenticated != value) {
      _isAuthenticated = value;
      notifyListeners();
    }
  }
}

// ── Placeholder del Dashboard ─────────────────────────────────────────────────

/// Pantalla vacía que ocupará el dashboard mientras se implementa F1-S4.
class _DashboardPlaceholder extends ConsumerWidget {
  const _DashboardPlaceholder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(signOutUseCaseProvider).call();
              // GoRouter redirige a /login al detectar session == null
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Dashboard — próximamente (F1-S4)',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
