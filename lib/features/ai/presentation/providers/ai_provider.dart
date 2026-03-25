import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kakeibo_pro/features/ai/data/services/claude_service_impl.dart';
import 'package:kakeibo_pro/features/ai/domain/models/ai_categorization_request.dart';
import 'package:kakeibo_pro/features/ai/domain/models/ai_categorization_response.dart';

// ── Servicio ───────────────────────────────────────────────────────────────────

final claudeServiceProvider = Provider<ClaudeServiceImpl>(
  (_) => ClaudeServiceImpl(),
);

// ── Estado (sealed class) ──────────────────────────────────────────────────────

sealed class CategorizationState {
  const CategorizationState();
}

class CategorizationIdle extends CategorizationState {
  const CategorizationIdle();
}

class CategorizationLoading extends CategorizationState {
  const CategorizationLoading();
}

class CategorizationSuccess extends CategorizationState {
  final AiCategorizationResponse result;
  const CategorizationSuccess(this.result);
}

class CategorizationError extends CategorizationState {
  final String message;
  const CategorizationError(this.message);
}

// ── Notifier ───────────────────────────────────────────────────────────────────

class CategorizationNotifier extends StateNotifier<CategorizationState> {
  final ClaudeServiceImpl _service;

  CategorizationNotifier(this._service) : super(const CategorizationIdle());

  Future<void> categorize(AiCategorizationRequest request) async {
    state = const CategorizationLoading();
    try {
      final result = await _service.categorize(request);
      state = CategorizationSuccess(result);
    } catch (e) {
      state = CategorizationError('No se pudo sugerir el sobre: $e');
    }
  }

  void reset() => state = const CategorizationIdle();
}

// ── Provider ───────────────────────────────────────────────────────────────────

/// Keyed by un identificador de formulario (ej: uuid de la transacción en curso).
final categorizationProvider = StateNotifierProvider.autoDispose
    .family<CategorizationNotifier, CategorizationState, String>(
  (ref, envelopeKey) =>
      CategorizationNotifier(ref.watch(claudeServiceProvider)),
);
