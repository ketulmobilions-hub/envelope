import 'package:drift/drift.dart';

class NotificationPreferences extends Table {
  TextColumn get userId => text().named('user_id')();
  BoolColumn get pushEnabled =>
      boolean().named('push_enabled').withDefault(const Constant(true))();
  BoolColumn get emailEnabled =>
      boolean().named('email_enabled').withDefault(const Constant(true))();
  BoolColumn get overspendAlerts =>
      boolean().named('overspend_alerts').withDefault(const Constant(true))();
  BoolColumn get billReminders =>
      boolean().named('bill_reminders').withDefault(const Constant(true))();
  BoolColumn get dailyLoggingReminder => boolean()
      .named('daily_logging_reminder')
      .withDefault(const Constant(true))();
  BoolColumn get recurringTransactionAlerts => boolean()
      .named('recurring_transaction_alerts')
      .withDefault(const Constant(true))();
  BoolColumn get sharedBudgetActivity => boolean()
      .named('shared_budget_activity')
      .withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {userId};
}
