import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/core/logging/app_logger.dart';
import 'package:kakeibo_pro/core/purchases/purchases_service.dart';
import 'package:kakeibo_pro/features/email/data/services/gmail_service.dart';
import 'package:kakeibo_pro/features/email/data/services/outlook_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Error que se puede mostrar en pantalla. No incluye detalles de SQL.
class DeleteAccountException implements Exception {
  DeleteAccountException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Borra la cuenta en Supabase y después limpia el teléfono.
///
/// El borrado remoto lo hace la Edge Function `delete-account`. Si esa
/// llamada falla, no se toca la base local.
class DeleteAccountService {
  DeleteAccountService({
    required SupabaseClient client,
    required AppDatabase database,
    required PurchasesService purchases,
    GmailService? gmail,
    OutlookService? outlook,
  })  : _client = client,
        _database = database,
        _purchases = purchases,
        _gmail = gmail ?? GmailService(),
        _outlook = outlook ?? OutlookService();

  final SupabaseClient _client;
  final AppDatabase _database;
  final PurchasesService _purchases;
  final GmailService _gmail;
  final OutlookService _outlook;

  Future<void> deleteAccount() async {
    await _deleteRemote();

    var localCleanupFailed = false;

    try {
      await _gmail.revokeGrantedAccess();
    } catch (error, stackTrace) {
      localCleanupFailed = true;
      appLogger.e(
        'No se pudo revocar Gmail al eliminar la cuenta',
        error: error,
        stackTrace: stackTrace,
      );
    }

    if (!kIsWeb) {
      try {
        await _outlook.revokeGrantedAccess();
      } catch (error, stackTrace) {
        localCleanupFailed = true;
        appLogger.e(
          'No se pudo cerrar Outlook al eliminar la cuenta',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    try {
      await _purchases.logOut();
    } catch (error, stackTrace) {
      appLogger.w(
        'RevenueCat no cerró sesión al eliminar la cuenta',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      await _database.wipeAllLocalData();
      await AppDatabase.clearSecureStoragePreservingDbKey();
    } catch (error, stackTrace) {
      localCleanupFailed = true;
      appLogger.e(
        'No se pudo limpiar la base local al eliminar la cuenta',
        error: error,
        stackTrace: stackTrace,
      );
    }

    try {
      await _client.auth.signOut();
    } catch (error, stackTrace) {
      localCleanupFailed = true;
      appLogger.e(
        'No se pudo cerrar la sesión al eliminar la cuenta',
        error: error,
        stackTrace: stackTrace,
      );
    }

    if (localCleanupFailed) {
      throw DeleteAccountException(
        'Tu cuenta ya se eliminó en la nube, pero este teléfono no quedó '
        'limpio del todo. Ciérrala y vuelve a abrirla. Si aún ves datos, '
        'desinstálala.',
      );
    }
  }

  Future<void> _deleteRemote() async {
    try {
      final response = await _client.functions.invoke('delete-account');
      final data = response.data;
      if (data is Map && data['ok'] == true) return;
      throw DeleteAccountException(
        'El servidor no confirmó la eliminación. '
        'No se borró nada en este teléfono.',
      );
    } on FunctionException catch (error, stackTrace) {
      appLogger.e(
        'delete-account rechazada',
        error: error,
        stackTrace: stackTrace,
      );
      throw DeleteAccountException(_messageFromFunction(error));
    } on DeleteAccountException {
      rethrow;
    } catch (error, stackTrace) {
      appLogger.e(
        'delete-account falló',
        error: error,
        stackTrace: stackTrace,
      );
      throw DeleteAccountException(
        'No se pudo eliminar la cuenta. Revisa tu conexión e inténtalo de nuevo.',
      );
    }
  }

  String _messageFromFunction(FunctionException error) {
    final details = error.details;
    if (details is Map && details['error'] is String) {
      final message = (details['error'] as String).trim();
      if (message.isNotEmpty && message.length < 240) return message;
    }
    if (error.status == 404) {
      return 'La eliminación de cuenta todavía no está activada en el servidor. '
          'Escribe a info.kakeibopro@gmail.com.';
    }
    return 'No se pudo eliminar la cuenta. Revisa tu conexión e inténtalo de nuevo.';
  }
}
