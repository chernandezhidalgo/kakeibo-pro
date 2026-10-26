import 'package:flutter_test/flutter_test.dart';
import 'package:kakeibo_pro/features/ai/data/services/gemini_service.dart';

void main() {
  const trialMessage =
      'Kakei IA no está disponible en esta versión de prueba.';

  test('sin clave no se llama a la API y el mensaje no revela la clave', () {
    final message = GeminiService.friendlyChatError(hasApiKey: false);

    expect(message, trialMessage);
    expect(message, isNot(contains('GEMINI')));
    expect(message, isNot(contains('API error')));
  });

  test('401 y 403 se muestran como un mensaje en español', () {
    for (final status in [401, 403]) {
      final message = GeminiService.friendlyChatError(
        hasApiKey: true,
        statusCode: status,
      );

      expect(message, GeminiService.unauthorizedMessage);
      expect(message, isNot(contains('$status')));
      expect(message, isNot(contains('API error')));
    }
  });

  test('otros códigos HTTP no se reescriben', () {
    expect(
      GeminiService.friendlyChatError(hasApiKey: true, statusCode: 500),
      isNull,
    );
    expect(GeminiService.friendlyChatError(hasApiKey: true), isNull);
  });
}
