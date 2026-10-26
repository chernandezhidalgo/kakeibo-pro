import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';

/// Kakei no debe llamar a la API. El mensaje es para la UI y no incluye la clave.
class KakeiUnavailableException implements Exception {
  final String message;

  const KakeiUnavailableException(this.message);

  @override
  String toString() => message;
}

/// Resultado de categorización Kakeibo generado por Gemini.
class GeminiCategorizationResult {
  final KakeiboCategory category;
  final String categoryLabel;
  final double confidence;
  final String reasoning;

  const GeminiCategorizationResult({
    required this.category,
    required this.categoryLabel,
    required this.confidence,
    required this.reasoning,
  });
}

/// Cliente oficial de Google Generative AI para clasificar gastos
/// en las 4 categorías clásicas de Kakeibo.
class GeminiService {
  static const _apiKey =
      String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const _modelName = 'gemini-2.5-flash';

  static const unavailableMessage =
      'Kakei IA no está disponible en esta versión de prueba.';

  static const unauthorizedMessage =
      'Kakei IA no está disponible en esta versión de prueba.';

  static bool get hasApiKey => _apiKey.isNotEmpty;

  /// Mensaje de UI si no hay clave o si la API respondió 401/403.
  /// Devuelve null para el resto de códigos. Nunca incluye la clave.
  static String? friendlyChatError({required bool hasApiKey, int? statusCode}) {
    if (!hasApiKey) return unavailableMessage;
    if (statusCode == 401 || statusCode == 403) return unauthorizedMessage;
    return null;
  }

  static const _kakeiboCategories = {
    'supervivencia': KakeiboCategory.survival,
    'ocio': KakeiboCategory.leisure,
    'cultura': KakeiboCategory.culture,
    'extras': KakeiboCategory.extras,
  };

  static const _categoryLabels = {
    KakeiboCategory.survival: 'Supervivencia',
    KakeiboCategory.leisure: 'Ocio',
    KakeiboCategory.culture: 'Cultura',
    KakeiboCategory.extras: 'Extras',
  };

