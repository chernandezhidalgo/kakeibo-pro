import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_profiles_table.dart';

part 'user_profiles_dao.g.dart';

@DriftAccessor(tables: [UserProfilesTable])
class UserProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfilesDaoMixin {
  UserProfilesDao(super.db);

  Future<UserProfilesTableData?> getById(String id) {
    return (select(userProfilesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertProfile(UserProfilesTableCompanion profile) {
    return into(userProfilesTable).insertOnConflictUpdate(profile);
  }

  Future<void> markSynced(String id) {
    return (update(userProfilesTable)..where((t) => t.id.equals(id)))
        .write(const UserProfilesTableCompanion(isSynced: Value(true)));
  }
}
