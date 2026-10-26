import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:kakeibo_pro/features/ai/data/services/gemini_service.dart';
import 'package:kakeibo_pro/features/ai/domain/models/chat_message.dart';

// ── Estado ────────────────────────────────────────────────────────────────────

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<ChatState> {
  static const _systemPrompt =
      'Eres Kakei, un asistente de finanzas personales que usa el método '
      'Kakeibo japonés. Ayudas a los usuarios a entender sus gastos, ahorrar '
      'más dinero y desarrollar hábitos financieros saludables. Responde '
      'siempre en español, de forma amigable, clara y práctica. '
      'Cuando des consejos, basa tus sugerencias en los principios Kakeibo: '
      'consciencia, reflexión y metas de ahorro claras.';

  final _uuid = const Uuid();
  final GeminiService _gemini;

  ChatNotifier({GeminiService? gemini})
      : _gemini = gemini ?? GeminiService(),
        super(
          GeminiService.hasApiKey
              ? const ChatState()
              : const ChatState(
                  errorMessage: GeminiService.unavailableMessage,
                ),
        );

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    if (!GeminiService.hasApiKey) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: GeminiService.unavailableMessage,
      );
      return;
    }

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.user,
      content: text.trim(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      clearError: true,
    );

    try {
      final reply = await _gemini.sendChat(
        systemPrompt: _systemPrompt,
        turns: [
          for (final message in state.messages)
            (
              role: message.role == ChatRole.user ? 'user' : 'model',
              text: message.content,
            ),
        ],
      );

      final assistantMsg = ChatMessage(
        id: _uuid.v4(),
        role: ChatRole.assistant,
        content: reply,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        isLoading: false,
      );
    } on KakeiUnavailableException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo enviar el mensaje: $e',
      );
    }
  }

  void clearHistory() {
    state = GeminiService.hasApiKey
        ? const ChatState()
        : const ChatState(errorMessage: GeminiService.unavailableMessage);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final chatProvider =
    StateNotifierProvider.autoDispose<ChatNotifier, ChatState>(
  (_) => ChatNotifier(),
);
