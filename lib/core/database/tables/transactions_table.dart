import 'package:drift/drift.dart';

class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get familyId => text().withLength(min: 36, max: 36)();
  TextColumn get envelopeId => text().nullable()();
  TextColumn get createdByUserId => text().withLength(min: 36, max: 36)();
  TextColumn get type =>
      text().withLength(max: 20)(); // expense|income|transfer
  RealColumn get amount => real()();
  TextColumn get currency =>
      text().withLength(max: 3).withDefault(const Constant('CRC'))();
  TextColumn get description => text().withLength(max: 500)();
  TextColumn get merchant => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get sourceType =>
      text().withLength(max: 20).nullable()(); // manual|csv|email|ocr
  TextColumn get rawSourceData => text().nullable()();
  BoolColumn get isRecurring =>
      boolean().withDefault(const Constant(false))();
  TextColumn get tags => text().nullable()(); // JSON array como string
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();
  TextColumn get localStatus =>
      text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}
