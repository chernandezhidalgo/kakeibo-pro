import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  // ID autoincremental — el orden importa para replay
  IntColumn get id => integer().autoIncrement()();

  TextColumn get operationType =>
      text().withLength(max: 10)(); // INSERT|UPDATE|DELETE
  TextColumn get tableName_ =>
      text().named('table_name').withLength(max: 50)();
  TextColumn get recordId => text().withLength(min: 36, max: 36)();
  TextColumn get payload => text()(); // JSON del registro completo
  TextColumn get status =>
      text().withDefault(const Constant('pending'))(); // pending|processing|failed|done
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get processedAt => dateTime().nullable()();
}
