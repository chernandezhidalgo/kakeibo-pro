import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/savings_goals_table.dart';

part 'savings_goals_dao.g.dart';

@DriftAccessor(tables: [SavingsGoalsTable])
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsGoalsDaoMixin {
  SavingsGoalsDao(super.db);

  /// Stream reactivo de metas ordenadas por fecha de creación.
  Stream<List<SavingsGoalsTableData>> watchGoals(String familyId) {
    return (select(savingsGoalsTable)
          ..where((t) => t.familyId.equals(familyId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// Inserta o actualiza una meta (upsert por id).
  Future<void> upsertGoal(SavingsGoalsTableCompanion goal) {
    return into(savingsGoalsTable).insertOnConflictUpdate(goal);
  }

  /// Elimina una meta por id.
  Future<void> deleteGoal(String id) {
    return (delete(savingsGoalsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Suma [amount] al currentAmount de una meta, sin superar targetAmount.
  Future<void> addToGoal(String id, double amount) async {
    final goal = await (select(savingsGoalsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (goal == null) return;

    final newAmount =
        (goal.currentAmount + amount).clamp(0.0, goal.targetAmount);
    await (update(savingsGoalsTable)..where((t) => t.id.equals(id))).write(
      SavingsGoalsTableCompanion(
        currentAmount: Value(newAmount),
        isCompleted: Value(newAmount >= goal.targetAmount),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
