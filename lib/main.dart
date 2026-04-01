import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/notifications/notification_service.dart';
import 'package:kakeibo_pro/core/purchases/purchases_service.dart';
import 'package:kakeibo_pro/features/paywall/presentation/pages/paywall_page.dart';
import 'package:kakeibo_pro/features/settings/presentation/pages/settings_page.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
import 'package:kakeibo_pro/features/envelopes/presentation/pages/edit_envelope_page.dart';
import 'package:kakeibo_pro/features/envelopes/presentation/pages/envelope_detail_page.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:kakeibo_pro/features/transactions/presentation/pages/edit_transaction_page.dart';
import 'package:kakeibo_pro/core/utils/platform_utils.dart';
import 'package:kakeibo_pro/features/home/presentation/pages/home_screen.dart';
import 'package:kakeibo_pro/features/home/presentation/pages/teen_home_screen.dart';
import 'package:kakeibo_pro/features/home/presentation/pages/windows_home_screen.dart';
import 'package:kakeibo_pro/features/csv/presentation/pages/csv_import_page.dart';
import 'package:kakeibo_pro/features/email/presentation/pages/email_transactions_page.dart';
import 'package:kakeibo_pro/features/email/presentation/pages/gmail_connect_page.dart';
import 'package:kakeibo_pro/features/email/presentation/pages/outlook_connect_page.dart';
import 'package:kakeibo_pro/features/ai/presentation/pages/chat_page.dart';
import 'package:kakeibo_pro/features/ocr/presentation/pages/ocr_capture_page.dart';
import 'package:kakeibo_pro/features/goals/presentation/pages/savings_goals_page.dart';
import 'package:kakeibo_pro/features/kakeibo/presentation/pages/kakeibo_reflection_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/pages/register_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/pages/setup_family_page.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/family_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Supabase — lee variables inyectadas en tiempo de compilación:
  //    flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
  // Inicializar datos de localización para DateFormat en español
  await initializeDateFormatting('es');

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  // 2. Base de datos local Drift
  final database = await AppDatabase.open();

  // 3. Firebase + NotificationService (solo en plataformas móviles)
  if (!kIsWeb) {
    await Firebase.initializeApp();
    await NotificationService.instance.initialize();
  }

  // 4. RevenueCat — configurar antes de runApp.
  //    REVENUECAT_API_KEY se inyecta con --dart-define en builds de producción.
  //    En desarrollo (key vacía) el servicio queda silencioso (modo demo).
  if (!kIsWeb) {
    await PurchasesService().configure(
      const String.fromEnvironment(
        'REVENUECAT_API_KEY',
        defaultValue: 'TU_REVENUECAT_API_KEY',
      ),
      '', // userId se actualiza después del login via authStateProvider
    );
  }

  // 5. WorkManager y listener de red — solo disponibles en Android (no en web)
  if (!kIsWeb) {
    await SyncWorkerSetup.initialize();
    await SyncWorkerSetup.registerPeriodicSync();
    ConnectivityListener.start();
  }

  // 6. Sentry — inicializa monitoreo de errores y performance.
  //    SENTRY_DSN vacío en desarrollo = Sentry silencioso (sin enviar datos).
  //    NOTA: Se usa sin appRunner para evitar el Zone mismatch con el binding
  //    que ya fue inicializado en la zona raíz (línea 1 del main).
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment(
        'SENTRY_DSN',
        defaultValue: '', // vacío en dev — sin telemetría
      );
      options.tracesSampleRate = 0.2; // 20% de transacciones
      options.environment = const String.fromEnvironment(
        'APP_ENV',
        defaultValue: 'development',
      );
      options.debug = false;
    },
  );

  // runApp se ejecuta en la misma zona donde se llamó ensureInitialized().
  runApp(
    ProviderScope(
      overrides: [
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
          builder: (_, __) => PlatformUtils.useRailNavigation
              ? const WindowsHomeScreen()
              : const HomeScreen(),
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
        GoRoute(
          path: '/sobres/:envelopeId',
          name: 'detalle-sobre',
          builder: (context, state) {
            final envelopeId = state.pathParameters['envelopeId'] ?? '';
            final familyId =
                state.uri.queryParameters['familyId'] ?? '';
            return EnvelopeDetailPage(
              envelopeId: envelopeId,
              familyId: familyId,
            );
          },
        ),
        GoRoute(
          path: '/sobres/:envelopeId/agregar-movimiento',
          name: 'agregar-movimiento',
          builder: (context, state) {
            final familyId =
                state.uri.queryParameters['familyId'] ?? '';
            final envelope = state.extra as Envelope;
            return AddTransactionPage(
              envelope: envelope,
              familyId: familyId,
            );
          },
        ),
        GoRoute(
          path: '/sobres/:envelopeId/editar',
          name: 'editar-sobre',
          builder: (context, state) {
            final envelope = state.extra as Envelope;
            return EditEnvelopePage(envelope: envelope);
          },
        ),
        GoRoute(
          path: '/sobres/:envelopeId/movimiento/:txId/editar',
          name: 'editar-movimiento',
          builder: (context, state) {
            final transaction = state.extra as Transaction;
            return EditTransactionPage(transaction: transaction);
          },
        ),
        GoRoute(
          path: '/sobres/:envelopeId/importar-csv',
          name: 'importar-csv',
          builder: (context, state) {
            final envelopeId = state.pathParameters['envelopeId'] ?? '';
            final familyId = state.uri.queryParameters['familyId'] ?? '';
            final envelopeName =
                state.uri.queryParameters['envelopeName'] ?? '';
            final registeredBy =
                state.uri.queryParameters['userId'] ?? '';
            return CsvImportPage(
              envelopeId: envelopeId,
              envelopeName: envelopeName,
              familyId: familyId,
              registeredBy: registeredBy,
            );
          },
        ),
        GoRoute(
          path: '/kakeibo/reflexion',
          name: 'kakeibo-reflexion',
          builder: (context, state) {
            final extra = (state.extra as Map<String, dynamic>?) ?? {};
            final familyId = extra['familyId'] as String? ?? '';
            final incomeTotal = extra['incomeTotal'] as double? ?? 0.0;
            final expenseTotal = extra['expenseTotal'] as double? ?? 0.0;
            return KakeiboReflectionPage(
              familyId: familyId,
              incomeTotal: incomeTotal,
              expenseTotal: expenseTotal,
            );
          },
        ),
        GoRoute(
          path: '/metas',
          name: 'metas',
          builder: (context, state) {
            final familyId = state.uri.queryParameters['familyId'] ?? '';
            return SavingsGoalsPage(familyId: familyId);
          },
        ),
        GoRoute(
          path: '/correos/gmail',
          name: 'correos-gmail',
          builder: (context, state) => const GmailConnectPage(),
        ),
        GoRoute(
          path: '/correos/pendientes',
          name: 'correos-pendientes',
          builder: (context, state) => const EmailTransactionsPage(),
        ),
        GoRoute(
          path: '/correos/outlook',
          name: 'correos-outlook',
          builder: (context, state) => const OutlookConnectPage(),
        ),
        GoRoute(
          path: '/chat',
          name: 'chat',
          builder: (context, state) => const ChatPage(),
        ),
        GoRoute(
          path: '/sobres/:envelopeId/ocr',
          name: 'ocr-captura',
          builder: (context, state) {
            final envelopeId = state.pathParameters['envelopeId'] ?? '';
            final familyId =
                state.uri.queryParameters['familyId'] ?? '';
            return OcrCapturePage(
                envelopeId: envelopeId, familyId: familyId);
          },
        ),
        GoRoute(
          path: '/teen-home',
          name: 'teen-home',
          builder: (_, __) => const TeenHomeScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (_, __) => const SettingsPage(),
        ),
        GoRoute(
          path: '/paywall',
          name: 'paywall',
          builder: (context, state) {
            final feature =
                state.uri.queryParameters['feature'] ?? 'Premium';
            return PaywallPage(featureName: feature);
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

