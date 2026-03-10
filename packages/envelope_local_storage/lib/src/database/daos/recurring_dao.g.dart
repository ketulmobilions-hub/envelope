// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_dao.dart';

// ignore_for_file: type=lint
mixin _$RecurringDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecurringRulesTable get recurringRules => attachedDatabase.recurringRules;
  $BillRemindersTable get billReminders => attachedDatabase.billReminders;
  RecurringDaoManager get managers => RecurringDaoManager(this);
}

class RecurringDaoManager {
  final _$RecurringDaoMixin _db;
  RecurringDaoManager(this._db);
  $$RecurringRulesTableTableManager get recurringRules =>
      $$RecurringRulesTableTableManager(
        _db.attachedDatabase,
        _db.recurringRules,
      );
  $$BillRemindersTableTableManager get billReminders =>
      $$BillRemindersTableTableManager(_db.attachedDatabase, _db.billReminders);
}
