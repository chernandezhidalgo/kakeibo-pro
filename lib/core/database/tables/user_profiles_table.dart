import 'package:drift/drift.dart';

class UserProfilesTable extends Table {
  @override
  String get tableName => 'user_profiles';

  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get email => text().withLength(max: 255)();
  TextColumn get displayName => text().withLength(max: 100)();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role =>
      text().withLength(max: 20).withDefault(const Constant('viewer'))();
  TextColumn get preferredCurrency =>
      text().withLength(max: 3).withDefault(const Constant('CRC'))();
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
