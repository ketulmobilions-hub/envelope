import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'recurring_dao.g.dart';

@DriftAccessor(tables: [RecurringRules, BillReminders])
class RecurringDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringDaoMixin {
  RecurringDao(super.attachedDatabase);

  // Recurring Rules CRUD
  Future<List<RecurringRule>> getAllRecurringRules() =>
      select(recurringRules).get();

  Future<List<RecurringRule>> getRecurringRulesByBudgetId(String budgetId) =>
      (select(recurringRules)..where((t) => t.budgetId.equals(budgetId)))
          .get();

  Stream<List<RecurringRule>> watchRecurringRulesByBudgetId(String budgetId) =>
      (select(recurringRules)..where((t) => t.budgetId.equals(budgetId)))
          .watch();

  Future<RecurringRule?> getRecurringRule(String id) =>
      (select(recurringRules)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Stream<RecurringRule> watchRecurringRule(String id) =>
      (select(recurringRules)..where((t) => t.id.equals(id))).watchSingle();

  Future<int> insertRecurringRule(RecurringRulesCompanion rule) =>
      into(recurringRules).insert(rule);

  Future<bool> updateRecurringRule(RecurringRulesCompanion rule) =>
      update(recurringRules).replace(rule);

  Future<int> deleteRecurringRule(String id) =>
      (delete(recurringRules)..where((t) => t.id.equals(id))).go();

  // Bill Reminders CRUD
  Future<List<BillReminder>> getAllBillReminders() =>
      select(billReminders).get();

  Future<List<BillReminder>> getBillRemindersByBudgetId(String budgetId) =>
      (select(billReminders)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<BillReminder>> watchBillRemindersByBudgetId(String budgetId) =>
      (select(billReminders)..where((t) => t.budgetId.equals(budgetId)))
          .watch();

  Future<BillReminder?> getBillReminder(String id) =>
      (select(billReminders)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertBillReminder(BillRemindersCompanion reminder) =>
      into(billReminders).insert(reminder);

  Future<bool> updateBillReminder(BillRemindersCompanion reminder) =>
      update(billReminders).replace(reminder);

  Future<int> deleteBillReminder(String id) =>
      (delete(billReminders)..where((t) => t.id.equals(id))).go();
}
