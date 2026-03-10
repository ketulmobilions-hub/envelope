import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users, NotificationPreferences])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.attachedDatabase);

  // Users CRUD
  Future<List<User>> getAllUsers() => select(users).get();

  Stream<List<User>> watchAllUsers() => select(users).watch();

  Stream<User> watchUser(String id) =>
      (select(users)..where((t) => t.id.equals(id))).watchSingle();

  Future<User?> getUser(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);

  Future<int> deleteUser(String id) =>
      (delete(users)..where((t) => t.id.equals(id))).go();

  // Notification preferences
  Future<NotificationPreference?> getNotificationPreferences(
    String userId,
  ) =>
      (select(notificationPreferences)
            ..where((t) => t.userId.equals(userId)))
          .getSingleOrNull();

  Stream<NotificationPreference?> watchNotificationPreferences(
    String userId,
  ) =>
      (select(notificationPreferences)
            ..where((t) => t.userId.equals(userId)))
          .watchSingleOrNull();

  Future<int> upsertNotificationPreferences(
    NotificationPreferencesCompanion prefs,
  ) =>
      into(notificationPreferences).insertOnConflictUpdate(prefs);

  Future<int> deleteNotificationPreferences(String userId) =>
      (delete(notificationPreferences)
            ..where((t) => t.userId.equals(userId)))
          .go();
}
