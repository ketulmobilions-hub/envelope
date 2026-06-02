import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockBudgetRepository extends Mock implements BudgetRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _MockGoalRepository extends Mock implements GoalRepository {}

class _FakeEnvelopeAllocation extends Fake implements EnvelopeAllocation {}

void main() {
  late _MockBudgetRepository budgetRepository;
  late _MockEnvelopeRepository envelopeRepository;
  late _MockGoalRepository goalRepository;

  final now = DateTime(2026, 5, 15);
  DateTime fixedNow() => now;

  final period = BudgetPeriod(
    id: 'period-1',
    budgetId: 'budget-1',
    startDate: DateTime(2026, 5),
    endDate: DateTime(2026, 6),
    createdAt: now,
  );

  Goal goal({
    required String id,
    String? envelopeId,
    int sortOrder = 0,
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
  }) => Goal(
    id: id,
    budgetId: 'budget-1',
    type: 'savings_target',
    name: 'Goal $id',
    envelopeId: envelopeId,
    sortOrder: sortOrder,
    targetAmount: targetAmount,
    targetDate: targetDate,
    monthlyContribution: monthlyContribution,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(_FakeEnvelopeAllocation());
  });

  setUp(() {
    budgetRepository = _MockBudgetRepository();
    envelopeRepository = _MockEnvelopeRepository();
    goalRepository = _MockGoalRepository();
  });

  AutoAssignCubit build() => AutoAssignCubit(
    budgetRepository: budgetRepository,
    envelopeRepository: envelopeRepository,
    goalRepository: goalRepository,
    budgetId: 'budget-1',
    now: fixedNow,
  );

  void stubPeriods() {
    when(
      () => budgetRepository.watchBudgetPeriods('budget-1'),
    ).thenAnswer((_) => Stream.value([period]));
  }

  group('AutoAssignCubit.plan', () {
    blocTest<AutoAssignCubit, AutoAssignState>(
      'emits insufficientRta when RTA is zero',
      setUp: () {
        stubPeriods();
        when(
          () => budgetRepository.calculateReadyToAssign('period-1'),
        ).thenAnswer((_) async => 0);
        when(
          () => goalRepository.watchGoals('budget-1'),
        ).thenAnswer((_) => Stream.value(const <Goal>[]));
      },
      build: build,
      act: (cubit) => cubit.plan(),
      expect: () => [
        const AutoAssignState(status: AutoAssignStatus.planning),
        const AutoAssignState(status: AutoAssignStatus.insufficientRta),
      ],
    );

    blocTest<AutoAssignCubit, AutoAssignState>(
      'emits noTargets when goals have no monthly need',
      setUp: () {
        stubPeriods();
        when(
          () => budgetRepository.calculateReadyToAssign('period-1'),
        ).thenAnswer((_) async => 50000);
        when(
          () => goalRepository.watchGoals('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([
            goal(id: 'g1', envelopeId: 'env-1'), // no targetAmount → 0 need
          ]),
        );
        when(
          () => envelopeRepository.watchAllocations('period-1'),
        ).thenAnswer((_) => Stream.value(const <EnvelopeAllocation>[]));
      },
      build: build,
      act: (cubit) => cubit.plan(),
      verify: (cubit) {
        expect(cubit.state.status, AutoAssignStatus.noTargets);
        expect(cubit.state.rtaCents, 50000);
      },
    );

    blocTest<AutoAssignCubit, AutoAssignState>(
      'apply: updates existing envelope allocation cumulatively',
      seed: () => AutoAssignState(
        status: AutoAssignStatus.preview,
        periodId: 'period-1',
        rtaCents: 25000,
        actions: [
          AutoAssignAction.envelope(
            goal: goal(id: 'g1', envelopeId: 'env-a'),
            envelopeId: 'env-a',
            addCents: 10000,
          ),
          AutoAssignAction.contribution(
            goal: goal(id: 'g2'),
            addCents: 5000,
          ),
        ],
      ),
      setUp: () {
        when(
          () => envelopeRepository.watchAllocations('period-1'),
        ).thenAnswer(
          (_) => Stream.value([
            EnvelopeAllocation(
              id: 'alloc-1',
              envelopeId: 'env-a',
              budgetPeriodId: 'period-1',
              allocatedAmount: 2000,
              createdAt: now,
            ),
          ]),
        );
        when(
          () => envelopeRepository.updateAllocation(any()),
        ).thenAnswer((_) async {});
        when(
          () => goalRepository.addContribution(
            goalId: 'g2',
            amountCents: 5000,
          ),
        ).thenAnswer(
          (_) async => GoalContribution(
            id: 'c1',
            goalId: 'g2',
            amountCents: 5000,
            createdAt: now,
          ),
        );
      },
      build: build,
      act: (cubit) => cubit.apply(),
      verify: (cubit) {
        expect(cubit.state.status, AutoAssignStatus.success);
        final captured = verify(
          () => envelopeRepository.updateAllocation(captureAny()),
        ).captured;
        expect(captured, hasLength(1));
        expect((captured.first as EnvelopeAllocation).allocatedAmount, 12000);
        verify(
          () => goalRepository.addContribution(
            goalId: 'g2',
            amountCents: 5000,
          ),
        ).called(1);
      },
    );

    blocTest<AutoAssignCubit, AutoAssignState>(
      'apply: reports failure when an action throws',
      seed: () => AutoAssignState(
        status: AutoAssignStatus.preview,
        periodId: 'period-1',
        actions: [
          AutoAssignAction.envelope(
            goal: goal(id: 'g1', envelopeId: 'env-a'),
            envelopeId: 'env-a',
            addCents: 10000,
          ),
        ],
      ),
      setUp: () {
        when(
          () => envelopeRepository.watchAllocations('period-1'),
        ).thenAnswer((_) => Stream.value(const <EnvelopeAllocation>[]));
        when(
          () => envelopeRepository.allocate(
            envelopeId: any(named: 'envelopeId'),
            budgetPeriodId: any(named: 'budgetPeriodId'),
            amount: any(named: 'amount'),
          ),
        ).thenThrow(const EnvelopeException('boom'));
      },
      build: build,
      act: (cubit) => cubit.apply(),
      verify: (cubit) {
        expect(cubit.state.status, AutoAssignStatus.failure);
        expect(cubit.state.errorMessage, contains('1 of 1'));
      },
    );

    blocTest<AutoAssignCubit, AutoAssignState>(
      'emits preview with actions sorted by sortOrder',
      setUp: () {
        stubPeriods();
        when(
          () => budgetRepository.calculateReadyToAssign('period-1'),
        ).thenAnswer((_) async => 25000);
        when(() => goalRepository.watchGoals('budget-1')).thenAnswer(
          (_) => Stream.value([
            goal(
              id: 'g-second',
              envelopeId: 'env-b',
              sortOrder: 1,
              targetAmount: 90000,
              targetDate: DateTime(2026, 11),
            ),
            goal(
              id: 'g-first',
              envelopeId: 'env-a',
              sortOrder: 0,
              targetAmount: 90000,
              targetDate: DateTime(2026, 11),
            ),
          ]),
        );
        when(
          () => envelopeRepository.watchAllocations('period-1'),
        ).thenAnswer((_) => Stream.value(const <EnvelopeAllocation>[]));
      },
      build: build,
      act: (cubit) => cubit.plan(),
      verify: (cubit) {
        expect(cubit.state.status, AutoAssignStatus.preview);
        // 90000 / 6 months = 15000 each. RTA 25000 → first gets 15000, second
        // gets 10000.
        expect(cubit.state.actions, hasLength(2));
        expect(cubit.state.actions[0].goal.id, 'g-first');
        expect(cubit.state.actions[0].addCents, 15000);
        expect(cubit.state.actions[1].goal.id, 'g-second');
        expect(cubit.state.actions[1].addCents, 10000);
        expect(cubit.state.totalAllocatedCents, 25000);
      },
    );
  });
}
