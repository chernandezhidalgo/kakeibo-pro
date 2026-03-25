import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

import 'package:kakeibo_pro/features/email/domain/models/bank_email.dart';
import 'package:kakeibo_pro/features/email/domain/parsers/bac_email_parser.dart';
import 'package:kakeibo_pro/features/email/domain/parsers/bn_email_parser.dart';

class GmailService {
  static const _scopes = [gmail.GmailApi.gmailReadonlyScope];

  final _googleSignIn = GoogleSignIn(scopes: _scopes);

  GoogleSignInAccount? _account;

  bool get isSignedIn => _account != null;
  String? get userEmail => _account?.email;

  Future<void> signIn() async {
    _account = await _googleSignIn.signIn();
    if (_account == null) throw Exception('Inicio de sesión cancelado');
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _account = null;
  }

  /// Consulta correos bancarios de los últimos [daysBack] días.
  Future<List<BankEmail>> fetchBankEmails({int daysBack = 90}) async {
    if (_account == null) throw Exception('No hay sesión de Gmail activa');

    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) throw Exception('No se pudo obtener cliente OAuth2');

    final gmailApi = gmail.GmailApi(httpClient);

    // Filtro: remitentes conocidos, últimos N días
    final afterDate = DateTime.now().subtract(Duration(days: daysBack));
    final afterEpoch = afterDate.millisecondsSinceEpoch ~/ 1000;
    const senders =
        'from:(alertas@bncr.fi.cr OR notificaciones@baccredomatic.com OR '
        'alertas@davivienda.cr OR transacciones@scotiabank.com)';
    final query = '$senders after:$afterEpoch';

    final messages = await gmailApi.users.messages
        .list('me', q: query, maxResults: 100);

    if (messages.messages == null || messages.messages!.isEmpty) return [];

    final results = <BankEmail>[];

    for (final msg in messages.messages!) {
      try {
        final full = await gmailApi.users.messages.get('me', msg.id!,
            format: 'full');

        final headers = full.payload?.headers ?? [];
        final subject = _header(headers, 'Subject') ?? '(sin asunto)';
        final from = _header(headers, 'From') ?? '';
        final dateStr = _header(headers, 'Date') ?? '';
        final date = _parseDate(dateStr);
        final body = _extractBody(full.payload);

        BankEmail? email;
        if (BnEmailParser.canParse(from)) {
          email = BnEmailParser.parse(
            id: msg.id!,
            subject: subject,
            from: from,
            date: date,
            body: body,
          );
        } else if (BacEmailParser.canParse(from)) {
          email = BacEmailParser.parse(
            id: msg.id!,
            subject: subject,
            from: from,
            date: date,
            body: body,
          );
        } else {
          email = BankEmail(
            id: msg.id!,
            subject: subject,
            from: from,
            date: date,
            rawBody: body,
            isParsed: false,
          );
        }

        results.add(email);
      } catch (_) {
        // Ignorar correos que no se puedan parsear
        continue;
      }
    }

    return results;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  String? _header(List<gmail.MessagePartHeader> headers, String name) {
    try {
      return headers
          .firstWhere((h) => h.name?.toLowerCase() == name.toLowerCase())
          .value;
    } catch (_) {
      return null;
    }
  }

  DateTime _parseDate(String raw) {
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return DateTime.now();
    }
  }

  String _extractBody(gmail.MessagePart? part) {
    if (part == null) return '';

    // Texto plano preferido
    if (part.mimeType == 'text/plain' && part.body?.data != null) {
      return utf8.decode(base64Url.decode(part.body!.data!));
    }

    // Recursivo para multipart
    if (part.parts != null) {
      for (final p in part.parts!) {
        final text = _extractBody(p);
        if (text.isNotEmpty) return text;
      }
    }

    // Fallback: cualquier body con data
    if (part.body?.data != null) {
      return utf8.decode(base64Url.decode(part.body!.data!));
    }

    return '';
  }
}
