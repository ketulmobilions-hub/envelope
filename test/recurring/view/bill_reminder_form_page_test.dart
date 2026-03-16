import 'package:envelope/recurring/view/bill_reminder_form_page.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../../helpers/helpers.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

void main() {
  late MockTransactionRepository transactionRepository;
  late MockEnvelopeRepository envelopeRepository;

  final now = DateTime(2024);

  setUp(() {
    transactionRepository = MockTransactionRepository();
    envelopeRepository = MockEnvelopeRepository();

    when(() => envelopeRepository.watchEnvelopes('budget-1'))
        .thenAnswer((_) => Stream.value([]));
  });

  group('BillReminderFormPage', () {
    testWidgets('renders create form', (tester) async {
      await tester.pumpApp(
        BillReminderFormPage(
          transactionRepository: transactionRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Bill Reminder'), findsOneWidget);
      expect(find.text('Bill Name'), findsOneWidget);
    });

    testWidgets('renders edit form', (tester) async {
      await tester.pumpApp(
        BillReminderFormPage(
          transactionRepository: transactionRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
          reminder: BillReminder(
            id: 'bill-1',
            budgetId: 'budget-1',
            name: 'Electricity',
            estimatedAmount: 12000,
            dueDay: 15,
            frequency: 'monthly',
            createdAt: now,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Bill Reminder'), findsOneWidget);
      expect(find.text('Electricity'), findsOneWidget);
      expect(find.text('120.00'), findsOneWidget);
    });

    testWidgets('validates required fields', (tester) async {
      await tester.pumpApp(
        BillReminderFormPage(
          transactionRepository: transactionRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a bill name'), findsOneWidget);
    });

    testWidgets('shows frequency dropdown', (tester) async {
      await tester.pumpApp(
        BillReminderFormPage(
          transactionRepository: transactionRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Frequency'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsWidgets);
    });

    testWidgets('shows reminder days field', (tester) async {
      await tester.pumpApp(
        BillReminderFormPage(
          transactionRepository: transactionRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Remind Days Before'), findsOneWidget);
    });

    testWidgets('submits form and pops on success', (tester) async {
      when(() => transactionRepository.createBillReminder(
            budgetId: any(named: 'budgetId'),
            name: any(named: 'name'),
            estimatedAmount: any(named: 'estimatedAmount'),
            dueDay: any(named: 'dueDay'),
            frequency: any(named: 'frequency'),
            envelopeId: any(named: 'envelopeId'),
            reminderDaysBefore: any(named: 'reminderDaysBefore'),
          )).thenAnswer(
        (_) async => BillReminder(
          id: 'new-bill',
          budgetId: 'budget-1',
          name: 'Internet',
          estimatedAmount: 5000,
          dueDay: 1,
          frequency: 'monthly',
          createdAt: now,
        ),
      );

      await tester.pumpApp(
        BillReminderFormPage(
          transactionRepository: transactionRepository,
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        ),
      );
      await tester.pumpAndSettle();

      // Fill in name.
      await tester.enterText(
        find.byType(TextFormField).first,
        'Internet',
      );
      // Fill in amount.
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '50.00',
      );
      // Fill in due day.
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '1',
      );

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      verify(() => transactionRepository.createBillReminder(
            budgetId: 'budget-1',
            name: 'Internet',
            estimatedAmount: 5000,
            dueDay: 1,
            frequency: 'monthly',
            envelopeId: any(named: 'envelopeId'),
            reminderDaysBefore: any(named: 'reminderDaysBefore'),
          )).called(1);
    });
  });
}
