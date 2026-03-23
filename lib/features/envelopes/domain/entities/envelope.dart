import 'package:freezed_annotation/freezed_annotation.dart';

part 'envelope.freezed.dart';

/// Categorías Kakeibo que agrupan los sobres de KakeiboPro.
enum KakeiboCategory {
  survival,
  culture,
  leisure,
  extras,
  investment,
  allowance,
}

/// Entidad de dominio que representa un sobre de presupuesto.
///
/// Inmutable gracias a [freezed]. Los cálculos derivados están disponibles
/// a través de [EnvelopeGetters].
@freezed
class Envelope with _$Envelope {
  const factory Envelope({
    required String id,
    required String familyId,
    required String name,
    String? description,
    required KakeiboCategory kakeiboCategory,
    required double monthlyBudget,
    required double currentSpent,
    @Default('#5b9cf6') String colorHex,
    @Default('💰') String iconEmoji,
    required int sortOrder,
    required bool isActive,
    required bool isEditable,
  }) = _Envelope;
}

/// Getters calculados sobre [Envelope].
///
/// Se implementan como extensión porque [freezed] no permite métodos
/// personalizados dentro de la clase congelada.
extension EnvelopeGetters on Envelope {
  /// Presupuesto que queda disponible en el mes.
  double get remainingBudget => monthlyBudget - currentSpent;

  /// Porcentaje del presupuesto mensual que ya se ha gastado (0–100+).
  double get spentPercentage =>
      monthlyBudget > 0 ? (currentSpent / monthlyBudget * 100) : 0;

  /// Indica si el gasto supera el presupuesto mensual.
  bool get isOverBudget => currentSpent > monthlyBudget;
}
