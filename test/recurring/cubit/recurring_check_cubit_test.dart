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
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
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
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
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
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: now),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        const RecurringCheckState(),
      ],
      verify: (_) {
        verify(
          () => transactionRepository.createTransaction(
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 5000,
            currency: 'USD',
            date: pastDate,
            createdBy: 'user-1',
            envelopeId: null,
            payee: 'Netflix',
            notes: null,
            recurringRuleId: 'rule-1',
          ),
        ).called(1);
        verify(
          () => transactionRepository.updateRecurringRule(any()),
        ).called(1);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'collects pending manual rules',
      setUp: () {
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
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
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
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
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
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
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
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

        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer(
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
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
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
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenThrow(const TransactionException('fail'));
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: now),
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
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
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
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
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
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: DateTime(2025, 2, 5)),
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
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
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
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
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
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: DateTime(2024, 2, 5)),
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
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer(
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
      'posts at rule.nextOccurrence, not effectiveNow',
      setUp: () {
        final apr5 = DateTime(2026, 4, 5);
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-date',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 2000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: apr5,
              nextOccurrence: apr5,
              createdAt: apr5,
              autoPost: true,
            ),
          ]),
        );
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
          (_) async => Transaction(
            id: 'txn-d',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 2000,
            currency: 'USD',
            date: apr5,
            createdBy: 'user-1',
            createdAt: apr5,
            updatedAt: apr5,
          ),
        );
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      // effectiveNow well after nextOccurrence, but still inside the first
      // cycle's window so only one occurrence is posted.
      act: (cubit) => cubit.check(now: DateTime(2026, 4, 25)),
      verify: (_) {
        verify(
          () => transactionRepository.createTransaction(
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 2000,
            currency: 'USD',
            date: DateTime(2026, 4, 5),
            createdBy: 'user-1',
            envelopeId: null,
            payee: null,
            notes: null,
            recurringRuleId: 'rule-date',
          ),
        ).called(1);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'catches up multiple missed monthly occurrences in one check',
      setUp: () {
        final apr5 = DateTime(2026, 4, 5);
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-catchup',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 2000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: apr5,
              nextOccurrence: apr5,
              createdAt: apr5,
              autoPost: true,
            ),
          ]),
        );
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
          (invocation) async => Transaction(
            id: 'txn-${invocation.namedArguments[#date]}',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 2000,
            currency: 'USD',
            date: invocation.namedArguments[#date] as DateTime,
            createdBy: 'user-1',
            createdAt: apr5,
            updatedAt: apr5,
          ),
        );
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      // Today = May 25. Apr 5 and May 5 are due; Jun 5 is not.
      act: (cubit) => cubit.check(now: DateTime(2026, 5, 25)),
      verify: (_) {
        final captured = verify(
          () => transactionRepository.createTransaction(
            budgetId: any(named: 'budgetId'),
            accountId: any(named: 'accountId'),
            type: any(named: 'type'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            date: captureAny(named: 'date'),
            createdBy: any(named: 'createdBy'),
            envelopeId: any(named: 'envelopeId'),
            payee: any(named: 'payee'),
            notes: any(named: 'notes'),
            recurringRuleId: any(named: 'recurringRuleId'),
          ),
        ).captured;
        expect(captured, hasLength(2));
        expect(captured[0], DateTime(2026, 4, 5));
        expect(captured[1], DateTime(2026, 5, 5));
        // Incremental cursor persistence — one update per posted cycle so
        // partial progress survives a mid-loop failure.
        final updateCaptured = verify(
          () => transactionRepository.updateRecurringRule(captureAny()),
        ).captured;
        expect(updateCaptured, hasLength(2));
        expect(
          (updateCaptured[0] as RecurringRule).nextOccurrence,
          DateTime(2026, 5, 5),
        );
        expect(
          (updateCaptured.last as RecurringRule).nextOccurrence,
          DateTime(2026, 6, 5),
        );
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'manual-confirm rule lands in pendingRules once and does not advance',
      setUp: () {
        final apr5 = DateTime(2026, 4, 5);
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-manual',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 2000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: apr5,
              nextOccurrence: apr5,
              createdAt: apr5,
            ),
          ]),
        );
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: DateTime(2026, 5, 25)),
      expect: () => [
        const RecurringCheckState(isChecking: true),
        isA<RecurringCheckState>()
            .having((s) => s.pendingRules, 'pendingRules', hasLength(1))
            .having((s) => s.isChecking, 'isChecking', false),
      ],
      verify: (_) {
        verifyNever(
          () => transactionRepository.createTransaction(
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
          ),
        );
        verifyNever(
          () => transactionRepository.updateRecurringRule(any()),
        );
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'endDate clamps the catch-up loop',
      setUp: () {
        final apr5 = DateTime(2026, 4, 5);
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-end',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 2000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: apr5,
              nextOccurrence: apr5,
              createdAt: apr5,
              autoPost: true,
              endDate: DateTime(2026, 4, 20),
            ),
          ]),
        );
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
          (invocation) async => Transaction(
            id: 'txn-end',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 2000,
            currency: 'USD',
            date: invocation.namedArguments[#date] as DateTime,
            createdBy: 'user-1',
            createdAt: apr5,
            updatedAt: apr5,
          ),
        );
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: DateTime(2026, 6, 25)),
      verify: (_) {
        final captured = verify(
          () => transactionRepository.createTransaction(
            budgetId: any(named: 'budgetId'),
            accountId: any(named: 'accountId'),
            type: any(named: 'type'),
            amount: any(named: 'amount'),
            currency: any(named: 'currency'),
            date: captureAny(named: 'date'),
            createdBy: any(named: 'createdBy'),
            envelopeId: any(named: 'envelopeId'),
            payee: any(named: 'payee'),
            notes: any(named: 'notes'),
            recurringRuleId: any(named: 'recurringRuleId'),
          ),
        ).captured;
        // Only Apr 5 — May 5 is past endDate (Apr 20).
        expect(captured, [DateTime(2026, 4, 5)]);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'clamps customInterval <= 0 to 1 instead of looping forever',
      setUp: () {
        final apr5 = DateTime(2026, 4, 5);
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-zero',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 2000,
              currency: 'USD',
              frequency: 'custom',
              customInterval: 0,
              customUnit: 'days',
              startDate: apr5,
              nextOccurrence: apr5,
              createdAt: apr5,
              autoPost: true,
            ),
          ]),
        );
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
          (invocation) async => Transaction(
            id: 'txn-z',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 2000,
            currency: 'USD',
            date: invocation.namedArguments[#date] as DateTime,
            createdBy: 'user-1',
            createdAt: apr5,
            updatedAt: apr5,
          ),
        );
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenAnswer((_) async {});
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: DateTime(2026, 4, 7)),
      verify: (_) {
        // 3 daily posts: Apr 5, 6, 7 (clamp interval to 1).
        verify(
          () => transactionRepository.createTransaction(
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
          ),
        ).called(3);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'aborts catch-up when cursor persistence fails',
      setUp: () {
        final apr5 = DateTime(2026, 4, 5);
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([
            RecurringRule(
              id: 'rule-persist',
              budgetId: 'budget-1',
              accountId: 'acc-1',
              type: 'expense',
              amount: 2000,
              currency: 'USD',
              frequency: 'monthly',
              startDate: apr5,
              nextOccurrence: apr5,
              createdAt: apr5,
              autoPost: true,
            ),
          ]),
        );
        when(
          () => transactionRepository.watchBillReminders('budget-1'),
        ).thenAnswer((_) => Stream.value([]));
        when(
          () => transactionRepository.createTransaction(
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
          ),
        ).thenAnswer(
          (invocation) async => Transaction(
            id: 'txn-p',
            budgetId: 'budget-1',
            accountId: 'acc-1',
            type: 'expense',
            amount: 2000,
            currency: 'USD',
            date: invocation.namedArguments[#date] as DateTime,
            createdBy: 'user-1',
            createdAt: apr5,
            updatedAt: apr5,
          ),
        );
        when(
          () => transactionRepository.updateRecurringRule(any()),
        ).thenThrow(const TransactionException('persist failed'));
      },
      build: () => RecurringCheckCubit(
        transactionRepository: transactionRepository,
        budgetId: 'budget-1',
        userId: 'user-1',
      ),
      act: (cubit) => cubit.check(now: DateTime(2026, 5, 25)),
      verify: (_) {
        // First create succeeds, then updateRecurringRule throws — loop
        // aborts before a second create attempt.
        verify(
          () => transactionRepository.createTransaction(
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
          ),
        ).called(1);
        verify(
          () => transactionRepository.updateRecurringRule(any()),
        ).called(1);
      },
    );

    blocTest<RecurringCheckCubit, RecurringCheckState>(
      'handles check failure gracefully',
      setUp: () {
        when(
          () => transactionRepository.watchRecurringRules('budget-1'),
        ).thenAnswer(
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
