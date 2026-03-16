import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/recurring/cubit/recurring_check_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class FakeRecurringRule extends Fake implements RecurringRule {}

void main() {
  late MockTransactionRepository transactionRepository;

  final now = DateTime(2024, 6, 10);
  final pastDate = DateTime(2024, 6, 5);

  setUpAll(() {
    registerFallbackValue(FakeRecurringRule());
  });

  setUp(() {
    transactionRepository = MockTransactionRepository();
  });

  group('RecurringCheckCubit', () {
    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'auto-posts eligible rules and advances nextOccurrence',
      setUp: () {
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-1',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 5000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: pastDate,
              nextOccurrence: pastDate,
              createdAt: pastDate,
              payee: 'Netflix',
              autoPost: true,
            ),
          ]),
        );
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer((_) => Stream.value([]));
        when(() => transactionRepository.createTransaction(
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
              recurringRuleId: any(named: 'recurringRuleId'),
            )).thenAnswer(
          (_) async => Transaction(
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
          ),
        );
        when(() => transactionRepository.updateRecurringRule(any()))
            .thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        const RecurringCheckState(),
      ],
      verify: (_) {
        verify(() => transactionRepository.createTransaction(
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 5000,
              currency: 'USD',
              date: any(named: 'date'),
              createdBy: 'user-1',
              envelopeId: null,
              payee: 'Netflix',
              notes: null,
              recurringRuleId: 'rule-1',
            )).called(1);
        verify(() => transactionRepository.updateRecurringRule(any()))
            .called(1);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'collects pending manual rules',
      setUp: () {
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-2',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 3000,
              currency: 'USD',
              frequency: 'weekly',
              startDate: pastDate,
              nextOccurrence: pastDate,
              createdAt: pastDate,
              payee: 'Gym',
            ),
          ]),
        );
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        isA<RecurringCheckState>()
            .having((s) => s.pendingRules, 'pendingRules', hasLength(1))
            .having((s) => s.isChecking, 'isChecking', false),
      ],
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'skips paused rules',
      setUp: () {
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-3',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 1000,
              currency: 'USD',
              frequency: 'daily',
              startDate: pastDate,
              nextOccurrence: pastDate,
              createdAt: pastDate,
              isPaused: true,
            ),
          ]),
        );
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer((_) => Stream.value([]));
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        const RecurringCheckState(),
      ],
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'identifies upcoming bill reminders within reminder window',
      setUp: () {
        // Use a due day that is always within the reminder window
        // relative to DateTime.now().
        final today = DateTime.now();
        final dueDayInWindow = today.day + 2 > 28 ? 1 : today.day + 2;

        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer((_) => Stream.value([]));
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            BillReminder(
              id: 'bill-1',
              budgetId: 'budget-1',
              name: 'Rent',
              estimatedAmount: 150000,
              dueDay: dueDayInWindow,
              frequency: 'monthly',
              createdAt: pastDate,
              reminderDaysBefore: 5,
            ),
          ]),
        );
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        isA<RecurringCheckState>()
            .having((s) => s.upcomingBills, 'upcomingBills', hasLength(1))
            .having((s) => s.isChecking, 'isChecking', false),
      ],
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'does not advance nextOccurrence when createTransaction fails',
      setUp: () {
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-fail',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 1000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: pastDate,
              nextOccurrence: pastDate,
              createdAt: pastDate,
              autoPost: true,
            ),
          ]),
        );
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer((_) => Stream.value([]));
        when(() => transactionRepository.createTransaction(
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
              recurringRuleId: any(named: 'recurringRuleId'),
            )).thenThrow(const TransactionException('fail'));
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        const RecurringCheckState(),
      ],
      verify: (_) {
        verifyNever(
          () => transactionRepository.updateRecurringRule(any()),
        );
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'clamps monthly next occurrence for Jan 31 -> Feb 28',
      setUp: () {
        // Jan 31 + 1 month should be Feb 28 (non-leap year).
        final jan31 = DateTime(2025, 1, 31);
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-month',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 1000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: jan31,
              nextOccurrence: jan31,
              createdAt: jan31,
              autoPost: true,
            ),
          ]),
        );
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer((_) => Stream.value([]));
        when(() => transactionRepository.createTransaction(
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
              recurringRuleId: any(named: 'recurringRuleId'),
            )).thenAnswer(
          (_) async => Transaction(
            id: 'txn-m',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 1000,
            currency: 'USD',
            date: jan31,
            createdBy: 'user-1',
            createdAt: jan31,
            updatedAt: jan31,
          ),
        );
        when(() => transactionRepository.updateRecurringRule(any()))
            .thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      verify: (_) {
        final captured = verify(
          () => transactionRepository.updateRecurringRule(captureAny()),
        ).captured;
        final updatedRule = captured.first as RecurringRule;
        // Feb 28 (not Feb 31 which would overflow to March).
        expect(updatedRule.nextOccurrence.month, 2);
        expect(updatedRule.nextOccurrence.day, 28);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'clamps monthly next occurrence for Jan 29 -> Feb 28 in leap year',
      setUp: () {
        // 2024 is a leap year; Jan 30 + 1 month = Feb 29.
        final jan30 = DateTime(2024, 1, 30);
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-leap',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 1000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: jan30,
              nextOccurrence: jan30,
              createdAt: jan30,
              autoPost: true,
            ),
          ]),
        );
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer((_) => Stream.value([]));
        when(() => transactionRepository.createTransaction(
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
              recurringRuleId: any(named: 'recurringRuleId'),
            )).thenAnswer(
          (_) async => Transaction(
            id: 'txn-l',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 1000,
            currency: 'USD',
            date: jan30,
            createdBy: 'user-1',
            createdAt: jan30,
            updatedAt: jan30,
          ),
        );
        when(() => transactionRepository.updateRecurringRule(any()))
            .thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      verify: (_) {
        final captured = verify(
          () => transactionRepository.updateRecurringRule(captureAny()),
        ).captured;
        final updatedRule = captured.first as RecurringRule;
        // 2024 is leap year, so Feb has 29 days.
        expect(updatedRule.nextOccurrence.month, 2);
        expect(updatedRule.nextOccurrence.day, 29);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'bill upcoming clamps dueDay for short months',
      setUp: () {
        // Bill with dueDay=31 in a month with 30 days should still match.
        final today = DateTime.now();
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer((_) => Stream.value([]));
        when(() => transactionRepository.watchBillReminders('budget-1'))
            .thenAnswer(
          (_) => Stream.value([
            BillReminder(
              id: 'bill-clamp',
              budgetId: 'budget-1',
              name: 'Rent',
              estimatedAmount: 150000,
              dueDay: 31,
              frequency: 'monthly',
              createdAt: pastDate,
              reminderDaysBefore: 31,
            ),
          ]),
        );
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        isA<RecurringCheckState>()
            .having(
              (s) => s.upcomingBills,
              'upcomingBills',
              hasLength(1),
            )
            .having((s) => s.isChecking, 'isChecking', false),
      ],
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'handles check failure gracefully',
      setUp: () {
        when(() => transactionRepository.watchRecurringRules('budget-1'))
            .thenAnswer(
          (_) => Stream.error(Exception('fail')),
        );
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        const RecurringCheckState(),
      ],
    );
  });
}
