import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class _MockGoalRepository extends Mock implements GoalRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late _MockGoalRepository goalRepository;
  late _MockEnvelopeRepository envelopeRepository;
  late _MockTransactionRepository transactionRepository;

  final now = DateTime(2024);
  const budgetId = 'budget-1';

  setUp(() {
    goalRepository = _MockGoalRepository();
    envelopeRepository = _MockEnvelopeRepository();
    transactionRepository = _MockTransactionRepository();
    when(
      () => envelopeRepository.watchEnvelopes(any()),
    ).thenAnswer((_) => const Stream<List<Envelope>>.empty());
    when(
      () => envelopeRepository.watchAllocationsForEnvelope(any()),
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
        verifyNever(
          () => envelopeRepository.watchAllocationsForEnvelope(any()),
        );
        await cubit.close();
      },
    );

    blocTest<GoalDetailCubit, GoalDetailState>(
      'linked savings_target sums allocated - spent across all periods',
      build: () {
        when(
          () => envelopeRepository.watchAllocationsForEnvelope('env-1'),
        ).thenAnswer(
          (_) => Stream.value([
            EnvelopeAllocation(
              id: 'a1',
              envelopeId: 'env-1',
              budgetPeriodId: 'p1',
              createdAt: now,
              allocatedAmount: 200,
              spentAmount: 50,
            ),
            EnvelopeAllocation(
              id: 'a2',
              envelopeId: 'env-1',
              budgetPeriodId: 'p2',
              createdAt: now,
              allocatedAmount: 100,
              spentAmount: 30,
            ),
          ]),
        );
        return build(goal: goalWith(envelopeId: 'env-1'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (cubit) {
        // (200-50) + (100-30) = 150 + 70 = 220
        expect(cubit.state.computedCurrentAmount, 220);
        expect(cubit.state.effectiveCurrentAmount, 220);
      },
    );

    test('debt_payoff goal exposes payoff schedule from APR + payment', () {
      // $5,000 @ 18% APR, $150/mo monthlyContribution → ~47 months.
      final goal = Goal(
        id: 'goal-debt',
        budgetId: budgetId,
        type: 'debt_payoff',
        name: 'Card',
        targetAmount: 500000,
        monthlyContribution: 15000,
        aprBps: 1800,
        createdAt: now,
        updatedAt: now,
      );
      when(
        () => goalRepository.watchContributions('goal-debt'),
      ).thenAnswer((_) => Stream.value(const <GoalContribution>[]));
      when(
        () => goalRepository.refreshContributions('goal-debt'),
      ).thenAnswer((_) async {});

      final cubit = build(goal: goal);

      expect(cubit.state.payoffSchedule, isNotNull);
      expect(cubit.state.payoffSchedule!.infinite, false);
      expect(
        cubit.state.payoffSchedule!.monthsToPayoff,
        inInclusiveRange(46, 48),
      );
      cubit.close();
    });

    test('debt_payoff without APR exposes no payoff schedule', () {
      final goal = Goal(
        id: 'goal-debt',
        budgetId: budgetId,
        type: 'debt_payoff',
        name: 'Card',
        targetAmount: 500000,
        monthlyContribution: 15000,
        createdAt: now,
        updatedAt: now,
      );
      when(
        () => goalRepository.watchContributions('goal-debt'),
      ).thenAnswer((_) => Stream.value(const <GoalContribution>[]));
      when(
        () => goalRepository.refreshContributions('goal-debt'),
      ).thenAnswer((_) async {});

      final cubit = build(goal: goal);

      expect(cubit.state.payoffSchedule, isNull);
      cubit.close();
    });

    test('non-debt goals never expose a payoff schedule', () {
      when(
        () => goalRepository.watchContributions('goal-1'),
      ).thenAnswer((_) => Stream.value(const <GoalContribution>[]));
      when(
        () => goalRepository.refreshContributions('goal-1'),
      ).thenAnswer((_) async {});

      final cubit = build(goal: goalWith());

      expect(cubit.state.payoffSchedule, isNull);
      cubit.close();
    });

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
