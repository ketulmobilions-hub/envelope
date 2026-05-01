import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockGoalRepository extends Mock implements GoalRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _FakeGoal extends Fake implements Goal {}

void main() {
  late _MockGoalRepository goalRepository;
  late _MockEnvelopeRepository envelopeRepository;

  final now = DateTime(2024);
  const budgetId = 'budget-1';

  final envelopes = [
    Envelope(
      id: 'env-1',
      categoryGroupId: 'group-1',
      budgetId: budgetId,
      name: 'Groceries',
      createdAt: now,
    ),
    Envelope(
      id: 'env-2',
      categoryGroupId: 'group-1',
      budgetId: budgetId,
      name: 'Rent',
      createdAt: now,
    ),
  ];

  final existingGoal = Goal(
    id: 'goal-1',
    budgetId: budgetId,
    type: 'savings_target',
    name: 'Vacation',
    envelopeId: 'env-1',
    targetAmount: 100000,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(_FakeGoal());
  });

  setUp(() {
    goalRepository = _MockGoalRepository();
    envelopeRepository = _MockEnvelopeRepository();
    when(
      () => envelopeRepository.watchEnvelopes(budgetId),
    ).thenAnswer((_) => Stream.value(envelopes));
  });

  GoalFormCubit build({Goal? goal}) {
    return GoalFormCubit(
      goalRepository: goalRepository,
      envelopeRepository: envelopeRepository,
      budgetId: budgetId,
      goal: goal,
    );
  }

  group('GoalFormCubit', () {
    test('initial state has null envelopeId on create', () {
      final cubit = build();
      expect(cubit.state.envelopeId, isNull);
      expect(cubit.state.envelopesLoading, isTrue);
    });

    test('initial state seeds envelopeId from goal on edit', () {
      final cubit = build(goal: existingGoal);
      expect(cubit.state.envelopeId, 'env-1');
    });

    blocTest<GoalFormCubit, GoalFormState>(
      'emits envelopes from watchEnvelopes stream',
      build: build,
      wait: const Duration(milliseconds: 10),
      verify: (cubit) {
        expect(cubit.state.envelopes, envelopes);
        expect(cubit.state.envelopesLoading, isFalse);
      },
    );

    blocTest<GoalFormCubit, GoalFormState>(
      'envelopeChanged updates envelopeId',
      build: build,
      act: (cubit) => cubit.envelopeChanged('env-2'),
      skip: 1,
      verify: (cubit) {
        expect(cubit.state.envelopeId, 'env-2');
      },
    );

    blocTest<GoalFormCubit, GoalFormState>(
      'envelopeChanged with null clears envelopeId',
      build: () => build(goal: existingGoal),
      act: (cubit) => cubit.envelopeChanged(null),
      skip: 1,
      verify: (cubit) {
        expect(cubit.state.envelopeId, isNull);
      },
    );

    blocTest<GoalFormCubit, GoalFormState>(
      'submit on create passes envelopeId from state',
      build: () {
        when(
          () => goalRepository.createGoal(
            budgetId: any(named: 'budgetId'),
            type: any(named: 'type'),
            name: any(named: 'name'),
            envelopeId: any(named: 'envelopeId'),
            accountId: any(named: 'accountId'),
            targetAmount: any(named: 'targetAmount'),
            targetDate: any(named: 'targetDate'),
            monthlyContribution: any(named: 'monthlyContribution'),
          ),
        ).thenAnswer((_) async => existingGoal);
        return build();
      },
      act: (cubit) async {
        cubit.envelopeChanged('env-2');
        await cubit.submit(
          name: 'Vacation',
          type: 'savings_target',
          targetAmount: 100000,
        );
      },
      verify: (_) {
        verify(
          () => goalRepository.createGoal(
            budgetId: budgetId,
            type: 'savings_target',
            name: 'Vacation',
            envelopeId: 'env-2',
            targetAmount: 100000,
          ),
        ).called(1);
      },
    );

    blocTest<GoalFormCubit, GoalFormState>(
      'submit on edit calls updateGoal with new envelopeId',
      build: () {
        when(
          () => goalRepository.updateGoal(any()),
        ).thenAnswer((_) async {});
        return build(goal: existingGoal);
      },
      act: (cubit) async {
        cubit.envelopeChanged('env-2');
        await cubit.submit(
          name: existingGoal.name,
          type: existingGoal.type,
          targetAmount: existingGoal.targetAmount,
        );
      },
      verify: (_) {
        final captured =
            verify(() => goalRepository.updateGoal(captureAny())).captured;
        expect(captured, hasLength(1));
        expect((captured.single as Goal).envelopeId, 'env-2');
      },
    );

    blocTest<GoalFormCubit, GoalFormState>(
      'submit on edit can clear envelopeId to null',
      build: () {
        when(
          () => goalRepository.updateGoal(any()),
        ).thenAnswer((_) async {});
        return build(goal: existingGoal);
      },
      act: (cubit) async {
        cubit.envelopeChanged(null);
        await cubit.submit(
          name: existingGoal.name,
          type: existingGoal.type,
          targetAmount: existingGoal.targetAmount,
        );
      },
      verify: (_) {
        final captured =
            verify(() => goalRepository.updateGoal(captureAny())).captured;
        expect((captured.single as Goal).envelopeId, isNull);
      },
    );
  });
}
