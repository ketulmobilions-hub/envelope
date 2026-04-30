import 'package:drift/drift.dart';

class DebtAccounts extends Table {
  TextColumn get accountId => text().named('account_id')();
  RealColumn get interestRate => real().named('interest_rate')();
  IntColumn get minimumPayment => integer().named('minimum_payment')();
  IntColumn get originalBalance => integer().named('original_balance')();
  TextColumn get payoffStrategy => text().named('payoff_strategy').nullable()();
  IntColumn get creditLimit => integer().named('credit_limit').nullable()();

  @override
  Set<Column> get primaryKey => {accountId};
}
