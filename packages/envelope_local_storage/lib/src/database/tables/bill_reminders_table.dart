import 'package:drift/drift.dart';

class BillReminders extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text().named('budget_id')();
  TextColumn get name => text()();
  IntColumn get estimatedAmount => integer().named('estimated_amount')();
  IntColumn get dueDay => integer().named('due_day')();
  TextColumn get frequency => text()();
  TextColumn get envelopeId => text().named('envelope_id').nullable()();
  IntColumn get reminderDaysBefore =>
      integer().named('reminder_days_before').withDefault(const Constant(3))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}
