import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:purchases_flutter/purchases_flutter.dart';

/// Identificadores de entitlements en RevenueCat.
/// Deben coincidir exactamente con los creados en app.revenuecat.com.
class Entitlements {
  static const familiar = 'premium_familiar';
  static const individual = 'premium_individual';
}

/// Servicio centralizado de RevenueCat para KakeiboPro.
///
/// Gestiona el ciclo de vida de suscripciones in-app usando el SDK oficial
/// de RevenueCat para Flutter.
///
/// RevenueCat no soporta web — todas las operaciones están protegidas con [kIsWeb].
///
/// PASOS MANUALES antes de descomentar las llamadas a la API:
///  1. Crear cuenta en https://app.revenuecat.com
///  2. Crear productos en Google Play Console y asignarlos en RevenueCat
///  3. Copiar la Public SDK Key de Android y agregarla al .env:
///     REVENUECAT_API_KEY=goog_XXXXXXXXXXXXXXXXXXXX
class PurchasesService {
  static final PurchasesService _instance = PurchasesService._();
  factory PurchasesService() => _instance;
  PurchasesService._();

  bool _configured = false;

  /// Inicializar RevenueCat con la SDK key de Android.
  ///
  /// Llamar desde main() antes de runApp(), pasando el userId de Supabase.
  /// Si [userId] está vacío, RevenueCat usará un ID anónimo propio.
  Future<void> configure(String apiKey, String userId) async {
    if (kIsWeb || _configured || apiKey.isEmpty || apiKey == 'TU_REVENUECAT_API_KEY') return;
    final configuration = PurchasesConfiguration(apiKey)
      ..appUserID = userId.isNotEmpty ? userId : null;
    await Purchases.configure(configuration);
    _configured = true;
  }

  /// Verifica si el usuario tiene el entitlement indicado activo.
  Future<bool> hasEntitlement(String entitlementId) async {
    if (kIsWeb || !_configured) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }

  /// True si el usuario tiene el plan familiar activo.
  Future<bool> get hasFamiliarPlan => hasEntitlement(Entitlements.familiar);

  /// True si el usuario tiene cualquier plan activo (familiar o individual).
  Future<bool> get hasAnyPlan async {
    final familiar = await hasFamiliarPlan;
    if (familiar) return true;
    return hasEntitlement(Entitlements.individual);
  }

  /// Obtener los offerings disponibles para mostrar en el paywall.
  ///
  /// Retorna una lista de mapas con `identifier`, `productId`, `title`, `price`.
  Future<List<Map<String, dynamic>>> getOfferings() async {
    if (kIsWeb || !_configured) return [];
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return [];
      return current.availablePackages
          .map((p) => {
                'identifier': p.identifier,
                'productId': p.storeProduct.identifier,
                'title': p.storeProduct.title,
                'price': p.storeProduct.priceString,
              })
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Iniciar compra de un paquete por su identifier.
  ///
  /// Retorna true si la compra fue exitosa, false en caso de error o cancelación.
  Future<bool> purchase(String packageIdentifier) async {
    if (kIsWeb || !_configured) return false;
    try {
      final offerings = await Purchases.getOfferings();
      final pkg = offerings.current?.availablePackages
          .where((p) => p.identifier == packageIdentifier)
          .firstOrNull;
      if (pkg == null) return false;
      await Purchases.purchasePackage(pkg);
      return true;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    } catch (_) {
      return false;
    }
  }

  /// Restaurar compras anteriores.
  ///
  /// Retorna true si se encontró al menos un entitlement activo tras restaurar.
  Future<bool> restorePurchases() async {
    if (kIsWeb || !_configured) return false;
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
