import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/recurring/view/recurring_rule_form_page.dart';
import 'package:envelope/theme/theme.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late MockTransactionRepository transactionRepository;
  late MockAccountRepository accountRepository;
  late MockEnvelopeRepository envelopeRepository;
  late AuthBloc authBloc;

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
    authBloc = _MockAuthBloc();

    when(
      () => accountRepository.watchAccounts('budget-1'),
    ).thenAnswer((_) => Stream.value(testAccounts));
    when(
      () => envelopeRepository.watchEnvelopes('budget-1'),
    ).thenAnswer((_) => Stream.value([]));
    when(() => authBloc.state).thenReturn(
      AuthState.authenticated(
        User(
          id: 'u1',
          email: 't@t.com',
          displayName: 'T',
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );
  });

  // Pumps the form inside a MaterialApp that provides AuthBloc above the
  // (root) navigator, so AppOptionPicker's root-navigator bottom sheets can
  // resolve it on rebuild. currencySymbol() reads AuthBloc via context.watch.
  Future<void> pumpForm(WidgetTester tester, Widget page) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: child ?? const SizedBox.shrink(),
        ),
        home: page,
      ),
    );
  }

  group('RecurringRuleFormPage', () {
    testWidgets('renders create form', (tester) async {
      await pumpForm(
        tester,
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
      await pumpForm(
        tester,
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
      await pumpForm(
        tester,
        RecurringRuleFormPage(
          transactionRepository: transactionRepository,
          accountRepository: accountRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      // Custom-frequency fields are hidden until 'custom' is selected.
      expect(find.text('Every'), findsNothing);

      // Scroll the frequency picker into view, then open it (an
      // AppOptionPicker triggered by tapping its label).
      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text('Frequency'),
        200,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Frequency'));
      await tester.pumpAndSettle();

      // 'Custom' is the last option in the bottom-sheet list and may be below
      // the fold of the (lazily built) list, so scroll it into view first.
      await tester.scrollUntilVisible(
        find.text('Custom'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      // Select 'Custom' from the bottom-sheet list.
      await tester.tap(find.text('Custom').last);
      await tester.pumpAndSettle();

      // The custom interval field ('Every') and unit dropdown now appear.
      expect(find.text('Every'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('validates required fields', (tester) async {
      await pumpForm(
        tester,
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
      await pumpForm(
        tester,
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

      await pumpForm(
        tester,
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
