import 'dart:convert';
import 'package:msal_flutter/msal_flutter.dart';
import 'package:kakeibo_pro/features/email/domain/models/bank_email.dart';

/// Servicio de Outlook/Microsoft Graph para importar correos bancarios.
///
/// Autenticación via MSAL (Microsoft Authentication Library).
///
/// PASOS MANUALES requeridos antes de compilar:
///  1. Registra la aplicación en https://portal.azure.com
///     → Azure Active Directory → App registrations → New registration
///     → Redirect URI: msauth://com.hernandezromero.kakeibo_pro/BASE64_HASH
///  2. Copia el Application (client) ID al archivo .env:
///     MSAL_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
///  3. Descarga o actualiza android/app/src/main/res/raw/auth_config_single_account.json
///     con el client_id correcto.
///  4. Asegúrate de que BrowserTabActivity esté en AndroidManifest.xml (ya incluido).
class OutlookService {
  static const _clientId =
      String.fromEnvironment('MSAL_CLIENT_ID', defaultValue: '');
  static const _authority = 'https://login.microsoftonline.com/common';
  static const _scopes = ['Mail.Read'];

  PublicClientApplication? _pca;
  bool _isSignedIn = false;
  String? _userEmail;
  String? _accessToken;

  bool get isSignedIn => _isSignedIn;
  String? get userEmail => _userEmail;

  /// Inicializa el cliente MSAL. Se llama automáticamente desde [signIn].
  Future<void> initialize() async {
    if (_pca != null) return;
    _pca = await PublicClientApplication.createPublicClientApplication(
      _clientId,
      authority: _authority,
    );
  }

  /// Inicia sesión con Microsoft usando MSAL (flujo interactivo).
  ///
  /// El token JWT devuelto se decodifica para extraer el email del usuario.
  Future<void> signIn() async {
    if (_clientId.isEmpty) {
      throw Exception(
        'MSAL_CLIENT_ID no configurado. '
        'Registra la app en portal.azure.com y agrega el CLIENT_ID al .env.',
      );
    }
    await initialize();
    try {
      // acquireToken recibe la lista de scopes como argumento posicional
      // y devuelve el JWT access token como String.
      final token = await _pca!.acquireToken(_scopes);
      _accessToken = token;
      _isSignedIn = true;
      _userEmail = _extractEmailFromJwt(token);
    } on MsalUserCancelledException {
      throw Exception('El usuario canceló el inicio de sesión.');
    } on MsalException catch (e) {
      throw Exception('Error MSAL: $e');
    }
  }

  /// Cierra sesión limpiando el estado local.
  ///
  /// La sesión MSAL expirará de forma natural en el servidor.
  Future<void> signOut() async {
    _isSignedIn = false;
    _userEmail = null;
    _accessToken = null;
  }

  /// Obtiene correos bancarios desde Outlook via Microsoft Graph.
  ///
  /// Requiere haber completado [signIn] primero.
  /// TODO(F5): implementar llamada real a Microsoft Graph /me/messages
  ///           con filtro OData por remitentes bancarios conocidos.
  Future<List<BankEmail>> fetchBankEmails({int daysBack = 90}) async {
    if (!_isSignedIn || _accessToken == null) {
      throw Exception('No hay sesión de Outlook activa');
    }
    // TODO: llamada a https://graph.microsoft.com/v1.0/me/messages
    // con Authorization: Bearer $_accessToken
    // y filtro $filter=from/emailAddress/address eq 'alertas@bncr.fi.cr'
    return [];
  }

  // ── Utilidades privadas ───────────────────────────────────────────────────

  /// Extrae el campo `preferred_username` (email) del payload JWT.
  ///
  /// El JWT tiene el formato `header.payload.signature` en Base64Url.
  String? _extractEmailFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      // Base64Url puede no tener padding → lo normalizamos
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final claims = jsonDecode(decoded) as Map<String, dynamic>;
      return (claims['preferred_username'] ??
              claims['email'] ??
              claims['upn']) as String?;
    } catch (_) {
      return null;
    }
  }
}
