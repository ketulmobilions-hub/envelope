// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_dao.dart';

// ignore_for_file: type=lint
mixin _$UsersDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $NotificationPreferencesTable get notificationPreferences =>
      attachedDatabase.notificationPreferences;
  UsersDaoManager get managers => UsersDaoManager(this);
}

class UsersDaoManager {
  final _$UsersDaoMixin _db;
  UsersDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$NotificationPreferencesTableTableManager get notificationPreferences =>
      $$NotificationPreferencesTableTableManager(
        _db.attachedDatabase,
        _db.notificationPreferences,
      );
}
