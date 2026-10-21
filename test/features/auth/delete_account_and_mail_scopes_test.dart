import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakeibo_pro/features/auth/domain/delete_account_confirmation.dart';
import 'package:kakeibo_pro/features/email/data/services/gmail_service.dart';
import 'package:kakeibo_pro/features/email/data/services/outlook_service.dart';

void main() {
  test('la segunda confirmación exige la palabra ELIMINAR', () {
    expect(deleteAccountPhraseMatches('ELIMINAR'), isTrue);
    expect(deleteAccountPhraseMatches('  ELIMINAR'), isTrue);
    expect(deleteAccountPhraseMatches('eliminar'), isFalse);
    expect(deleteAccountPhraseMatches('ELIMINA'), isFalse);
    expect(deleteAccountPhraseMatches(''), isFalse);
  });

  test('el inicio de sesión no pide permisos de correo', () {
    const paths = [
      'lib/main.dart',
      'lib/features/auth/presentation/pages/login_page.dart',
      'lib/features/auth/presentation/pages/register_page.dart',
      'lib/features/auth/data/datasources/supabase_auth_datasource.dart',
    ];
    for (final path in paths) {
      final source = File(path).readAsStringSync();
      expect(source.contains('gmail.readonly'), isFalse, reason: path);
      expect(source.contains('Mail.Read'), isFalse, reason: path);
      expect(source.contains('GoogleSignIn'), isFalse, reason: path);
      expect(source.contains('acquireToken'), isFalse, reason: path);
      expect(source.contains('Sentry'), isFalse, reason: path);
    }
  });

  test('gmail.readonly y Mail.Read solo están en la conexión de correo', () {
    expect(
      GmailService.mailReadScopes.single,
      'https://www.googleapis.com/auth/gmail.readonly',
    );
    expect(OutlookService.mailReadScopes, ['Mail.Read']);

    final gmail = File('lib/features/email/data/services/gmail_service.dart')
        .readAsStringSync();
    final outlook =
        File('lib/features/email/data/services/outlook_service.dart')
            .readAsStringSync();

    expect(gmail.contains('GoogleSignIn(scopes: mailReadScopes)'), isTrue);
    expect(gmail.contains('final _googleSignIn = GoogleSignIn'), isFalse);
    expect(outlook.contains('acquireToken(mailReadScopes)'), isTrue);
    expect(outlook.contains("acquireToken(['Mail.Read'])"), isFalse);
  });
}