  GenerativeModel _createModel() {
    _checkApiKey();
    return GenerativeModel(
      model: _modelName,
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 256,
        responseMimeType: 'application/json',
      ),
      systemInstruction: Content.system(
        'Eres un asistente de finanzas personales experto en el método Kakeibo. '
        'Clasificas cada gasto en exactamente una de estas 4 categorías: '
        'Supervivencia (necesidades: vivienda, comida, transporte, salud, servicios), '
        'Ocio (placer y entretenimiento: restaurantes, cine, viajes, hobbies), '
        'Cultura (crecimiento: libros, cursos, educación, arte) y '
        'Extras (imprevistos, caprichos y gastos no esenciales). '
        'Responde únicamente con JSON válido.',
      ),
    );
  }

  void _checkApiKey() {
    if (_apiKey.isEmpty) {
      throw const KakeiUnavailableException(unavailableMessage);
    }
  }

  /// Conversación de Kakei. No llama a la red si la clave está vacía.
  Future<String> sendChat({
    required String systemPrompt,
    required List<({String role, String text})> turns,
  }) async {
    final blocked = friendlyChatError(hasApiKey: hasApiKey);
    if (blocked != null) {
      throw const KakeiUnavailableException(unavailableMessage);
    }

    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_modelName:generateContent',
      ),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': _apiKey,
      },
      body: jsonEncode({
        'systemInstruction': {
          'parts': [
            {'text': systemPrompt},
          ],
        },
        'contents': _contents(turns),
        'generationConfig': {'maxOutputTokens': 1024},
      }),
    );

    final friendly = friendlyChatError(
      hasApiKey: true,
      statusCode: response.statusCode,
    );
    if (friendly != null) {
      throw KakeiUnavailableException(friendly);
    }
    if (response.statusCode != 200) {
      throw Exception('API error ${response.statusCode}');
    }

    Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception('Respuesta inesperada de Kakei IA');
    }
    return _extractReply(decoded);
  }

  List<Map<String, Object>> _contents(List<({String role, String text})> turns) {
    final contents = <Map<String, Object>>[];
    for (final turn in turns) {
      final role = turn.role == 'model' ? 'model' : 'user';
      if (contents.isNotEmpty && contents.last['role'] == role) {
        final parts = contents.last['parts']! as List<Map<String, String>>;
        final previous = parts.first['text'] ?? '';
        parts[0] = {'text': '$previous\n${turn.text}'};
        continue;
      }
      final parts = <Map<String, String>>[
        {'text': turn.text},
      ];
      contents.add({
        'role': role,
        'parts': parts,
      });
    }
    return contents;
  }

  String _extractReply(Object? decoded) {
    if (decoded is! Map) {
      throw Exception('Respuesta inesperada de Kakei IA');
    }
    final candidates = decoded['candidates'];
    if (candidates is! List || candidates.isEmpty || candidates.first is! Map) {
      throw Exception('Kakei IA no devolvió una respuesta');
    }
    final content = (candidates.first as Map)['content'];
    if (content is! Map) {
      throw Exception('Kakei IA no devolvió una respuesta');
    }
    final parts = content['parts'];
    if (parts is! List) {
      throw Exception('Kakei IA no devolvió una respuesta');
    }
    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map && part['text'] is String) {
        buffer.write(part['text'] as String);
      }
    }
    final text = buffer.toString().trim();
    if (text.isEmpty) {
      throw Exception('Kakei IA no devolvió una respuesta');
    }
    return text;
  }

  /// Clasifica un gasto en una de las 4 categorías Kakeibo.
  Future<GeminiCategorizationResult> categorizeExpense({
    required String description,
    String? merchantName,
    double? amount,
    String currency = 'CRC',
  }) async {
    final model = _createModel();
    final prompt = '''
Analiza el siguiente gasto y asígnalo a una categoría Kakeibo.

Gasto:
- Descripción: $description
${merchantName != null && merchantName.isNotEmpty ? '- Comercio: $merchantName' : ''}
${amount != null ? '- Monto: $amount $currency' : ''}

Categorías válidas (usa exactamente una):
- Supervivencia
- Ocio
- Cultura
- Extras

Responde ÚNICAMENTE con un objeto JSON con este formato exacto:
{
  "category": "<Supervivencia|Ocio|Cultura|Extras>",
  "confidence": <número entre 0 y 1>,
  "reasoning": "<explicación breve en español>"
}
''';

    final response = await _generate(
      () => model.generateContent([Content.text(prompt)]),
    );
    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw Exception('Gemini no devolvió contenido para categorizar el gasto');
    }

    final json = _extractJson(text);
    final rawCategory = (json['category'] as String?)?.trim() ?? '';
    final category = _parseCategory(rawCategory);
    final confidence = (json['confidence'] as num?)?.toDouble() ?? 0.0;
    final reasoning = (json['reasoning'] as String?)?.trim() ?? '';

    return GeminiCategorizationResult(
      category: category,
      categoryLabel: _categoryLabels[category]!,
      confidence: confidence.clamp(0.0, 1.0),
      reasoning: reasoning.isEmpty
          ? 'Clasificado como ${_categoryLabels[category]}.'
          : reasoning,
    );
  }

  Future<T> _generate<T>(Future<T> Function() request) async {
    _checkApiKey();
    try {
      return await request();
    } on InvalidApiKey {
      throw const KakeiUnavailableException(unauthorizedMessage);
    } on GenerativeAIException catch (error) {
      final friendly = friendlyChatError(
        hasApiKey: true,
        statusCode: _statusCodeIn(error.message),
      );
      if (friendly != null) {
        throw KakeiUnavailableException(friendly);
      }
      rethrow;
    }
  }

  static int? _statusCodeIn(String message) {
    if (RegExp(r'(^|[^\d])401([^\d]|$)').hasMatch(message)) return 401;
    if (RegExp(r'(^|[^\d])403([^\d]|$)').hasMatch(message)) return 403;
    return null;
  }

  Map<String, dynamic> _extractJson(String text) {
    final jsonMatch = RegExp(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)?\}').firstMatch(text) ??
        RegExp(r'\{[\s\S]*?\}').firstMatch(text);
    if (jsonMatch == null) {
      throw Exception('Respuesta inesperada de Gemini: sin JSON');
    }
    final decoded = jsonDecode(jsonMatch.group(0)!);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('JSON de respuesta de Gemini no es un objeto');
    }
    return decoded;
  }

  KakeiboCategory _parseCategory(String raw) {
    final normalized = raw
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-záéíóúüñ]'), '');
    final category = _kakeiboCategories[normalized];
    if (category == null) {
      throw Exception('Categoría Kakeibo no reconocida: $raw');
    }
    return category;
  }
}
