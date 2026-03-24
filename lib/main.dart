import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/constants/app_strings.dart';
import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/core/database/database_provider.dart';
import 'package:kakeibo_pro/core/sync/connectivity_listener.dart';
import 'package:kakeibo_pro/core/sync/sync_worker.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family.dart' show KakeiboFamily;
import 'package:kakeibo_pro/features/auth/presentation/pages/invite_member_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/pages/login_page.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/pages/create_envelope_page.dart';
import 'package:kakeibo_pro/features/home/presentation/pages/home_screen.dart';
import 'package:kakeibo_pro/features/auth/presentation/pages/register_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/pages/setup_family_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/family_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Supabase — lee variables inyectadas en tiempo de compilación:
  //    flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  // 2. Base de datos local Drift
  final database = await AppDatabase.open();

  // 3. WorkManager y listener de red — solo disponibles en Android (no en web)
  if (!kIsWeb) {
    await SyncWorkerSetup.initialize();
    await SyncWorkerSetup.registerPeriodicSync();
    ConnectivityListener.start();
  }

  runApp(
    ProviderScope(
      overrides: [
        // Inyectar la instancia real de la DB para todos los providers
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const KakeiboApp(),
    ),
  );
}

// ── App raíz ──────────────────────────────────────────────────────────────────

class KakeiboApp extends ConsumerStatefulWidget {
  const KakeiboApp({super.key});

  @override
  ConsumerState<KakeiboApp> createState() => _KakeiboAppState();
}

class _KakeiboAppState extends ConsumerState<KakeiboApp> {
  late final GoRouter _router;
  late final _RouterNotifier _routerNotifier;

  @override
  void initState() {
    super.initState();
    _routerNotifier = _RouterNotifier();

    _router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _routerNotifier,
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
          path: '/setup-family',
          name: 'setup-family',
          builder: (_, __) => const SetupFamilyPage(),
        ),
        GoRoute(
          path: '/invite',
          name: 'invite',
          builder: (_, __) => const InviteMemberPage(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/sobres/crear',
          name: 'crear-sobre',
          builder: (context, state) {
            final familyId =
                state.uri.queryParameters['familyId'] ?? '';
            return CreateEnvelopePage(familyId: familyId);
          },
        ),
      ],
      redirect: (context, state) {
        final isAuthenticated = _routerNotifier.isAuthenticated;
        final hasFamily = _routerNotifier.hasFamily;
        final isFamilyLoading = _routerNotifier.isFamilyLoading;
        final loc = state.matchedLocation;

        final isAuthRoute = loc == '/login' || loc == '/register';
        final isSetupRoute = loc == '/setup-family';

        // 1. No autenticado → siempre a /login
        if (!isAuthenticated) {
          return isAuthRoute ? null : '/login';
        }

        // 2. Autenticado, familia cargando → sin redirigir aún
        if (isFamilyLoading) return null;

        // 3. Autenticado sin familia → /setup-family
        if (!hasFamily) {
          return isSetupRoute ? null : '/setup-family';
        }

        // 4. Autenticado con familia → si está en ruta de auth o setup, ir al dashboard
        if (isAuthRoute || isSetupRoute) return '/dashboard';

        return null; // Sin redirección
      },
    );
  }

  @override
  void dispose() {
    _routerNotifier.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sincroniza auth con GoRouter
    ref.listen(authStateProvider, (_, next) {
      _routerNotifier.updateAuth(next.valueOrNull != null);
    });

    // Sincroniza estado de familia con GoRouter
    ref.listen<AsyncValue<KakeiboFamily?>>(currentFamilyProvider, (_, next) {
      _routerNotifier.updateFamilyState(next);
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

// ── Router Notifier ───────────────────────────────────────────────────────────

/// [ChangeNotifier] que conecta los providers de auth y familia con el
/// [refreshListenable] de GoRouter, forzando la reevaluación de rutas
/// al cambiar cualquiera de los dos estados.
class _RouterNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _hasFamily = false;
  bool _isFamilyLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get hasFamily => _hasFamily;
  bool get isFamilyLoading => _isFamilyLoading;

  void updateAuth(bool value) {
    if (_isAuthenticated == value) return;
    _isAuthenticated = value;
    // Al cerrar sesión, reiniciamos el estado de familia
    if (!value) {
      _hasFamily = false;
      _isFamilyLoading = false;
    }
    notifyListeners();
  }

  void updateFamilyState(AsyncValue<KakeiboFamily?> next) {
    final newHasFamily = next.valueOrNull != null;
    final newIsLoading = next.isLoading;

    if (_hasFamily == newHasFamily && _isFamilyLoading == newIsLoading) return;
    _hasFamily = newHasFamily;
    _isFamilyLoading = newIsLoading;
    notifyListeners();
  }
}

