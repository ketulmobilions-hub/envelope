import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/view/transaction_form_page.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../../helpers/pump_app.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  final now = DateTime(2026, 3, 17);

  late MockTransactionRepository transactionRepo;
  late MockAccountRepository accountRepo;
  late MockEnvelopeRepository envelopeRepo;
  late MockBudgetRepository budgetRepo;

  final accounts = <Account>[
    Account(
      id: 'acc-1',
      budgetId: 'budget-1',
      name: 'Checking',
      type: 'checking',
      currency: 'USD',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  final envelopes = <Envelope>[
    Envelope(
      id: 'env-1',
      categoryGroupId: 'group-1',
      budgetId: 'budget-1',
      name: 'Groceries',
      createdAt: now,
    ),
    Envelope(
      id: 'env-2',
      categoryGroupId: 'group-1',
      budgetId: 'budget-1',
      name: 'Entertainment',
      createdAt: now,
    ),
  ];

  final overspentAllocations = <EnvelopeAllocation>[
    EnvelopeAllocation(
      id: 'alloc-1',
      envelopeId: 'env-1',
      budgetPeriodId: 'period-1',
      allocatedAmount: 5000,
      spentAmount: 10000, // available = -$50
      createdAt: now,
    ),
    EnvelopeAllocation(
      id: 'alloc-2',
      envelopeId: 'env-2',
      budgetPeriodId: 'period-1',
      allocatedAmount: 30000,
      createdAt: now,
    ),
  ];

  final healthyAllocations = <EnvelopeAllocation>[
    EnvelopeAllocation(
      id: 'alloc-1',
      envelopeId: 'env-1',
      budgetPeriodId: 'period-1',
      allocatedAmount: 20000,
      spentAmount: 5000,
      createdAt: now,
    ),
  ];

  Transaction makeTransaction() => Transaction(
    id: 'txn-1',
    budgetId: 'budget-1',
    accountId: 'acc-1',
    type: 'expense',
    amount: 5000,
    currency: 'USD',
    date: now,
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    transactionRepo = MockTransactionRepository();
    accountRepo = MockAccountRepository();
    envelopeRepo = MockEnvelopeRepository();
    budgetRepo = MockBudgetRepository();

    when(
      () => accountRepo.watchAccounts(any()),
    ).thenAnswer((_) => Stream.value(accounts));
    when(
      () => envelopeRepo.watchEnvelopes(any()),
    ).thenAnswer((_) => Stream.value(envelopes));
    when(() => transactionRepo.getTags(any())).thenAnswer((_) async => <Tag>[]);

    registerFallbackValue(makeTransaction());
  });

  Widget buildSubject({String? budgetPeriodId}) {
    return RepositoryProvider<BudgetRepository>.value(
      value: budgetRepo,
      child: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => TransactionFormCubit(
              transactionRepository: transactionRepo,
              accountRepository: accountRepo,
              envelopeRepository: envelopeRepo,
              budgetId: 'budget-1',
              userId: 'user-1',
              budgetPeriodId: budgetPeriodId,
            ),
            child: const TransactionFormPage(),
          ),
        ),
      ),
    );
  }

  void stubCreateTransaction() {
    when(
      () => transactionRepo.createTransaction(
        budgetId: any(named: 'budgetId'),
        accountId: any(named: 'accountId'),
        type: any(named: 'type'),
        amount: any(named: 'amount'),
        currency: any(named: 'currency'),
        date: any(named: 'date'),
        createdBy: any(named: 'createdBy'),
        envelopeId: any(named: 'envelopeId'),
        payee: any(named: 'payee'),
        notes: any(named: 'notes'),
      ),
    ).thenAnswer((_) async => makeTransaction());
  }

  Future<void> fillAndSubmit(WidgetTester tester) async {
    // Enter amount first (TextFormField at index 0 is the
    // amount field — the payee is at 1, notes at 2).
    final amountField = find.byType(TextFormField).first;
    await tester.enterText(amountField, '50.00');
    await tester.pumpAndSettle();

    // Select account.
    await tester.tap(
      find.byType(DropdownButtonFormField<String>).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checking').last);
    await tester.pumpAndSettle();

    // Select envelope.
    await tester.tap(
      find.byType(DropdownButtonFormField<String>).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Groceries').last);
    await tester.pumpAndSettle();

    // Scroll the submit button into view and tap it.
    final submitButton = find.widgetWithText(
      FilledButton,
      'Create Transaction',
    );
    await tester.ensureVisible(submitButton);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    // Use pump() instead of pumpAndSettle() because the
    // CircularProgressIndicator animates continuously.
    // Pump multiple frames to let async work complete.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('overspend check', () {
    testWidgets(
      'shows warning dialog when expense overspends',
      (tester) async {
        stubCreateTransaction();
        when(
          () => envelopeRepo.refreshAllocations(any()),
        ).thenAnswer((_) async {});
        when(() => envelopeRepo.watchAllocations(any())).thenAnswer(
          (_) => Stream.value(overspentAllocations),
        );

        await tester.pumpApp(
          buildSubject(budgetPeriodId: 'period-1'),
        );
        // Allow _loadData to complete.
        await tester.pump();
        await tester.pump();
        await tester.pumpAndSettle();

        await fillAndSubmit(tester);

        // Verify the transaction was actually created.
        verify(
          () => transactionRepo.createTransaction(
            budgetId: any(named: 'budgetId'),
            accountId: any(named: 'accountId'),
            type: any(named: 'type'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            date: any(named: 'date'),
            createdBy: any(named: 'createdBy'),
            envelopeId: any(named: 'envelopeId'),
            payee: any(named: 'payee'),
            notes: any(named: 'notes'),
          ),
        ).called(1);

        // Verify overspend check ran.
        verify(
          () => envelopeRepo.refreshAllocations('period-1'),
        ).called(1);

        expect(
          find.text('Envelope Overspent'),
          findsOneWidget,
        );
        expect(
          find.text('Cover Overspending'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'no warning when budgetPeriodId is null',
      (tester) async {
        stubCreateTransaction();

        await tester.pumpApp(buildSubject());
        await tester.pumpAndSettle();

        await fillAndSubmit(tester);

        expect(find.text('Envelope Overspent'), findsNothing);
        verifyNever(
          () => envelopeRepo.refreshAllocations(any()),
        );
      },
    );

    testWidgets(
      'no warning when envelope is not overspent',
      (tester) async {
        stubCreateTransaction();
        when(
          () => envelopeRepo.refreshAllocations(any()),
        ).thenAnswer((_) async {});
        when(() => envelopeRepo.watchAllocations(any())).thenAnswer(
          (_) => Stream.value(healthyAllocations),
        );

        await tester.pumpApp(
          buildSubject(budgetPeriodId: 'period-1'),
        );
        await tester.pumpAndSettle();

        await fillAndSubmit(tester);

        expect(find.text('Envelope Overspent'), findsNothing);
      },
    );

    testWidgets(
      'dismiss closes warning without cover dialog',
      (tester) async {
        stubCreateTransaction();
        when(
          () => envelopeRepo.refreshAllocations(any()),
        ).thenAnswer((_) async {});
        when(() => envelopeRepo.watchAllocations(any())).thenAnswer(
          (_) => Stream.value(overspentAllocations),
        );

        await tester.pumpApp(
          buildSubject(budgetPeriodId: 'period-1'),
        );
        await tester.pumpAndSettle();

        await fillAndSubmit(tester);

        expect(
          find.text('Envelope Overspent'),
          findsOneWidget,
        );

        // Tap dismiss.
        await tester.tap(find.text('Dismiss'));
        await tester.pumpAndSettle();

        // Cover dialog should NOT appear.
        expect(
          find.text('Cover Overspending'),
          findsNothing,
        );
      },
    );
  });
}
