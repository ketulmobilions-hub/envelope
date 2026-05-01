import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class _MockGoalRepository extends Mock implements GoalRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _MockBudgetRepository extends Mock implements BudgetRepository {}

class _MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late _MockGoalRepository goalRepository;
  late _MockEnvelopeRepository envelopeRepository;
  late _MockBudgetRepository budgetRepository;
  late _MockTransactionRepository transactionRepository;

  final now = DateTime(2024);
  const budgetId = 'budget-1';

  setUp(() {
    goalRepository = _MockGoalRepository();
    envelopeRepository = _MockEnvelopeRepository();
    budgetRepository = _MockBudgetRepository();
    transactionRepository = _MockTransactionRepository();
    when(
      () => envelopeRepository.watchEnvelopes(any()),
    ).thenAnswer((_) => const Stream<List<Envelope>>.empty());
    when(
      () => budgetRepository.watchBudgetPeriods(any()),
    ).thenAnswer((_) => const Stream<List<BudgetPeriod>>.empty());
    when(
      () => envelopeRepository.watchAllocations(any()),
    ).thenAnswer((_) => const Stream<List<EnvelopeAllocation>>.empty());
    when(
      () => transactionRepository.watchTransactions(
        budgetId: any(named: 'budgetId'),
        envelopeId: any(named: 'envelopeId'),
      ),
    ).thenAnswer((_) => const Stream<List<Transaction>>.empty());
  });

  GoalDetailCubit build({required Goal goal}) {
    return GoalDetailCubit(
      goalRepository: goalRepository,
      envelopeRepository: envelopeRepository,
      budgetRepository: budgetRepository,
      transactionRepository: transactionRepository,
      goal: goal,
    );
  }

  Goal goalWith({String? envelopeId, String type = 'savings_target'}) {
    return Goal(
      id: 'goal-1',
      budgetId: budgetId,
      type: type,
      name: 'Test',
      envelopeId: envelopeId,
      currentAmount: 999,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('GoalDetailCubit', () {
    test(
      'unlinked goal subscribes to contributions and skips compute',
      () async {
        when(
          () => goalRepository.watchContributions('goal-1'),
        ).thenAnswer((_) => Stream.value(const <GoalContribution>[]));
        when(
          () => goalRepository.refreshContributions('goal-1'),
        ).thenAnswer((_) async {});

        final cubit = build(goal: goalWith());
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(cubit.state.computedCurrentAmount, isNull);
        expect(cubit.state.effectiveCurrentAmount, 999);
        verify(() => goalRepository.watchContributions('goal-1')).called(1);
        verifyNever(() => budgetRepository.watchBudgetPeriods(any()));
        await cubit.close();
      },
    );

    blocTest<GoalDetailCubit, GoalDetailState>(
      'linked savings_target emits computedCurrentAmount on allocation tick',
      build: () {
        final period = BudgetPeriod(
          id: 'period-1',
          budgetId: budgetId,
          startDate: DateTime(2000),
          endDate: DateTime(2100),
          createdAt: now,
        );
        final allocation = EnvelopeAllocation(
          id: 'alloc-1',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          createdAt: now,
          allocatedAmount: 500,
          spentAmount: 100,
          rolloverAmount: 200,
        );
        when(
          () => budgetRepository.watchBudgetPeriods(budgetId),
        ).thenAnswer((_) => Stream.value([period]));
        when(
          () => envelopeRepository.watchAllocations('period-1'),
        ).thenAnswer((_) => Stream.value([allocation]));
        return build(goal: goalWith(envelopeId: 'env-1'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        // 500 - 100 + 200 = 600
        expect(cubit.state.computedCurrentAmount, 600);
        expect(cubit.state.effectiveCurrentAmount, 600);
      },
    );

    blocTest<GoalDetailCubit, GoalDetailState>(
      'linked goal sets linkedEnvelopeName from envelopes stream',
      build: () {
        when(
          () => envelopeRepository.watchEnvelopes(budgetId),
        ).thenAnswer(
          (_) => Stream.value([
            Envelope(
              id: 'env-1',
              categoryGroupId: 'g',
              budgetId: budgetId,
              name: 'Vacation Fund',
              createdAt: now,
            ),
          ]),
        );
        return build(goal: goalWith(envelopeId: 'env-1'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        expect(cubit.state.linkedEnvelopeName, 'Vacation Fund');
      },
    );

    blocTest<GoalDetailCubit, GoalDetailState>(
      'debt_payoff sums expense transactions only',
      build: () {
        Transaction tx({required int amount, required String type}) =>
            Transaction(
              id: 't-${amount}_$type',
              budgetId: budgetId,
              accountId: 'acct',
              type: type,
              amount: amount,
              currency: 'USD',
              date: now,
              createdBy: 'u',
              createdAt: now,
              updatedAt: now,
              envelopeId: 'env-1',
            );
        when(
          () => transactionRepository.watchTransactions(
            budgetId: budgetId,
            envelopeId: 'env-1',
          ),
        ).thenAnswer(
          (_) => Stream.value([
            tx(amount: 100, type: 'expense'),
            tx(amount: 50, type: 'income'),
            tx(amount: 75, type: 'expense'),
          ]),
        );
        return build(
          goal: goalWith(envelopeId: 'env-1', type: 'debt_payoff'),
        );
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        expect(cubit.state.computedCurrentAmount, 175);
      },
    );
  });
}
