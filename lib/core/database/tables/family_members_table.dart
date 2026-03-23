import 'package:drift/drift.dart';

class FamilyMembersTable extends Table {
  @override
  String get tableName => 'family_members';

  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get familyId => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().withLength(min: 36, max: 36)();
  TextColumn get role =>
      text().withLength(max: 20)(); // admin|co_admin|teen|child|viewer
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get joinedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
