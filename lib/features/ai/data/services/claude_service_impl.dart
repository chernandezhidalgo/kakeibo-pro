import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kakeibo_pro/features/ai/domain/models/ai_categorization_request.dart';
import 'package:kakeibo_pro/features/ai/domain/models/ai_categorization_response.dart';

class ClaudeServiceImpl {
  static const _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const _apiKey =
      String.fromEnvironment('ANTHROPIC_API_KEY', defaultValue: '');
  static const _model = 'claude-sonnet-4-6';

  /// Extrae el texto de la primera respuesta del modelo de forma segura.
  String _extractText(Map<String, dynamic> body) {
    final content = body['content'];
    if (content is! List || content.isEmpty) {
      throw Exception('Respuesta de Claude sin contenido');
    }
    final first = content.first;
    if (first is! Map || first['text'] is! String) {
      throw Exception('Formato de respuesta de Claude inesperado');
    }
    return first['text'] as String;
  }

  /// Extrae el primer objeto JSON completo del texto de forma no-greedy.
  Map<String, dynamic> _extractJson(String text) {
    final jsonMatch = RegExp(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)?\}').firstMatch(text)
        ?? RegExp(r'\{[\s\S]*?\}').firstMatch(text);
    if (jsonMatch == null) throw Exception('Respuesta inesperada de Claude: sin JSON');
    final decoded = jsonDecode(jsonMatch.group(0)!);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('JSON de respuesta no es un objeto');
    }
    return decoded;
  }

  void _checkApiKey() {
    if (_apiKey.isEmpty) {
      throw Exception('ANTHROPIC_API_KEY no configurada. Define la variable de entorno al compilar.');
    }
  }

  Future<AiCategorizationResponse> categorize(
      AiCategorizationRequest request) async {
    _checkApiKey();
    final envelopeList = request.availableEnvelopes
        .map((e) =>
            '- id: ${e.id} | nombre: ${e.name} | categoría: ${e.category} | emoji: ${e.emoji}')
        .join('\n');

    final prompt = '''
Eres un asistente de finanzas personales. Analiza la siguiente transacción y determina en qué sobre (categoría de gasto) encaja mejor.

Transacción:
- Descripción: ${request.description}
${request.merchantName != null ? '- Comercio: ${request.merchantName}' : ''}
- Monto: ${request.amount} ${request.currency}

Sobres disponibles:
$envelopeList

Responde ÚNICAMENTE con un objeto JSON con este formato exacto:
{
  "envelope_id": "<id del sobre seleccionado>",
  "envelope_name": "<nombre del sobre>",
  "confidence": <número entre 0 y 1>,
  "reasoning": "<explicación breve en español>"
}
''';

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 256,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = _extractText(body);
    final json = _extractJson(text);
    return AiCategorizationResponse.fromJson(json);
  }

  Future<AiReflectionInsight> generateReflectionInsight({
    required double incomeTotal,
    required double expenseTotal,
    required double savingsTarget,
    required double savingsActual,
    required String q1,
    required String q2,
    required String q3,
    required String q4,
    required Map<String, double> spentByCategory,
  }) async {
    _checkApiKey();
    final categoryLines = spentByCategory.entries
        .map((e) => '- ${e.key}: ${e.value.toStringAsFixed(2)}')
        .join('\n');

    final prompt = '''
Eres un coach de finanzas personales usando el método Kakeibo. Analiza la reflexión mensual del usuario y genera un insight motivacional.

Resumen del mes:
- Ingresos: $incomeTotal
- Gastos: $expenseTotal
- Meta de ahorro: $savingsTarget
- Ahorro real: $savingsActual

Gastos por categoría:
${categoryLines.isEmpty ? '(sin datos)' : categoryLines}

Reflexión del usuario:
1. ¿Cuánto dinero tengo? $q1
2. ¿Cuánto quiero ahorrar? $q2
3. ¿En qué gasté dinero? $q3
4. ¿Cómo puedo mejorar? $q4

Responde ÚNICAMENTE con un objeto JSON con este formato exacto:
{
  "summary": "<resumen del mes en 2 oraciones>",
  "suggestions": ["<sugerencia 1>", "<sugerencia 2>", "<sugerencia 3>"],
  "motivational_message": "<mensaje motivacional breve>"
}
''';

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 512,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = _extractText(body);
    final json = _extractJson(text);
    return AiReflectionInsight.fromJson(json);
  }

  Future<AiCategorizationResponse> categorizeFromImage({
    required String base64Image,
    required String mediaType,
    required List<EnvelopeOption> availableEnvelopes,
  }) async {
    _checkApiKey();
    final envelopeList = availableEnvelopes
        .map((e) =>
            '- id: ${e.id} | nombre: ${e.name} | categoría: ${e.category}')
        .join('\n');

    final prompt = '''
Analiza este recibo/comprobante de pago y determina en qué sobre (categoría) encaja mejor.

Sobres disponibles:
$envelopeList

Extrae también: descripción del gasto, monto total y comercio si es visible.

Responde ÚNICAMENTE con un objeto JSON:
{
  "envelope_id": "<id>",
  "envelope_name": "<nombre>",
  "confidence": <0-1>,
  "reasoning": "<explicación breve>",
  "extracted_description": "<descripción del recibo>",
  "extracted_amount": <monto o null>,
  "extracted_merchant": "<comercio o null>"
}
''';

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 512,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': mediaType,
                  'data': base64Image,
                },
              },
              {'type': 'text', 'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Claude API error ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = _extractText(body);
    final json = _extractJson(text);
    return AiCategorizationResponse.fromJson(json);
  }
}
