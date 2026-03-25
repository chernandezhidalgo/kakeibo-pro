import 'dart:convert';
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;

import 'package:kakeibo_pro/features/ai/domain/models/ai_categorization_request.dart';
import 'package:kakeibo_pro/features/ai/domain/models/ai_categorization_response.dart';
import 'package:kakeibo_pro/features/ocr/domain/models/ocr_result.dart';

class OcrService {
  final _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  static const _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const _apiKey =
      String.fromEnvironment('ANTHROPIC_API_KEY', defaultValue: '');

  /// Extrae texto de una imagen usando ML Kit (on-device, gratis).
  Future<OcrResult> recognizeFromFile(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final recognized = await _recognizer.processImage(inputImage);
    final rawText = recognized.text;

    if (rawText.trim().isEmpty) {
      return const OcrResult(rawText: '', isProcessed: false);
    }

    return _parseText(rawText);
  }

  /// Extrae datos usando Claude Vision (para recibos complejos).
  Future<AiCategorizationResponse> recognizeWithClaude({
    required String filePath,
    required List<EnvelopeOption> availableEnvelopes,
  }) async {
    final bytes = await File(filePath).readAsBytes();
    final base64Image = base64Encode(bytes);
    final ext = filePath.split('.').last.toLowerCase();
    final mediaType = ext == 'png' ? 'image/png' : 'image/jpeg';

    final envelopeList = availableEnvelopes
        .map((e) => '- id: ${e.id} | nombre: ${e.name} | categoría: ${e.category}')
        .join('\n');

    final prompt = '''
Analiza este recibo y extrae:
1. Monto total pagado
2. Nombre del comercio
3. Descripción general del gasto

Luego determina en qué sobre (categoría) encaja mejor.

Sobres disponibles:
$envelopeList

Responde ÚNICAMENTE con JSON:
{
  "envelope_id": "<id>",
  "envelope_name": "<nombre>",
  "confidence": <0-1>,
  "reasoning": "<explicación breve>",
  "extracted_amount": <monto o null>,
  "extracted_merchant": "<comercio o null>",
  "extracted_description": "<descripción breve>"
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
        'model': 'claude-sonnet-4-6',
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
      throw Exception('Claude Vision error ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final text = (body['content'] as List).first['text'] as String;
    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (jsonMatch == null) throw Exception('Respuesta inesperada');
    final json = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;

    return AiCategorizationResponse.fromJson(json);
  }

  void dispose() => _recognizer.close();

  // ── Parsing básico del texto OCR ─────────────────────────────────────────────

  OcrResult _parseText(String raw) {
    double? amount;
    String? merchant;
    String? description;

    // Monto: busca patrones como "₡ 12,345" / "TOTAL 5000" / "Total: 1.200,00"
    final amountMatch = RegExp(
      r'(?:[Tt]otal|TOTAL|Monto|MONTO|Amount)[:\s]*(?:₡|CRC|USD|\$)?\s*([\d,\.]+)',
    ).firstMatch(raw);
    if (amountMatch != null) {
      final raw2 =
          amountMatch.group(1)!.replaceAll(',', '').replaceAll('.', '');
      amount = double.tryParse(raw2);
    }

    // Primer línea no vacía como probable nombre de comercio
    final lines = raw.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.isNotEmpty) {
      merchant = lines.first.trim();
      if (lines.length > 1) description = lines.elementAt(1).trim();
    }

    return OcrResult(
      rawText: raw,
      amount: amount,
      merchant: merchant,
      description: description ?? 'Recibo escaneado',
      isProcessed: amount != null,
    );
  }
}
