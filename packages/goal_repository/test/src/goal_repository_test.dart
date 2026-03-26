import 'package:drift/drift.dart' show InsertMode;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:goal_repository/goal_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockEnvelopeApiClient extends Mock implements EnvelopeApiClient {}

class MockGoalsApiClient extends Mock implements GoalsApiClient {}

class MockAppDatabase extends Mock implements storage.AppDatabase {}

class MockGoalsDao extends Mock implements storage.GoalsDao {}

class FakeGoalDto extends Fake implements GoalDto {}

class FakeGoalsCompanion extends Fake implements storage.GoalsCompanion {}

void main() {
  late GoalRepository repository;
  late MockEnvelopeApiClient apiClient;
  late MockGoalsApiClient goalsApiClient;
  late MockAppDatabase localDatabase;
  late MockGoalsDao goalsDao;

  final now = DateTime(2024);
  final testGoalDto = GoalDto(
    id: 'goal-1',
    budgetId: 'budget-1',
    type: 'savings',
    name: 'Emergency Fund',
    envelopeId: 'env-1',
    targetAmount: 100000,
    targetDate: DateTime(2025),
    monthlyContribution: 5000,
    currentAmount: 25000,
    createdAt: now,
    updatedAt: now,
  );

  final testGoal = Goal(
    id: 'goal-1',
    budgetId: 'budget-1',
    type: 'savings',
    name: 'Emergency Fund',
    envelopeId: 'env-1',
    targetAmount: 100000,
    targetDate: DateTime(2025),
    monthlyContribution: 5000,
    currentAmount: 25000,
    createdAt: now,
    updatedAt: now,
  );

  final testLocalGoal = storage.Goal(
    id: 'goal-1',
    budgetId: 'budget-1',
    type: 'savings',
    name: 'Emergency Fund',
    envelopeId: 'env-1',
    accountId: null,
    targetAmount: 100000,
    targetDate: DateTime(2025),
    monthlyContribution: 5000,
    currentAmount: 25000,
    isCompleted: false,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeGoalDto());
    registerFallbackValue(FakeGoalsCompanion());
    registerFallbackValue(InsertMode.insert);
    registerFallbackValue(<storage.GoalsCompanion>[]);
  });

  setUp(() {
    apiClient = MockEnvelopeApiClient();
    goalsApiClient = MockGoalsApiClient();
    localDatabase = MockAppDatabase();
    goalsDao = MockGoalsDao();

    when(() => apiClient.goals).thenReturn(goalsApiClient);
    when(() => localDatabase.goalsDao).thenReturn(goalsDao);

    repository = GoalRepository(
      apiClient: apiClient,
      localDatabase: localDatabase,
    );
  });

  group('GoalRepository', () {
    group('createGoal', () {
      test('creates goal via API and caches locally', () async {
        when(() => goalsApiClient.createGoal(any()))
            .thenAnswer((_) async => testGoalDto);
        when(
          () => goalsDao.insertGoal(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createGoal(
          budgetId: 'budget-1',
          type: 'savings',
          name: 'Emergency Fund',
          envelopeId: 'env-1',
          targetAmount: 100000,
          targetDate: DateTime(2025),
          monthlyContribution: 5000,
        );

        expect(result.id, equals('goal-1'));
        expect(result.name, equals('Emergency Fund'));
        expect(result.targetAmount, equals(100000));
        verify(() => goalsApiClient.createGoal(any())).called(1);
        verify(
          () => goalsDao.insertGoal(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws GoalException on API failure', () async {
        when(() => goalsApiClient.createGoal(any()))
            .thenThrow(const EnvelopeApiException('Network error'));

        expect(
          () => repository.createGoal(
            budgetId: 'budget-1',
            type: 'savings',
            name: 'Emergency Fund',
          ),
          throwsA(isA<GoalException>()),
        );
      });
    });

    group('getGoal', () {
      test('returns from local storage when available', () async {
        when(() => goalsDao.getGoal('goal-1'))
            .thenAnswer((_) async => testLocalGoal);

        final result = await repository.getGoal('goal-1');

        expect(result.id, equals('goal-1'));
        expect(result.name, equals('Emergency Fund'));
        verifyNever(() => goalsApiClient.getGoal(any()));
      });

      test('falls back to API when not in local storage', () async {
        when(() => goalsDao.getGoal('goal-1'))
            .thenAnswer((_) async => null);
        when(() => goalsApiClient.getGoal('goal-1'))
            .thenAnswer((_) async => testGoalDto);
        when(
          () => goalsDao.insertGoal(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.getGoal('goal-1');

        expect(result.id, equals('goal-1'));
        verify(() => goalsApiClient.getGoal('goal-1')).called(1);
      });

      test('throws GoalException on API failure', () async {
        when(() => goalsDao.getGoal('goal-1'))
            .thenAnswer((_) async => null);
        when(() => goalsApiClient.getGoal('goal-1'))
            .thenThrow(const EnvelopeApiException('Not found'));

        expect(
          () => repository.getGoal('goal-1'),
          throwsA(isA<GoalException>()),
        );
      });
    });

    group('watchGoals', () {
      test('streams mapped goals from local storage', () {
        when(() => goalsDao.watchGoalsByBudgetId('budget-1'))
            .thenAnswer((_) => Stream.value([testLocalGoal]));

        final stream = repository.watchGoals('budget-1');

        expect(
          stream,
          emits(
            isA<List<Goal>>()
                .having((l) => l.length, 'length', 1)
                .having((l) => l.first.id, 'first id', 'goal-1'),
          ),
        );
      });

      test('emits empty list when no goals exist', () {
        when(() => goalsDao.watchGoalsByBudgetId('budget-1'))
            .thenAnswer((_) => Stream.value([]));

        final stream = repository.watchGoals('budget-1');

        expect(stream, emits(isEmpty));
      });

      test('wraps stream errors in GoalException', () {
        when(() => goalsDao.watchGoalsByBudgetId('budget-1'))
            .thenAnswer((_) => Stream.error(Exception('DB error')));

        final stream = repository.watchGoals('budget-1');

        expect(stream, emitsError(isA<GoalException>()));
      });
    });

    group('updateGoal', () {
      test('updates via API and caches locally', () async {
        when(() => goalsApiClient.updateGoal(any()))
            .thenAnswer((_) async => testGoalDto);
        when(
          () => goalsDao.insertGoal(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateGoal(testGoal);

        verify(() => goalsApiClient.updateGoal(any())).called(1);
        verify(
          () => goalsDao.insertGoal(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws GoalException on API failure', () async {
        when(() => goalsApiClient.updateGoal(any()))
            .thenThrow(const EnvelopeApiException('Update failed'));

        expect(
          () => repository.updateGoal(testGoal),
          throwsA(isA<GoalException>()),
        );
      });
    });

    group('deleteGoal', () {
      test('deletes from API and local storage', () async {
        when(() => goalsApiClient.deleteGoal('goal-1'))
            .thenAnswer((_) async {});
        when(() => goalsDao.deleteGoal('goal-1'))
            .thenAnswer((_) async => 1);

        await repository.deleteGoal('goal-1');

        verify(() => goalsApiClient.deleteGoal('goal-1')).called(1);
        verify(() => goalsDao.deleteGoal('goal-1')).called(1);
      });

      test('throws GoalException on API failure', () async {
        when(() => goalsApiClient.deleteGoal('goal-1'))
            .thenThrow(const EnvelopeApiException('Delete failed'));

        expect(
          () => repository.deleteGoal('goal-1'),
          throwsA(isA<GoalException>()),
        );
      });

      test('succeeds even if local delete fails', () async {
        when(() => goalsApiClient.deleteGoal('goal-1'))
            .thenAnswer((_) async {});
        when(() => goalsDao.deleteGoal('goal-1'))
            .thenThrow(Exception('DB error'));

        await repository.deleteGoal('goal-1');

        verify(() => goalsApiClient.deleteGoal('goal-1')).called(1);
      });
    });

    group('completeGoal', () {
      test('fetches goal and updates with isCompleted true', () async {
        when(() => goalsDao.getGoal('goal-1'))
            .thenAnswer((_) async => testLocalGoal);
        when(() => goalsApiClient.updateGoal(any()))
            .thenAnswer((_) async => testGoalDto);
        when(
          () => goalsDao.insertGoal(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.completeGoal('goal-1');

        final captured = verify(
          () => goalsApiClient.updateGoal(captureAny()),
        ).captured;
        final updatedDto = captured.first as GoalDto;
        expect(updatedDto.isCompleted, isTrue);
      });

      test('throws GoalException on failure', () async {
        when(() => goalsDao.getGoal('goal-1'))
            .thenAnswer((_) async => null);
        when(() => goalsApiClient.getGoal('goal-1'))
            .thenThrow(const EnvelopeApiException('Not found'));

        expect(
          () => repository.completeGoal('goal-1'),
          throwsA(isA<GoalException>()),
        );
      });
    });

    group('uncompleteGoal', () {
      test('fetches goal and updates with isCompleted false', () async {
        final completedLocalGoal = storage.Goal(
          id: 'goal-1',
          budgetId: 'budget-1',
          type: 'savings',
          name: 'Emergency Fund',
          envelopeId: 'env-1',
          accountId: null,
          targetAmount: 100000,
          targetDate: DateTime(2025),
          monthlyContribution: 5000,
          currentAmount: 25000,
          isCompleted: true,
          createdAt: now,
          updatedAt: now,
        );
        when(() => goalsDao.getGoal('goal-1'))
            .thenAnswer((_) async => completedLocalGoal);
        when(() => goalsApiClient.updateGoal(any()))
            .thenAnswer((_) async => testGoalDto);
        when(
          () => goalsDao.insertGoal(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.uncompleteGoal('goal-1');

        final captured = verify(
          () => goalsApiClient.updateGoal(captureAny()),
        ).captured;
        final updatedDto = captured.first as GoalDto;
        expect(updatedDto.isCompleted, isFalse);
      });

      test('throws GoalException on failure', () async {
        when(() => goalsDao.getGoal('goal-1'))
            .thenAnswer((_) async => null);
        when(() => goalsApiClient.getGoal('goal-1'))
            .thenThrow(const EnvelopeApiException('Not found'));

        expect(
          () => repository.uncompleteGoal('goal-1'),
          throwsA(isA<GoalException>()),
        );
      });
    });

    group('refreshGoals', () {
      test('fetches from API and batch-caches all goals', () async {
        when(() => goalsApiClient.getGoalsByBudget('budget-1'))
            .thenAnswer((_) async => [testGoalDto]);
        when(
          () => goalsDao.batchInsertGoals(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshGoals('budget-1');

        verify(
          () => goalsApiClient.getGoalsByBudget('budget-1'),
        ).called(1);
        verify(
          () => goalsDao.batchInsertGoals(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('handles empty list from API', () async {
        when(() => goalsApiClient.getGoalsByBudget('budget-1'))
            .thenAnswer((_) async => []);
        when(
          () => goalsDao.batchInsertGoals(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshGoals('budget-1');

        verify(
          () => goalsDao.batchInsertGoals(
            [],
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws GoalException on API failure', () async {
        when(() => goalsApiClient.getGoalsByBudget('budget-1'))
            .thenThrow(const EnvelopeApiException('Network error'));

        expect(
          () => repository.refreshGoals('budget-1'),
          throwsA(isA<GoalException>()),
        );
      });
    });
  });

  group('GoalException', () {
    test('toString includes error details when present', () {
      const exception = GoalException(
        'Failed',
        error: EnvelopeApiException('Network timeout'),
      );

      expect(
        exception.toString(),
        contains('EnvelopeApiException: Network timeout'),
      );
    });

    test('toString omits error when null', () {
      const exception = GoalException('Failed');

      expect(exception.toString(), equals('GoalException: Failed'));
    });
  });
}
