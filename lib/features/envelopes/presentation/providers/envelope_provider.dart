import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/database/database_provider.dart';
import 'package:kakeibo_pro/core/notifications/notification_service.dart';
import 'package:kakeibo_pro/core/sync/sync_repository.dart';
import 'package:kakeibo_pro/features/envelopes/data/repositories/envelope_repository_impl.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';
import 'package:kakeibo_pro/features/envelopes/domain/repositories/envelope_repository.dart';

/// Instancia del repositorio. La UI nunca instancia implementaciones directamente.
final envelopeRepositoryProvider = Provider<EnvelopeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return EnvelopeRepositoryImpl(
    db: db,
    sync: SyncRepository(db),
  );
});

/// Stream de sobres activos de una familia, en tiempo real.
///
/// Uso: `ref.watch(envelopesProvider(familyId))`
final envelopesProvider =
    StreamProvider.family<List<Envelope>, String>((ref, familyId) {
  return ref.watch(envelopeRepositoryProvider).watchEnvelopes(familyId);
});

/// Sobres agrupados por categoría Kakeibo.
///
/// Uso: `ref.watch(envelopesByCategoryProvider(familyId))`
final envelopesByCategoryProvider =
    Provider.family<Map<KakeiboCategory, List<Envelope>>, String>(
        (ref, familyId) {
  final asyncEnvelopes = ref.watch(envelopesProvider(familyId));
  return asyncEnvelopes.when(
    data: (envelopes) {
      final map = <KakeiboCategory, List<Envelope>>{};
      for (final e in envelopes) {
        map.putIfAbsent(e.kakeiboCategory, () => []).add(e);
      }
      return map;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

/// Presupuesto total y gasto total de la familia en el mes.
///
/// Uso: `ref.watch(envelopeSummaryProvider(familyId))`
final envelopeSummaryProvider = Provider.family<
    ({double totalBudget, double totalSpent}), String>((ref, familyId) {
  final asyncEnvelopes = ref.watch(envelopesProvider(familyId));
  return asyncEnvelopes.when(
    data: (envelopes) {
      final totalBudget =
          envelopes.fold(0.0, (sum, e) => sum + e.monthlyBudget);
      final totalSpent =
          envelopes.fold(0.0, (sum, e) => sum + e.currentSpent);
      return (totalBudget: totalBudget, totalSpent: totalSpent);
    },
    loading: () => (totalBudget: 0.0, totalSpent: 0.0),
    error: (_, __) => (totalBudget: 0.0, totalSpent: 0.0),
  );
});

/// Observa los sobres de una familia y dispara notificaciones locales
/// cuando alguno supera el 100% de su presupuesto mensual.
///
/// Este provider no devuelve ningún valor útil — su efecto es el side-effect
/// de enviar la notificación. Activarlo con `ref.watch(budgetAlertProvider(familyId))`.
final budgetAlertProvider =
    Provider.autoDispose.family<void, String>((ref, familyId) {
  final asyncEnvelopes = ref.watch(envelopesProvider(familyId));
  asyncEnvelopes.whenData((envelopes) {
    for (final envelope in envelopes) {
      if (envelope.isOverBudget) {
        final pct = envelope.spentPercentage.toStringAsFixed(0);
        NotificationService.instance.showLocalNotification(
          id: envelope.id.hashCode,
          title: '${envelope.iconEmoji} ${envelope.name} excedido',
          body: 'Llevas $pct% de tu presupuesto mensual en este sobre.',
        );
      }
    }
  });
});
