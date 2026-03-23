import 'package:drift/drift.dart';

class EnvelopesTable extends Table {
  @override
  String get tableName => 'envelopes';

  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get familyId => text().withLength(min: 36, max: 36)();
  TextColumn get name => text().withLength(max: 100)();
  TextColumn get category =>
      text().withLength(max: 20)(); // survival|culture|leisure|extras|allowance|investment
  RealColumn get budgetedAmount => real().withDefault(const Constant(0.0))();
  RealColumn get spentAmount => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withLength(max: 3).withDefault(const Constant('CRC'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get iconCode => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get localStatus =>
      text().withDefault(const Constant('active'))(); // active|pending_delete

  @override
  Set<Column> get primaryKey => {id};
}
