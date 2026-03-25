import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kakeibo_pro/features/email/data/services/gmail_service.dart';
import 'package:kakeibo_pro/features/email/domain/models/bank_email.dart';

// ── Servicio singleton ─────────────────────────────────────────────────────────

final gmailServiceProvider = Provider<GmailService>((_) => GmailService());

// ── Estado ────────────────────────────────────────────────────────────────────

class GmailState {
  final bool isSignedIn;
  final String? userEmail;
  final bool isLoading;
  final List<BankEmail> emails;
  final String? errorMessage;

  const GmailState({
    this.isSignedIn = false,
    this.userEmail,
    this.isLoading = false,
    this.emails = const [],
    this.errorMessage,
  });

  GmailState copyWith({
    bool? isSignedIn,
    String? userEmail,
    bool? isLoading,
    List<BankEmail>? emails,
    String? errorMessage,
    bool clearError = false,
  }) =>
      GmailState(
        isSignedIn: isSignedIn ?? this.isSignedIn,
        userEmail: userEmail ?? this.userEmail,
        isLoading: isLoading ?? this.isLoading,
        emails: emails ?? this.emails,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class GmailNotifier extends StateNotifier<GmailState> {
  final GmailService _service;

  GmailNotifier(this._service) : super(const GmailState());

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _service.signIn();
      state = state.copyWith(
        isLoading: false,
        isSignedIn: true,
        userEmail: _service.userEmail,
      );
      await fetchEmails();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo conectar con Gmail: $e',
      );
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    state = const GmailState();
  }

  Future<void> fetchEmails() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final emails = await _service.fetchBankEmails(daysBack: 90);
      state = state.copyWith(isLoading: false, emails: emails);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al obtener correos: $e',
      );
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final gmailProvider =
    StateNotifierProvider.autoDispose<GmailNotifier, GmailState>(
  (ref) => GmailNotifier(ref.watch(gmailServiceProvider)),
);
