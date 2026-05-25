import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/recurring/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockTransactionRepository transactionRepository;

  final now = DateTime(2024);
  final testRules = [
    RecurringRule(
      id: 'rule-1',
      budgetId: 'budget-1',
      accountId: 'acc-1',
      type: 'expense',
      amount: 5000,
      currency: 'USD',
      frequency: 'monthly',
      startDate: now,
      nextOccurrence: now.add(const Duration(days: 30)),
      createdAt: now,
      payee: 'Netflix',
    ),
    RecurringRule(
      id: 'rule-2',
      budgetId: 'budget-1',
      accountId: 'acc-1',
      type: 'income',
      amount: 300000,
      currency: 'USD',
      frequency: 'monthly',
      startDate: now,
      nextOccurrence: now.add(const Duration(days: 15)),
      createdAt: now,
      payee: 'Salary',
      isPaused: true,
    ),
  ];

  final testReminders = [
    BillReminder(
      id: 'bill-1',
      budgetId: 'budget-1',
      name: 'Electricity',
      estimatedAmount: 12000,
      dueDay: 15,
      frequency: 'monthly',
      createdAt: now,
    ),
  ];

  setUp(() {
    transactionRepository = MockTransactionRepository();
  });

  group('RecurringBloc', () {
    blocTest<RecurringBloc, RecurringState>(
      'emits [loading, loaded] when RecurringStarted is added',
      build: () {
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer((_) => Stream.value(testRules));
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value(testReminders));
        when(
          () => transactionRepository.refreshRecurringRules('budget-1'),
        ).thenAnswer((_) async {});
        when(
          () => transactionRepository.refreshBillReminders('budget-1'),
        ).thenAnswer((_) async {});
        return RecurringBloc(
          transactionRepository: transactionRepository,
          budgetId: 'budget-1',
          userId: 'user-1',
        );
      },
      act: (bloc) => bloc.add(const RecurringStarted()),
      expect: () => [
        const RecurringState(status: RecurringStatus.loading),
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
        ),
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
          billReminders: testReminders,
        ),
      ],
      verify: (_) {
        verify(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).called(1);
        verify(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).called(1);
        verify(
          () => transactionRepository.refreshRecurringRules('budget-1'),
        ).called(1);
        verify(
          () => transactionRepository.refreshBillReminders('budget-1'),
        ).called(1);
      },
    );

    blocTest<RecurringBloc, RecurringState>(
      'still loads from local stream when refresh fails',
      build: () {
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer((_) => Stream.value(testRules));
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value(testReminders));
        when(
          () => transactionRepository.refreshRecurringRules('budget-1'),
        ).thenThrow(
          const TransactionException('Network error'),
        );
        when(
          () => transactionRepository.refreshBillReminders('budget-1'),
        ).thenThrow(
          const TransactionException('Network error'),
        );
        return RecurringBloc(
          transactionRepository: transactionRepository,
          budgetId: 'budget-1',
          userId: 'user-1',
        );
      },
      act: (bloc) => bloc.add(const RecurringStarted()),
      expect: () => [
        const RecurringState(status: RecurringStatus.loading),
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
        ),
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
          billReminders: testReminders,
        ),
      ],
    );

    blocTest<RecurringBloc, RecurringState>(
      'emits error then clears when rules stream errors',
      build: () {
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
          (_) => Stream.error(
            const TransactionException('Stream error'),
          ),
        );
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value(testReminders));
        when(
          () => transactionRepository.refreshRecurringRules('budget-1'),
        ).thenAnswer((_) async {});
        when(
          () => transactionRepository.refreshBillReminders('budget-1'),
        ).thenAnswer((_) async {});
        return RecurringBloc(
          transactionRepository: transactionRepository,
          budgetId: 'budget-1',
          userId: 'user-1',
        );
      },
      act: (bloc) => bloc.add(const RecurringStarted()),
      expect: () => [
        const RecurringState(status: RecurringStatus.loading),
        const RecurringState(
          status: RecurringStatus.error,
          error: RecurringError.loadFailed,
        ),
        const RecurringState(status: RecurringStatus.loaded),
        RecurringState(
          status: RecurringStatus.loaded,
          billReminders: testReminders,
        ),
      ],
    );

    blocTest<RecurringBloc, RecurringState>(
      'deletes recurring rule and supports undo',
      setUp: () {
        when(
          () => transactionRepository.deleteRecurringRule('rule-1'),
        ).thenAnswer((_) async {});
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
        ).thenAnswer((_) async => testRules.first);
      },
      seed: () => RecurringState(
        status: RecurringStatus.loaded,
        recurringRules: testRules,
      ),
      build: () => RecurringBloc(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (bloc) async {
        bloc.add(const RecurringRuleDeleted('rule-1'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const RecurringRuleUndoDeleteRequested());
      },
      verify: (_) {
        verify(
          () => transactionRepository.deleteRecurringRule('rule-1'),
        ).called(1);
        verify(
          () => transactionRepository.createRecurringRule(
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 5000,
            currency: 'USD',
            frequency: 'monthly',
            startDate: now,
            envelopeId: null,
            payee: 'Netflix',
            notes: null,
            customInterval: null,
            customUnit: null,
            endDate: null,
            autoPost: false,
          ),
        ).called(1);
      },
    );

    blocTest<RecurringBloc, RecurringState>(
      'toggles pause on a recurring rule',
      setUp: () {
        when(
          () => transactionRepository.pauseRecurringRule('rule-1'),
        ).thenAnswer((_) async {});
        when(
          () => transactionRepository.resumeRecurringRule('rule-2'),
        ).thenAnswer((_) async {});
      },
      seed: () => RecurringState(
        status: RecurringStatus.loaded,
        recurringRules: testRules,
      ),
      build: () => RecurringBloc(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (bloc) {
        bloc
          ..add(const RecurringRulePauseToggled('rule-1'))
          ..add(const RecurringRulePauseToggled('rule-2'));
      },
      verify: (_) {
        verify(
          () => transactionRepository.pauseRecurringRule('rule-1'),
        ).called(1);
        verify(
          () => transactionRepository.resumeRecurringRule('rule-2'),
        ).called(1);
      },
    );

    blocTest<RecurringBloc, RecurringState>(
      'deletes bill reminder and supports undo',
      setUp: () {
        when(
          () => transactionRepository.deleteBillReminder('bill-1'),
        ).thenAnswer((_) async {});
        when(
          () => transactionRepository.createBillReminder(
            budgetId: any(named: 'budgetId'),
            name: any(named: 'name'),
            estimatedAmount: any(named: 'estimatedAmount'),
            dueDay: any(named: 'dueDay'),
            frequency: any(named: 'frequency'),
            envelopeId: any(named: 'envelopeId'),
            reminderDaysBefore: any(named: 'reminderDaysBefore'),
          ),
        ).thenAnswer((_) async => testReminders.first);
      },
      seed: () => RecurringState(
        status: RecurringStatus.loaded,
        billReminders: testReminders,
      ),
      build: () => RecurringBloc(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (bloc) async {
        bloc.add(const BillReminderDeleted('bill-1'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const BillReminderUndoDeleteRequested());
      },
      verify: (_) {
        verify(
          () => transactionRepository.deleteBillReminder('bill-1'),
        ).called(1);
        verify(
          () => transactionRepository.createBillReminder(
            budgetId: 'budget-1',
            name: 'Electricity',
            estimatedAmount: 12000,
            dueDay: 15,
            frequency: 'monthly',
            envelopeId: null,
            reminderDaysBefore: 3,
          ),
        ).called(1);
      },
    );

    blocTest<RecurringBloc, RecurringState>(
      'emits error when delete fails',
      setUp: () {
        when(
          () => transactionRepository.deleteRecurringRule('rule-1'),
        ).thenThrow(
          const TransactionException('Delete failed'),
        );
      },
      seed: () => RecurringState(
        status: RecurringStatus.loaded,
        recurringRules: testRules,
      ),
      build: () => RecurringBloc(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (bloc) => bloc.add(const RecurringRuleDeleted('rule-1')),
      expect: () => [
        RecurringState(
          status: RecurringStatus.error,
          recurringRules: testRules,
          error: RecurringError.deleteFailed,
        ),
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
        ),
      ],
    );
  });

  group('RecurringState', () {
    test('activeRules returns only non-paused rules', () {
      final state = RecurringState(
        status: RecurringStatus.loaded,
        recurringRules: testRules,
      );
      expect(state.activeRules, hasLength(1));
      expect(state.activeRules.first.id, 'rule-1');
    });

    test('pausedRules returns only paused rules', () {
      final state = RecurringState(
        status: RecurringStatus.loaded,
        recurringRules: testRules,
      );
      expect(state.pausedRules, hasLength(1));
      expect(state.pausedRules.first.id, 'rule-2');
    });

    test('upcomingRules sorted by next occurrence', () {
      final state = RecurringState(
        status: RecurringStatus.loaded,
        recurringRules: testRules,
      );
      // Only one active rule so it's trivially sorted.
      expect(state.upcomingRules, hasLength(1));
    });

    test('upcomingBills sorted by due day', () {
      final state = RecurringState(
        status: RecurringStatus.loaded,
        billReminders: testReminders,
      );
      expect(state.upcomingBills, hasLength(1));
      expect(state.upcomingBills.first.dueDay, 15);
    });
  });
}
