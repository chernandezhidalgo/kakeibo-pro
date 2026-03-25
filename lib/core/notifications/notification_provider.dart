import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/notifications/notification_service.dart';

/// Expone el singleton [NotificationService] al árbol de providers.
final notificationServiceProvider = Provider<NotificationService>((_) {
  return NotificationService.instance;
});
