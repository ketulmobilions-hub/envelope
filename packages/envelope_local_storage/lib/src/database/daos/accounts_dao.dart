import 'package:drift/drift.dart';
import 'package:envelope_local_storage/src/database/app_database.dart';
import 'package:envelope_local_storage/src/database/tables/tables.dart';

part 'accounts_dao.g.dart';

@DriftAccessor(tables: [Accounts, DebtAccounts])
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.attachedDatabase);

  // Accounts CRUD
  Future<List<Account>> getAllAccounts() => select(accounts).get();

  Stream<List<Account>> watchAllAccounts() => select(accounts).watch();

  Future<Account?> getAccount(String id) =>
      (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<Account> watchAccount(String id) =>
      (select(accounts)..where((t) => t.id.equals(id))).watchSingle();

  Future<List<Account>> getAccountsByBudgetId(String budgetId) =>
      (select(accounts)..where((t) => t.budgetId.equals(budgetId))).get();

  Stream<List<Account>> watchAccountsByBudgetId(String budgetId) =>
      (select(accounts)..where((t) => t.budgetId.equals(budgetId))).watch();

  Future<int> insertAccount(
    AccountsCompanion account, {
    InsertMode mode = InsertMode.insert,
  }) =>
      into(accounts).insert(account, mode: mode);

  Future<void> batchInsertAccounts(
    List<AccountsCompanion> entries, {
    InsertMode mode = InsertMode.insert,
  }) async {
    await batch((b) {
      b.insertAll(accounts, entries, mode: mode);
    });
  }

  Future<bool> updateAccount(AccountsCompanion account) =>
      update(accounts).replace(account);

  Future<int> deleteAccount(String id) =>
      (delete(accounts)..where((t) => t.id.equals(id))).go();

  // Debt Accounts CRUD
  Future<DebtAccount?> getDebtAccount(String accountId) =>
      (select(debtAccounts)..where((t) => t.accountId.equals(accountId)))
          .getSingleOrNull();

  Stream<DebtAccount?> watchDebtAccount(String accountId) =>
      (select(debtAccounts)..where((t) => t.accountId.equals(accountId)))
          .watchSingleOrNull();

  Future<List<DebtAccount>> getAllDebtAccounts() =>
      select(debtAccounts).get();

  Future<int> insertDebtAccount(
    DebtAccountsCompanion debtAccount, {
    InsertMode mode = InsertMode.insert,
  }) =>
      into(debtAccounts).insert(debtAccount, mode: mode);

  Future<bool> updateDebtAccount(DebtAccountsCompanion debtAccount) =>
      update(debtAccounts).replace(debtAccount);

  Future<int> deleteDebtAccount(String accountId) =>
      (delete(debtAccounts)..where((t) => t.accountId.equals(accountId))).go();
}
