import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'purchases_service.dart';

/// Expone el singleton [PurchasesService] al árbol de providers.
final purchasesServiceProvider = Provider<PurchasesService>((ref) {
  return PurchasesService();
});

/// True si el usuario tiene cualquier plan activo.
/// Se usa para proteger features de pago (IA, correos, OCR, CSV).
final hasPremiumProvider = FutureProvider<bool>((ref) async {
  return ref.watch(purchasesServiceProvider).hasAnyPlan;
});

/// True si el usuario tiene el plan familiar activo.
final hasFamiliarPlanProvider = FutureProvider<bool>((ref) async {
  return ref.watch(purchasesServiceProvider).hasFamiliarPlan;
});

/// Offerings disponibles para mostrar en el paywall.
/// Retorna una lista vacía si RevenueCat no está configurado aún.
final offeringsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.watch(purchasesServiceProvider).getOfferings();
});
