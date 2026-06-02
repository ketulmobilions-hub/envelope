import 'package:account_repository/account_repository.dart';
import 'package:envelope/transactions/bloc/bloc.dart';
import 'package:envelope/transactions/widgets/transaction_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  final now = DateTime(2024);

  Account account(String id, String name) => Account(
    id: id,
    budgetId: 'b1',
    name: name,
    type: 'checking',
    currency: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  final accounts = [account('acc-1', 'Checking'), account('acc-2', 'Savings')];

  Future<void> pumpBar(
    WidgetTester tester, {
    required TransactionsFilter filter,
    List<Account> accounts = const [],
    ValueChanged<TransactionsFilter>? onFilterChanged,
  }) {
    return tester.pumpApp(
      Scaffold(
        body: TransactionFilterBar(
          filter: filter,
          accounts: accounts,
          onFilterChanged: onFilterChanged ?? (_) {},
        ),
      ),
    );
  }

  group('TransactionFilterBar account filter', () {
    testWidgets('hides the account chip when there are no accounts', (
      tester,
    ) async {
      await pumpBar(tester, filter: const TransactionsFilter());
      expect(find.text('Account'), findsNothing);
    });

    testWidgets('shows the generic label when no account is selected', (
      tester,
    ) async {
      await pumpBar(
        tester,
        filter: const TransactionsFilter(),
        accounts: accounts,
      );
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('shows the selected account name on the chip', (tester) async {
      await pumpBar(
        tester,
        filter: const TransactionsFilter(accountId: 'acc-2'),
        accounts: accounts,
      );
      expect(find.text('Savings'), findsOneWidget);
      expect(find.text('Account'), findsNothing);
    });

    testWidgets('shows "Unknown account" when the selected account is gone', (
      tester,
    ) async {
      await pumpBar(
        tester,
        filter: const TransactionsFilter(accountId: 'deleted-acc'),
        accounts: accounts,
      );
      expect(find.text('Unknown account'), findsOneWidget);
      expect(find.text('Account'), findsNothing);
    });

    testWidgets('selecting an account emits a filter with that accountId', (
      tester,
    ) async {
      TransactionsFilter? emitted;
      await pumpBar(
        tester,
        filter: const TransactionsFilter(),
        accounts: accounts,
        onFilterChanged: (f) => emitted = f,
      );

      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Savings'));
      await tester.pumpAndSettle();

      expect(emitted?.accountId, 'acc-2');
    });

    testWidgets('choosing "All accounts" clears the account filter', (
      tester,
    ) async {
      TransactionsFilter? emitted;
      await pumpBar(
        tester,
        filter: const TransactionsFilter(accountId: 'acc-1'),
        accounts: accounts,
        onFilterChanged: (f) => emitted = f,
      );

      // Chip shows the current account; tap it to open the picker.
      await tester.tap(find.text('Checking'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All accounts'));
      await tester.pumpAndSettle();

      expect(emitted, isNotNull);
      expect(emitted!.accountId, isNull);
    });
  });
}
