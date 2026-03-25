import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kakeibo_pro/features/ocr/data/services/ocr_service.dart';
import 'package:kakeibo_pro/features/ocr/domain/models/ocr_result.dart';

// ── Servicio ───────────────────────────────────────────────────────────────────

final ocrServiceProvider = Provider<OcrService>((_) => OcrService());

// ── Estado sealed ──────────────────────────────────────────────────────────────

sealed class OcrState {
  const OcrState();
}

class OcrIdle extends OcrState {
  const OcrIdle();
}

class OcrLoading extends OcrState {
  final String message;
  const OcrLoading(this.message);
}

class OcrSuccess extends OcrState {
  final OcrResult result;
  const OcrSuccess(this.result);
}

class OcrError extends OcrState {
  final String message;
  const OcrError(this.message);
}

// ── Notifier ───────────────────────────────────────────────────────────────────

class OcrNotifier extends StateNotifier<OcrState> {
  final OcrService _service;

  OcrNotifier(this._service) : super(const OcrIdle());

  Future<void> processImage(String filePath) async {
    state = const OcrLoading('Reconociendo texto…');
    try {
      final result = await _service.recognizeFromFile(filePath);
      state = OcrSuccess(result);
    } catch (e) {
      state = OcrError('Error al procesar imagen: $e');
    }
  }

  void reset() => state = const OcrIdle();
}

// ── Provider ───────────────────────────────────────────────────────────────────

final ocrProvider =
    StateNotifierProvider.autoDispose<OcrNotifier, OcrState>(
  (ref) => OcrNotifier(ref.watch(ocrServiceProvider)),
);
