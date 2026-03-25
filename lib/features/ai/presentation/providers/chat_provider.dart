import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

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
  static const _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const _apiKey =
      String.fromEnvironment('ANTHROPIC_API_KEY', defaultValue: '');
  static const _systemPrompt =
      'Eres Kakei, un asistente de finanzas personales que usa el método '
      'Kakeibo japonés. Ayudas a los usuarios a entender sus gastos, ahorrar '
      'más dinero y desarrollar hábitos financieros saludables. Responde '
      'siempre en español, de forma amigable, clara y práctica. '
      'Cuando des consejos, basa tus sugerencias en los principios Kakeibo: '
      'consciencia, reflexión y metas de ahorro claras.';

  final _uuid = const Uuid();

  ChatNotifier() : super(const ChatState());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

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
      final history = state.messages.map((m) => m.toApiMap()).toList();

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-6',
          'max_tokens': 1024,
          'system': _systemPrompt,
          'messages': history,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('API error ${response.statusCode}');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final content = (body['content'] as List).first['text'] as String;

      final assistantMsg = ChatMessage(
        id: _uuid.v4(),
        role: ChatRole.assistant,
        content: content,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo enviar el mensaje: $e',
      );
    }
  }

  void clearHistory() => state = const ChatState();
}

// ── Provider ──────────────────────────────────────────────────────────────────

final chatProvider =
    StateNotifierProvider.autoDispose<ChatNotifier, ChatState>(
  (_) => ChatNotifier(),
);
