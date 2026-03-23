import 'package:drift/drift.dart';

class KakeiboReflectionsTable extends Table {
  @override
  String get tableName => 'kakeibo_reflections';

  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get familyId => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().withLength(min: 36, max: 36)();
  IntColumn get year => integer()();
  IntColumn get month => integer()(); // 1–12
  RealColumn get incomeTotal => real().withDefault(const Constant(0.0))();
  RealColumn get expenseTotal => real().withDefault(const Constant(0.0))();
  RealColumn get savingsTarget => real().withDefault(const Constant(0.0))();
  RealColumn get savingsActual => real().withDefault(const Constant(0.0))();
  TextColumn get questionHowMuch => text().nullable()(); // respuesta pregunta 1
  TextColumn get questionSave => text().nullable()();    // respuesta pregunta 2
  TextColumn get questionSpent => text().nullable()();   // respuesta pregunta 3
  TextColumn get questionImprove => text().nullable()(); // respuesta pregunta 4
  TextColumn get aiInsight => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
