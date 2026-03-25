import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handler global para mensajes FCM recibidos con app en background/terminada.
/// Debe ser una función top-level (no puede ser un método de clase).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase ya se inicializó en main(); aquí solo procesamos el mensaje.
  await NotificationService.instance.showLocalNotification(
    id: message.hashCode,
    title: message.notification?.title ?? 'KakeiboPro',
    body: message.notification?.body ?? '',
  );
}

/// Servicio singleton para FCM + notificaciones locales.
///
/// Ciclo de vida:
///  1. `await NotificationService.instance.initialize()` en main()
///  2. Usar `showLocalNotification()` para lanzar notificaciones programáticas.
///  3. Llamar `requestPermission()` la primera vez que el usuario entra a la app.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _fcm = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  /// Canal por defecto para notificaciones de presupuesto.
  static const _budgetChannelId = 'kakeibo_budget_alerts';
  static const _budgetChannelName = 'Alertas de presupuesto';
  static const _budgetChannelDesc =
      'Notificaciones cuando un sobre excede su presupuesto mensual.';

  /// Inicializa FCM y el plugin de notificaciones locales.
  ///
  /// Llamar con `await` en main() antes de `runApp()`.
  Future<void> initialize() async {
    // ── Configurar notificaciones locales ────────────────────────────────────
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
      ),
    );

    // ── Crear canal Android (requerido en API 26+) ───────────────────────────
    const androidChannel = AndroidNotificationChannel(
      _budgetChannelId,
      _budgetChannelName,
      description: _budgetChannelDesc,
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // ── Handler para mensajes en background ─────────────────────────────────
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // ── Handler para mensajes con app en foreground ──────────────────────────
    FirebaseMessaging.onMessage.listen((message) {
      showLocalNotification(
        id: message.hashCode,
        title: message.notification?.title ?? 'KakeiboPro',
        body: message.notification?.body ?? '',
      );
    });
  }

  /// Solicita permiso para mostrar notificaciones (iOS y Android 13+).
  ///
  /// No bloquea si el usuario deniega — la app funciona sin notificaciones.
  Future<void> requestPermission() async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Muestra una notificación local inmediata.
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _budgetChannelId,
          _budgetChannelName,
          channelDescription: _budgetChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  /// Devuelve el token FCM del dispositivo.
  ///
  /// Usar para registrarlo en Supabase y enviar notificaciones dirigidas.
  Future<String?> getToken() => _fcm.getToken();
}
