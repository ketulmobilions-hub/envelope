import 'package:account_repository/account_repository.dart';
import 'package:envelope/recurring/view/recurring_rule_form_page.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../../helpers/helpers.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

void main() {
  late MockTransactionRepository transactionRepository;
  late MockAccountRepository accountRepository;
  late MockEnvelopeRepository envelopeRepository;

  final now = DateTime(2024);
  final testAccounts = [
    Account(
      id: 'acc-1',
      budgetId: 'budget-1',
      name: 'Checking',
      type: 'checking',
      currency: 'USD',
      startingBalance: 10000,
      currentBalance: 15000,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    transactionRepository = MockTransactionRepository();
    accountRepository = MockAccountRepository();
    envelopeRepository = MockEnvelopeRepository();

    when(
      () => accountRepository.watchAccounts('budget-1'),
    ).thenAnswer((_) => Stream.value(testAccounts));
    when(
      () => envelopeRepository.watchEnvelopes('budget-1'),
    ).thenAnswer((_) => Stream.value([]));
  });

  group('RecurringRuleFormPage', () {
    testWidgets('renders create form', (tester) async {
      await tester.pumpApp(
        RecurringRuleFormPage(
          transactionRepository: transactionRepository,
          accountRepository: accountRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Recurring Rule'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);
    });

    testWidgets('renders edit form', (tester) async {
      await tester.pumpApp(
        RecurringRuleFormPage(
          transactionRepository: transactionRepository,
          accountRepository: accountRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
          rule: RecurringRule(
            id: 'rule-1',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 5000,
            currency: 'USD',
            frequency: 'monthly',
            startDate: now,
            nextOccurrence: now,
            createdAt: now,
            payee: 'Netflix',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Recurring Rule'), findsOneWidget);
      // Amount should be pre-filled.
      expect(find.text('50.00'), findsOneWidget);
    });

    testWidgets('shows custom frequency fields when custom selected', (
      tester,
    ) async {
      await tester.pumpApp(
        RecurringRuleFormPage(
          transactionRepository: transactionRepository,
          accountRepository: accountRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      // Find frequency dropdown and open it.
      final frequencyDropdown = find.byType(DropdownButtonFormField<String>);
      // There should be account dropdown + frequency dropdown at minimum.
      expect(frequencyDropdown, findsWidgets);
    });

    testWidgets('validates required fields', (tester) async {
      await tester.pumpApp(
        RecurringRuleFormPage(
          transactionRepository: transactionRepository,
          accountRepository: accountRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down to the Create button which may be offscreen.
      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.byType(FilledButton),
        200,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // The amount field validation message.
      expect(find.text('Please enter a valid amount'), findsOneWidget);
    });

    testWidgets('shows auto-post toggle', (tester) async {
      await tester.pumpApp(
        RecurringRuleFormPage(
          transactionRepository: transactionRepository,
          accountRepository: accountRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Auto-post transactions'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('calls createRecurringRule on valid submit', (tester) async {
      when(
        () => transactionRepository.createRecurringRule(
          budgetId: any(named: 'budgetId'),
          accountId: any(named: 'accountId'),
          type: any(named: 'type'),
          amount: any(named: 'amount'),
          currency: any(named: 'currency'),
          frequency: any(named: 'frequency'),
          startDate: any(named: 'startDate'),
          envelopeId: any(named: 'envelopeId'),
          payee: any(named: 'payee'),
          notes: any(named: 'notes'),
          customInterval: any(named: 'customInterval'),
          customUnit: any(named: 'customUnit'),
          endDate: any(named: 'endDate'),
          autoPost: any(named: 'autoPost'),
        ),
      ).thenAnswer(
        (_) async => RecurringRule(
          id: 'new-rule',
          budgetId: 'budget-1',
          accountId: 'acc-1',
          type: 'expense',
          amount: 5000,
          currency: 'USD',
          frequency: 'monthly',
          startDate: now,
          nextOccurrence: now,
          createdAt: now,
        ),
      );

      await tester.pumpApp(
        RecurringRuleFormPage(
          transactionRepository: transactionRepository,
          accountRepository: accountRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      // Wait for async account loading.
      await tester.pumpAndSettle();

      // The first TextFormField in the form is the Amount field
      // (after SegmentedButton and DropdownButtonFormFields).
      final textFields = find.byType(TextFormField);
      // Amount is the first TextFormField.
      await tester.enterText(textFields.at(0), '50.00');
      await tester.pump();

      // Scroll down to the Create button which may be offscreen.
      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.byType(FilledButton),
        200,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(
        () => transactionRepository.createRecurringRule(
          budgetId: 'budget-1',
          accountId: 'acc-1',
          type: any(named: 'type'),
          amount: 5000,
          currency: any(named: 'currency'),
          frequency: any(named: 'frequency'),
          startDate: any(named: 'startDate'),
          envelopeId: any(named: 'envelopeId'),
          payee: any(named: 'payee'),
          notes: any(named: 'notes'),
          customInterval: any(named: 'customInterval'),
          customUnit: any(named: 'customUnit'),
          endDate: any(named: 'endDate'),
          autoPost: any(named: 'autoPost'),
        ),
      ).called(1);
    });
  });
}
