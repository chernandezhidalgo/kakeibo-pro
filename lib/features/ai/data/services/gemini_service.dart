import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';

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
      throw Exception(
        'GEMINI_API_KEY no configurada. Defínela con --dart-define al compilar.',
      );
    }
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

    final response = await model.generateContent([Content.text(prompt)]);
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
