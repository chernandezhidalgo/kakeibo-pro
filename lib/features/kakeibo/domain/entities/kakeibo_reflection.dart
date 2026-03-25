/// Entidad de dominio para una reflexión mensual Kakeibo.
class KakeiboReflection {
  final String id;
  final String familyId;
  final int year;
  final int month;
  final double incomeTotal;
  final double expenseTotal;
  final double savingsTarget;
  final double savingsActual;

  // Respuestas de texto libre a las 4 preguntas Kakeibo
  final String? q1Income;      // ¿Cuánto tenés disponible?
  final String? q2Spending;    // ¿Cuánto querés gastar?
  final String? q3Savings;     // ¿Cuánto querés ahorrar?
  final String? q4Improvement; // ¿Cómo podés mejorar?
  final String? aiInsight;     // insight de IA (Fase 3)

  final DateTime createdAt;

  const KakeiboReflection({
    required this.id,
    required this.familyId,
    required this.year,
    required this.month,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.savingsTarget,
    required this.savingsActual,
    this.q1Income,
    this.q2Spending,
    this.q3Savings,
    this.q4Improvement,
    this.aiInsight,
    required this.createdAt,
  });

  /// Ahorro real del mes = ingresos - gastos.
  double get actualSavings => incomeTotal - expenseTotal;

  /// true si se cumplió la meta de ahorro.
  bool get metSavingsGoal => actualSavings >= savingsTarget && savingsTarget > 0;
}
