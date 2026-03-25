/// Entidad de dominio para una meta de ahorro.
class SavingsGoal {
  final String id;
  final String familyId;
  final String name;
  final String emoji;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final bool isCompleted;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavingsGoal({
    required this.id,
    required this.familyId,
    required this.name,
    required this.emoji,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.isCompleted,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Porcentaje de progreso (0–100).
  double get progressPercent =>
      targetAmount > 0 ? (currentAmount / targetAmount * 100).clamp(0, 100) : 0;

  /// Monto restante para alcanzar la meta.
  double get remaining => (targetAmount - currentAmount).clamp(0, double.infinity);

  /// Indica si la meta tiene fecha límite y ya venció.
  bool get isExpired =>
      deadline != null && !isCompleted && DateTime.now().isAfter(deadline!);

  SavingsGoal copyWith({
    String? id,
    String? familyId,
    String? name,
    String? emoji,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    bool? isCompleted,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
