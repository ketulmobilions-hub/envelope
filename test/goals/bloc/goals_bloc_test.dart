import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/goals/bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockGoalRepository goalRepository;
  late MockEnvelopeRepository envelopeRepository;
  late MockTransactionRepository transactionRepository;

  final now = DateTime(2024);
  final testGoals = [
    Goal(
      id: 'goal-1',
      budgetId: 'budget-1',
      name: 'Emergency Fund',
      type: 'savings_target',
      targetAmount: 100000,
      currentAmount: 50000,
      createdAt: now,
      updatedAt: now,
    ),
    Goal(
      id: 'goal-2',
      budgetId: 'budget-1',
      name: 'Monthly Savings',
      type: 'monthly_contribution',
      monthlyContribution: 20000,
      currentAmount: 60000,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    goalRepository = MockGoalRepository();
    envelopeRepository = MockEnvelopeRepository();
    transactionRepository = MockTransactionRepository();
    when(
      () => envelopeRepository.watchAllocationsForEnvelope(any()),
    ).thenAnswer((_) => const Stream<List<EnvelopeAllocation>>.empty());
    when(
      () => transactionRepository.watchTransactions(
        budgetId: any(named: 'budgetId'),
      ),
    ).thenAnswer((_) => const Stream<List<Transaction>>.empty());
  });

  GoalsBloc buildBloc() {
    return GoalsBloc(
      goalRepository: goalRepository,
      envelopeRepository: envelopeRepository,
      transactionRepository: transactionRepository,
      budgetId: 'budget-1',
    );
  }

  group('GoalsBloc', () {
    blocTest<GoalsBloc, GoalsState>(
      'emits [loading, loaded] when GoalsStarted is added',
      build: () {
        when(
          () => goalRepository.watchGoals('budget-1'),
        ).thenAnswer((_) => Stream.value(testGoals));
        when(
          () => goalRepository.refreshGoals('budget-1'),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GoalsStarted()),
      expect: () => [
        const GoalsState(status: GoalsStatus.loading),
        GoalsState(
          status: GoalsStatus.loaded,
          goals: testGoals,
        ),
      ],
      verify: (_) {
        verify(() => goalRepository.watchGoals('budget-1')).called(1);
        verify(() => goalRepository.refreshGoals('budget-1')).called(1);
      },
    );

    blocTest<GoalsBloc, GoalsState>(
      'still loads from local stream when refresh fails',
      build: () {
        when(
          () => goalRepository.watchGoals('budget-1'),
        ).thenAnswer((_) => Stream.value(testGoals));
        when(
          () => goalRepository.refreshGoals('budget-1'),
        ).thenThrow(const GoalException('Network error'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GoalsStarted()),
      expect: () => [
        const GoalsState(status: GoalsStatus.loading),
        GoalsState(
          status: GoalsStatus.loaded,
          goals: testGoals,
        ),
      ],
    );

    blocTest<GoalsBloc, GoalsState>(
      'completes goal when GoalCompleteToggled is added '
      'with non-completed goal',
      build: () {
        when(
          () => goalRepository.completeGoal('goal-1'),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(GoalCompleteToggled(testGoals.first)),
      verify: (_) {
        verify(() => goalRepository.completeGoal('goal-1')).called(1);
      },
    );

    blocTest<GoalsBloc, GoalsState>(
      'uncompletes goal when GoalCompleteToggled is added '
      'with completed goal',
      build: () {
        when(
          () => goalRepository.uncompleteGoal('goal-1'),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        GoalCompleteToggled(
          testGoals.first.copyWith(isCompleted: true),
        ),
      ),
      verify: (_) {
        verify(() => goalRepository.uncompleteGoal('goal-1')).called(1);
      },
    );

    blocTest<GoalsBloc, GoalsState>(
      'emits error then loaded when complete toggle fails',
      build: () {
        when(
          () => goalRepository.completeGoal('goal-1'),
        ).thenThrow(const GoalException('Failed'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(GoalCompleteToggled(testGoals.first)),
      expect: () => [
        const GoalsState(
          status: GoalsStatus.error,
          error: GoalsError.updateFailed,
        ),
        const GoalsState(status: GoalsStatus.loaded),
      ],
    );

    blocTest<GoalsBloc, GoalsState>(
      'emits error then loaded when delete fails',
      build: () {
        when(
          () => goalRepository.deleteGoal('goal-1'),
        ).thenThrow(const GoalException('Failed'));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GoalDeleted('goal-1')),
      expect: () => [
        const GoalsState(
          status: GoalsStatus.error,
          error: GoalsError.deleteFailed,
        ),
        const GoalsState(status: GoalsStatus.loaded),
      ],
    );

    blocTest<GoalsBloc, GoalsState>(
      'deletes goal when GoalDeleted is added',
      build: () {
        when(
          () => goalRepository.deleteGoal('goal-1'),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GoalDeleted('goal-1')),
      verify: (_) {
        verify(() => goalRepository.deleteGoal('goal-1')).called(1);
      },
    );

    blocTest<GoalsBloc, GoalsState>(
      'refreshes goals when GoalsRefreshRequested is added',
      build: () {
        when(
          () => goalRepository.refreshGoals('budget-1'),
        ).thenAnswer((_) async {});
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GoalsRefreshRequested()),
      verify: (_) {
        verify(() => goalRepository.refreshGoals('budget-1')).called(1);
      },
    );

    blocTest<GoalsBloc, GoalsState>(
      'computes amounts from envelope-keyed allocation stream',
      build: () {
        final linkedGoal = Goal(
          id: 'goal-3',
          budgetId: 'budget-1',
          name: 'Vacation',
          type: 'savings_target',
          envelopeId: 'env-1',
          targetAmount: 100000,
          createdAt: now,
          updatedAt: now,
        );
        when(
          () => goalRepository.watchGoals('budget-1'),
        ).thenAnswer((_) => Stream.value([linkedGoal]));
        when(
          () => goalRepository.refreshGoals('budget-1'),
        ).thenAnswer((_) async {});
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
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GoalsStarted()),
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        // (200-50) + (100-30) = 220
        expect(bloc.state.computedAmounts['goal-3'], 220);
      },
    );
  });
}
