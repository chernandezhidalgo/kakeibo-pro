import 'package:drift/drift.dart';

/// Tabla de metas de ahorro.
/// Se agrega en schemaVersion 2 mediante migración addTable.
class SavingsGoalsTable extends Table {
  @override
  String get tableName => 'savings_goals';

  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get name => text()();
  TextColumn get emoji => text().withDefault(const Constant('🎯'))();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get deadline => dateTime().nullable()();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
