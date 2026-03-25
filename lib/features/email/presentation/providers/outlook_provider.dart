import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kakeibo_pro/features/email/data/services/outlook_service.dart';
import 'package:kakeibo_pro/features/email/domain/models/bank_email.dart';

// ── Servicio singleton ─────────────────────────────────────────────────────────

final outlookServiceProvider =
    Provider<OutlookService>((_) => OutlookService());

// ── Estado ────────────────────────────────────────────────────────────────────

class OutlookState {
  final bool isSignedIn;
  final String? userEmail;
  final bool isLoading;
  final List<BankEmail> emails;
  final String? errorMessage;

  const OutlookState({
    this.isSignedIn = false,
    this.userEmail,
    this.isLoading = false,
    this.emails = const [],
    this.errorMessage,
  });

  OutlookState copyWith({
    bool? isSignedIn,
    String? userEmail,
    bool? isLoading,
    List<BankEmail>? emails,
    String? errorMessage,
    bool clearError = false,
  }) =>
      OutlookState(
        isSignedIn: isSignedIn ?? this.isSignedIn,
        userEmail: userEmail ?? this.userEmail,
        isLoading: isLoading ?? this.isLoading,
        emails: emails ?? this.emails,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class OutlookNotifier extends StateNotifier<OutlookState> {
  final OutlookService _service;

  OutlookNotifier(this._service) : super(const OutlookState());

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _service.signIn();
      state = state.copyWith(
        isLoading: false,
        isSignedIn: true,
        userEmail: _service.userEmail,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo conectar con Outlook: $e',
      );
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    state = const OutlookState();
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

final outlookProvider =
    StateNotifierProvider.autoDispose<OutlookNotifier, OutlookState>(
  (ref) => OutlookNotifier(ref.watch(outlookServiceProvider)),
);
