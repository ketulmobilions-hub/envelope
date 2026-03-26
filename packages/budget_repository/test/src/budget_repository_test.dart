import 'package:budget_repository/budget_repository.dart';
import 'package:drift/drift.dart' show InsertMode;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    as storage;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockEnvelopeApiClient extends Mock implements EnvelopeApiClient {}

class MockBudgetsApiClient extends Mock implements BudgetsApiClient {}

class MockEnvelopesApiClient extends Mock implements EnvelopesApiClient {}

class MockAppDatabase extends Mock implements storage.AppDatabase {}

class MockBudgetsDao extends Mock implements storage.BudgetsDao {}

class MockEnvelopesDao extends Mock implements storage.EnvelopesDao {}

class FakeBudgetDto extends Fake implements BudgetDto {}

class FakeBudgetPeriodDto extends Fake implements BudgetPeriodDto {}

class FakeAllocationTemplateDto extends Fake
    implements AllocationTemplateDto {}

class FakeAllocationTemplateItemDto extends Fake
    implements AllocationTemplateItemDto {}

class FakeEnvelopeAllocationDto extends Fake
    implements EnvelopeAllocationDto {}

class FakeBudgetsCompanion extends Fake
    implements storage.BudgetsCompanion {}

class FakeBudgetPeriodsCompanion extends Fake
    implements storage.BudgetPeriodsCompanion {}

class FakeAllocationTemplatesCompanion extends Fake
    implements storage.AllocationTemplatesCompanion {}

class FakeAllocationTemplateItemsCompanion extends Fake
    implements storage.AllocationTemplateItemsCompanion {}

class FakeEnvelopeAllocationsCompanion extends Fake
    implements storage.EnvelopeAllocationsCompanion {}

void main() {
  late BudgetRepository repository;
  late MockEnvelopeApiClient apiClient;
  late MockBudgetsApiClient budgetsApiClient;
  late MockEnvelopesApiClient envelopesApiClient;
  late MockAppDatabase localDatabase;
  late MockBudgetsDao budgetsDao;
  late MockEnvelopesDao envelopesDao;

  final now = DateTime(2024);

  // --- Test fixtures ---

  final testBudgetDto = BudgetDto(
    id: 'budget-1',
    ownerId: 'owner-1',
    name: 'My Budget',
    baseCurrency: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  final testBudget = Budget(
    id: 'budget-1',
    ownerId: 'owner-1',
    name: 'My Budget',
    baseCurrency: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  final testLocalBudget = storage.Budget(
    id: 'budget-1',
    ownerId: 'owner-1',
    name: 'My Budget',
    baseCurrency: 'USD',
    periodType: 'monthly',
    periodStartDay: 1,
    isArchived: false,
    createdAt: now,
    updatedAt: now,
  );

  final testBudgetPeriodDto = BudgetPeriodDto(
    id: 'period-1',
    budgetId: 'budget-1',
    startDate: DateTime(2024),
    endDate: DateTime(2024, 1, 31),
    createdAt: now,
  );

  final testLocalBudgetPeriod = storage.BudgetPeriod(
    id: 'period-1',
    budgetId: 'budget-1',
    startDate: DateTime(2024),
    endDate: DateTime(2024, 1, 31),
    totalIncome: 500000,
    totalAllocated: 300000,
    isClosed: false,
    createdAt: now,
  );



  final testLocalAllocation = storage.EnvelopeAllocation(
    id: 'alloc-1',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-1',
    allocatedAmount: 100000,
    spentAmount: 25000,
    rolloverAmount: 5000,
    createdAt: now,
  );

  final testTemplateDto = AllocationTemplateDto(
    id: 'tmpl-1',
    budgetId: 'budget-1',
    name: 'Standard Split',
    createdAt: now,
  );

  const testTemplateItemDto = AllocationTemplateItemDto(
    id: 'item-1',
    templateId: 'tmpl-1',
    envelopeId: 'env-1',
    percentage: 50,
  );

  const testTemplateItemDto2 = AllocationTemplateItemDto(
    id: 'item-2',
    templateId: 'tmpl-1',
    envelopeId: 'env-2',
    percentage: 50,
  );

  final testLocalTemplate = storage.AllocationTemplate(
    id: 'tmpl-1',
    budgetId: 'budget-1',
    name: 'Standard Split',
    createdAt: now,
  );

  const testLocalTemplateItem = storage.AllocationTemplateItem(
    id: 'item-1',
    templateId: 'tmpl-1',
    envelopeId: 'env-1',
    percentage: 50,
  );

  setUpAll(() {
    registerFallbackValue(FakeBudgetDto());
    registerFallbackValue(FakeBudgetPeriodDto());
    registerFallbackValue(FakeAllocationTemplateDto());
    registerFallbackValue(FakeAllocationTemplateItemDto());
    registerFallbackValue(FakeEnvelopeAllocationDto());
    registerFallbackValue(FakeBudgetsCompanion());
    registerFallbackValue(FakeBudgetPeriodsCompanion());
    registerFallbackValue(FakeAllocationTemplatesCompanion());
    registerFallbackValue(FakeAllocationTemplateItemsCompanion());
    registerFallbackValue(FakeEnvelopeAllocationsCompanion());
    registerFallbackValue(InsertMode.insert);
    registerFallbackValue(<storage.BudgetsCompanion>[]);
    registerFallbackValue(<storage.BudgetPeriodsCompanion>[]);
    registerFallbackValue(<storage.AllocationTemplatesCompanion>[]);
    registerFallbackValue(<storage.AllocationTemplateItemsCompanion>[]);
  });

  setUp(() {
    apiClient = MockEnvelopeApiClient();
    budgetsApiClient = MockBudgetsApiClient();
    envelopesApiClient = MockEnvelopesApiClient();
    localDatabase = MockAppDatabase();
    budgetsDao = MockBudgetsDao();
    envelopesDao = MockEnvelopesDao();

    when(() => apiClient.budgets).thenReturn(budgetsApiClient);
    when(() => apiClient.envelopes).thenReturn(envelopesApiClient);
    when(() => localDatabase.budgetsDao).thenReturn(budgetsDao);
    when(() => localDatabase.envelopesDao).thenReturn(envelopesDao);

    repository = BudgetRepository(
      apiClient: apiClient,
      localDatabase: localDatabase,
    );
  });

  group('BudgetRepository', () {
    // -----------------------------------------------------------------
    // Budget CRUD
    // -----------------------------------------------------------------
    group('createBudget', () {
      test('creates via API, caches, and returns model', () async {
        when(() => budgetsApiClient.createBudget(any()))
            .thenAnswer((_) async => testBudgetDto);
        when(
          () => budgetsDao.insertBudget(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createBudget(
          name: 'My Budget',
          baseCurrency: 'USD',
          ownerId: 'owner-1',
        );

        expect(result.id, equals('budget-1'));
        expect(result.name, equals('My Budget'));
        verify(() => budgetsApiClient.createBudget(any())).called(1);
        verify(
          () => budgetsDao.insertBudget(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsApiClient.createBudget(any()))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.createBudget(
            name: 'My Budget',
            baseCurrency: 'USD',
            ownerId: 'owner-1',
          ),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('getBudget', () {
      test('returns from local storage when available', () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => testLocalBudget);

        final result = await repository.getBudget('budget-1');

        expect(result.id, equals('budget-1'));
        verifyNever(() => budgetsApiClient.getBudget(any()));
      });

      test('falls back to API when not in local storage', () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => null);
        when(() => budgetsApiClient.getBudget('budget-1'))
            .thenAnswer((_) async => testBudgetDto);
        when(
          () => budgetsDao.insertBudget(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.getBudget('budget-1');

        expect(result.id, equals('budget-1'));
        verify(() => budgetsApiClient.getBudget('budget-1')).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => null);
        when(() => budgetsApiClient.getBudget('budget-1'))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.getBudget('budget-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('watchBudgets', () {
      test('streams budgets filtered by ownerId', () {
        when(() => budgetsDao.watchBudgetsByOwnerId('owner-1'))
            .thenAnswer(
          (_) => Stream.value([testLocalBudget]),
        );

        final stream = repository.watchBudgets('owner-1');

        expect(
          stream,
          emits(
            isA<List<Budget>>()
                .having((l) => l.length, 'length', 1)
                .having((l) => l.first.id, 'first.id', 'budget-1'),
          ),
        );
      });
    });

    group('updateBudget', () {
      test('updates via API and caches locally', () async {
        when(() => budgetsApiClient.updateBudget(any()))
            .thenAnswer((_) async => testBudgetDto);
        when(
          () => budgetsDao.insertBudget(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateBudget(testBudget);

        verify(() => budgetsApiClient.updateBudget(any())).called(1);
        verify(
          () => budgetsDao.insertBudget(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsApiClient.updateBudget(any()))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.updateBudget(testBudget),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('deleteBudget', () {
      test('deletes from API and cleans up local cache', () async {
        when(() => budgetsApiClient.deleteBudget('budget-1'))
            .thenAnswer((_) async {});
        when(() => budgetsDao.deleteBudget('budget-1'))
            .thenAnswer((_) async => 1);

        await repository.deleteBudget('budget-1');

        verify(() => budgetsApiClient.deleteBudget('budget-1'))
            .called(1);
        verify(() => budgetsDao.deleteBudget('budget-1')).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsApiClient.deleteBudget('budget-1'))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.deleteBudget('budget-1'),
          throwsA(isA<BudgetException>()),
        );
      });

      test('succeeds even when local cleanup fails', () async {
        when(() => budgetsApiClient.deleteBudget('budget-1'))
            .thenAnswer((_) async {});
        when(() => budgetsDao.deleteBudget('budget-1'))
            .thenThrow(Exception('local error'));

        await repository.deleteBudget('budget-1');

        verify(() => budgetsApiClient.deleteBudget('budget-1'))
            .called(1);
      });
    });

    group('archiveBudget', () {
      test('sets isArchived to true and updatedAt', () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => testLocalBudget);
        when(() => budgetsApiClient.updateBudget(any()))
            .thenAnswer((inv) async {
          return inv.positionalArguments.first as BudgetDto;
        });
        when(
          () => budgetsDao.insertBudget(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.archiveBudget('budget-1');

        final captured = verify(
          () => budgetsApiClient.updateBudget(captureAny()),
        ).captured.single as BudgetDto;
        expect(captured.isArchived, isTrue);
        // updatedAt should be newer than original.
        expect(captured.updatedAt.isAfter(now), isTrue);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => testLocalBudget);
        when(() => budgetsApiClient.updateBudget(any()))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.archiveBudget('budget-1'),
          throwsA(isA<BudgetException>()),
        );
      });

      test('throws BudgetException when budget not found', () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => null);
        when(() => budgetsApiClient.getBudget('budget-1'))
            .thenThrow(const EnvelopeApiException('not found'));

        expect(
          () => repository.archiveBudget('budget-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('refreshBudgets', () {
      test('fetches from API and batch caches all', () async {
        when(() => budgetsApiClient.getBudgetsByOwner('owner-1'))
            .thenAnswer((_) async => [testBudgetDto]);
        when(
          () => budgetsDao.batchInsertBudgets(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshBudgets('owner-1');

        verify(() => budgetsApiClient.getBudgetsByOwner('owner-1'))
            .called(1);
        verify(
          () => budgetsDao.batchInsertBudgets(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsApiClient.getBudgetsByOwner('owner-1'))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.refreshBudgets('owner-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    // -----------------------------------------------------------------
    // Budget Periods
    // -----------------------------------------------------------------
    group('createBudgetPeriod', () {
      test('creates via API, caches, and returns model', () async {
        when(() => budgetsApiClient.createBudgetPeriod(any()))
            .thenAnswer((_) async => testBudgetPeriodDto);
        when(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createBudgetPeriod(
          budgetId: 'budget-1',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
        );

        expect(result.id, equals('period-1'));
        expect(result.budgetId, equals('budget-1'));
        verify(() => budgetsApiClient.createBudgetPeriod(any()))
            .called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsApiClient.createBudgetPeriod(any()))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.createBudgetPeriod(
            budgetId: 'budget-1',
            startDate: DateTime(2024),
            endDate: DateTime(2024, 1, 31),
          ),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('watchBudgetPeriods', () {
      test('streams from local storage mapped to domain models', () {
        when(() => budgetsDao.watchPeriodsByBudgetId('budget-1'))
            .thenAnswer(
          (_) => Stream.value([testLocalBudgetPeriod]),
        );

        final stream = repository.watchBudgetPeriods('budget-1');

        expect(
          stream,
          emits(
            isA<List<BudgetPeriod>>()
                .having((l) => l.length, 'length', 1)
                .having(
                  (l) => l.first.id,
                  'first.id',
                  'period-1',
                ),
          ),
        );
      });
    });

    group('closeBudgetPeriod', () {
      test('closes via API and caches result', () async {
        final closedDto = testBudgetPeriodDto.copyWith(isClosed: true);
        when(() => budgetsApiClient.closeBudgetPeriod('period-1'))
            .thenAnswer((_) async => closedDto);
        when(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.closeBudgetPeriod('period-1');

        verify(() => budgetsApiClient.closeBudgetPeriod('period-1'))
            .called(1);
        verify(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsApiClient.closeBudgetPeriod('period-1'))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.closeBudgetPeriod('period-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('refreshBudgetPeriods', () {
      test('fetches from API and batch caches all', () async {
        when(() => budgetsApiClient.getBudgetPeriods('budget-1'))
            .thenAnswer((_) async => [testBudgetPeriodDto]);
        when(
          () => budgetsDao.batchInsertBudgetPeriods(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshBudgetPeriods('budget-1');

        verify(() => budgetsApiClient.getBudgetPeriods('budget-1'))
            .called(1);
        verify(
          () => budgetsDao.batchInsertBudgetPeriods(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => budgetsApiClient.getBudgetPeriods('budget-1'))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.refreshBudgetPeriods('budget-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('autoCreateNextPeriod', () {
      test('creates next period based on latest existing period',
          () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => testLocalBudget);
        when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
            .thenAnswer((_) async => [testLocalBudgetPeriod]);
        when(() => budgetsApiClient.createBudgetPeriod(any()))
            .thenAnswer((inv) async {
          final dto =
              inv.positionalArguments.first as BudgetPeriodDto;
          return dto.copyWith(id: 'period-2');
        });
        when(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result =
            await repository.autoCreateNextPeriod('budget-1');

        expect(result.id, equals('period-2'));
        // Start date should be day after previous end date.
        expect(
          result.startDate,
          equals(DateTime(2024, 2)),
        );
      });

      test('creates first period when no periods exist', () async {
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => testLocalBudget);
        when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
            .thenAnswer((_) async => []);
        when(() => budgetsApiClient.createBudgetPeriod(any()))
            .thenAnswer((inv) async {
          final dto =
              inv.positionalArguments.first as BudgetPeriodDto;
          return dto.copyWith(id: 'period-1');
        });
        when(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result =
            await repository.autoCreateNextPeriod('budget-1');

        expect(result.id, equals('period-1'));
        verify(() => budgetsApiClient.createBudgetPeriod(any()))
            .called(1);
      });

      test('handles weekly period type', () async {
        final weeklyBudget = storage.Budget(
          id: 'budget-1',
          ownerId: 'owner-1',
          name: 'Weekly Budget',
          baseCurrency: 'USD',
          periodType: 'weekly',
          periodStartDay: 1,
          isArchived: false,
          createdAt: now,
          updatedAt: now,
        );
        final weeklyPeriod = storage.BudgetPeriod(
          id: 'period-1',
          budgetId: 'budget-1',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 7),
          totalIncome: 0,
          totalAllocated: 0,
          isClosed: false,
          createdAt: now,
        );
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => weeklyBudget);
        when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
            .thenAnswer((_) async => [weeklyPeriod]);
        when(() => budgetsApiClient.createBudgetPeriod(any()))
            .thenAnswer((inv) async {
          final dto =
              inv.positionalArguments.first as BudgetPeriodDto;
          return dto.copyWith(id: 'period-2');
        });
        when(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result =
            await repository.autoCreateNextPeriod('budget-1');

        // Weekly: start = Jan 8, end = Jan 14
        expect(result.startDate, equals(DateTime(2024, 1, 8)));
        expect(result.endDate, equals(DateTime(2024, 1, 14)));
      });

      test('clamps periodStartDay to last day of month', () async {
        // Budget with periodStartDay=31 in February
        final budget31 = storage.Budget(
          id: 'budget-1',
          ownerId: 'owner-1',
          name: 'Budget',
          baseCurrency: 'USD',
          periodType: 'monthly',
          periodStartDay: 31,
          isArchived: false,
          createdAt: now,
          updatedAt: now,
        );
        // Existing period ends Jan 30
        final janPeriod = storage.BudgetPeriod(
          id: 'period-1',
          budgetId: 'budget-1',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 30),
          totalIncome: 0,
          totalAllocated: 0,
          isClosed: false,
          createdAt: now,
        );
        when(() => budgetsDao.getBudget('budget-1'))
            .thenAnswer((_) async => budget31);
        when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
            .thenAnswer((_) async => [janPeriod]);
        when(() => budgetsApiClient.createBudgetPeriod(any()))
            .thenAnswer((inv) async {
          final dto =
              inv.positionalArguments.first as BudgetPeriodDto;
          return dto.copyWith(id: 'period-2');
        });
        when(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result =
            await repository.autoCreateNextPeriod('budget-1');

        // Start date = Jan 31 (day after Jan 30 end)
        expect(result.startDate, equals(DateTime(2024, 1, 31)));
        // End date: _addPeriod(Jan 31, monthly) clamps to Feb 29,
        // then subtract 1 day = Feb 28
        expect(result.endDate, equals(DateTime(2024, 2, 28)));
      });
    });

    // -----------------------------------------------------------------
    // Budget-Level Allocation Operations
    // -----------------------------------------------------------------
    group('calculateReadyToAssign', () {
      test('computes totalIncome - totalAllocated + rollovers',
          () async {
        when(() => budgetsDao.getBudgetPeriod('period-1'))
            .thenAnswer((_) async => testLocalBudgetPeriod);
        when(() => envelopesDao.getAllocationsByPeriodId('period-1'))
            .thenAnswer((_) async => [testLocalAllocation]);

        final result =
            await repository.calculateReadyToAssign('period-1');

        // 500000 - 300000 + 5000 = 205000
        expect(result, equals(205000));
      });

      test('throws BudgetException when period not found', () async {
        when(() => budgetsDao.getBudgetPeriod('period-1'))
            .thenAnswer((_) async => null);

        expect(
          () => repository.calculateReadyToAssign('period-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('duplicateAllocations', () {
      test('copies allocated amounts with zeroed spent/rollover',
          () async {
        when(() => envelopesDao.getAllocationsByPeriodId('period-1'))
            .thenAnswer((_) async => [testLocalAllocation]);
        when(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).thenAnswer((inv) async {
          final dto =
              inv.positionalArguments.first as EnvelopeAllocationDto;
          return dto.copyWith(id: 'alloc-new');
        });
        when(
          () => envelopesDao.insertAllocation(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.duplicateAllocations(
          fromPeriodId: 'period-1',
          toPeriodId: 'period-2',
        );

        final captured = verify(
          () => envelopesApiClient
              .createEnvelopeAllocation(captureAny()),
        ).captured.single as EnvelopeAllocationDto;
        // Allocated amount copied from source.
        expect(captured.allocatedAmount, equals(100000));
        // Spent and rollover should be 0 for new period.
        expect(captured.spentAmount, equals(0));
        expect(captured.rolloverAmount, equals(0));
        expect(captured.budgetPeriodId, equals('period-2'));
      });

      test('throws BudgetException on API failure', () async {
        when(() => envelopesDao.getAllocationsByPeriodId('period-1'))
            .thenAnswer((_) async => [testLocalAllocation]);
        when(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.duplicateAllocations(
            fromPeriodId: 'period-1',
            toPeriodId: 'period-2',
          ),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('transferBetweenEnvelopes', () {
      test('adjusts amounts on both allocations', () async {
        final fromDto = EnvelopeAllocationDto(
          id: 'alloc-from',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 100000,
          createdAt: now,
        );
        final toDto = EnvelopeAllocationDto(
          id: 'alloc-to',
          envelopeId: 'env-2',
          budgetPeriodId: 'period-1',
          allocatedAmount: 50000,
          createdAt: now,
        );

        when(
          () => envelopesApiClient
              .getEnvelopeAllocation('alloc-from'),
        ).thenAnswer((_) async => fromDto);
        when(
          () => envelopesApiClient
              .getEnvelopeAllocation('alloc-to'),
        ).thenAnswer((_) async => toDto);
        when(
          () => envelopesApiClient.updateEnvelopeAllocation(any()),
        ).thenAnswer((inv) async {
          return inv.positionalArguments.first
              as EnvelopeAllocationDto;
        });
        when(
          () => envelopesDao.insertAllocation(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.transferBetweenEnvelopes(
          fromAllocationId: 'alloc-from',
          toAllocationId: 'alloc-to',
          amount: 20000,
        );

        final captured = verify(
          () => envelopesApiClient
              .updateEnvelopeAllocation(captureAny()),
        ).captured;
        final updatedFrom = captured[0] as EnvelopeAllocationDto;
        final updatedTo = captured[1] as EnvelopeAllocationDto;
        expect(updatedFrom.allocatedAmount, equals(80000));
        expect(updatedTo.allocatedAmount, equals(70000));
      });

      test('throws on non-positive amount', () async {
        expect(
          () => repository.transferBetweenEnvelopes(
            fromAllocationId: 'alloc-from',
            toAllocationId: 'alloc-to',
            amount: 0,
          ),
          throwsA(
            isA<BudgetException>().having(
              (e) => e.message,
              'message',
              'Transfer amount must be positive',
            ),
          ),
        );
      });

      test('throws on negative amount', () async {
        expect(
          () => repository.transferBetweenEnvelopes(
            fromAllocationId: 'alloc-from',
            toAllocationId: 'alloc-to',
            amount: -100,
          ),
          throwsA(isA<BudgetException>()),
        );
      });

      test('throws when amount exceeds source allocation', () async {
        final fromDto = EnvelopeAllocationDto(
          id: 'alloc-from',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 50000,
          createdAt: now,
        );
        final toDto = EnvelopeAllocationDto(
          id: 'alloc-to',
          envelopeId: 'env-2',
          budgetPeriodId: 'period-1',
          allocatedAmount: 50000,
          createdAt: now,
        );

        when(
          () => envelopesApiClient
              .getEnvelopeAllocation('alloc-from'),
        ).thenAnswer((_) async => fromDto);
        when(
          () => envelopesApiClient
              .getEnvelopeAllocation('alloc-to'),
        ).thenAnswer((_) async => toDto);

        expect(
          () => repository.transferBetweenEnvelopes(
            fromAllocationId: 'alloc-from',
            toAllocationId: 'alloc-to',
            amount: 100000,
          ),
          throwsA(
            isA<BudgetException>().having(
              (e) => e.message,
              'message',
              contains('Insufficient funds'),
            ),
          ),
        );
      });

      test('reverts first update when second update fails', () async {
        final fromDto = EnvelopeAllocationDto(
          id: 'alloc-from',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 100000,
          createdAt: now,
        );
        final toDto = EnvelopeAllocationDto(
          id: 'alloc-to',
          envelopeId: 'env-2',
          budgetPeriodId: 'period-1',
          allocatedAmount: 50000,
          createdAt: now,
        );

        when(
          () => envelopesApiClient
              .getEnvelopeAllocation('alloc-from'),
        ).thenAnswer((_) async => fromDto);
        when(
          () => envelopesApiClient
              .getEnvelopeAllocation('alloc-to'),
        ).thenAnswer((_) async => toDto);

        var callCount = 0;
        when(
          () => envelopesApiClient.updateEnvelopeAllocation(any()),
        ).thenAnswer((inv) async {
          callCount++;
          if (callCount == 1) {
            // First update succeeds (debit from source).
            return inv.positionalArguments.first
                as EnvelopeAllocationDto;
          } else if (callCount == 2) {
            // Second update fails (credit to target).
            throw const EnvelopeApiException('network error');
          }
          // Third call is the revert.
          return inv.positionalArguments.first
              as EnvelopeAllocationDto;
        });

        expect(
          () => repository.transferBetweenEnvelopes(
            fromAllocationId: 'alloc-from',
            toAllocationId: 'alloc-to',
            amount: 20000,
          ),
          throwsA(isA<BudgetException>()),
        );

        // Wait for async to complete.
        await Future<void>.delayed(Duration.zero);

        // Should have been called 3 times: debit, credit (fail), revert.
        verify(
          () => envelopesApiClient.updateEnvelopeAllocation(any()),
        ).called(3);
      });

      test('throws BudgetException on API failure', () async {
        when(
          () => envelopesApiClient
              .getEnvelopeAllocation('alloc-from'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.transferBetweenEnvelopes(
            fromAllocationId: 'alloc-from',
            toAllocationId: 'alloc-to',
            amount: 20000,
          ),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    // -----------------------------------------------------------------
    // Allocation Templates
    // -----------------------------------------------------------------
    group('createAllocationTemplate', () {
      test('creates template + items via API, caches, returns model',
          () async {
        when(
          () => envelopesApiClient.createAllocationTemplate(any()),
        ).thenAnswer((_) async => testTemplateDto);
        when(
          () => envelopesDao.insertTemplate(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => envelopesApiClient.createAllocationTemplateItem(any()),
        ).thenAnswer((_) async => testTemplateItemDto);
        when(
          () => envelopesDao.insertTemplateItem(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createAllocationTemplate(
          budgetId: 'budget-1',
          name: 'Standard Split',
          items: const [
            AllocationTemplateItem(
              id: '',
              templateId: '',
              envelopeId: 'env-1',
              percentage: 50,
            ),
          ],
        );

        expect(result.id, equals('tmpl-1'));
        expect(result.name, equals('Standard Split'));
        expect(result.items, hasLength(1));
        verify(
          () => envelopesApiClient.createAllocationTemplate(any()),
        ).called(1);
        verify(
          () => envelopesApiClient.createAllocationTemplateItem(any()),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(
          () => envelopesApiClient.createAllocationTemplate(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.createAllocationTemplate(
            budgetId: 'budget-1',
            name: 'Split',
            items: const [],
          ),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('getAllocationTemplates', () {
      test('returns from local storage when available', () async {
        when(() => envelopesDao.getTemplatesByBudgetId('budget-1'))
            .thenAnswer((_) async => [testLocalTemplate]);
        when(
          () => envelopesDao.getTemplateItemsByTemplateId('tmpl-1'),
        ).thenAnswer((_) async => [testLocalTemplateItem]);

        final result =
            await repository.getAllocationTemplates('budget-1');

        expect(result, hasLength(1));
        expect(result.first.id, equals('tmpl-1'));
        expect(result.first.items, hasLength(1));
        verifyNever(
          () => envelopesApiClient
              .getAllocationTemplatesByBudget(any()),
        );
      });

      test('falls back to API when local is empty', () async {
        when(() => envelopesDao.getTemplatesByBudgetId('budget-1'))
            .thenAnswer((_) async => []);
        when(
          () => envelopesApiClient
              .getAllocationTemplatesByBudget('budget-1'),
        ).thenAnswer((_) async => [testTemplateDto]);
        when(
          () => envelopesDao.insertTemplate(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer((_) async => [testTemplateItemDto]);
        when(
          () => envelopesDao.insertTemplateItem(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result =
            await repository.getAllocationTemplates('budget-1');

        expect(result, hasLength(1));
        expect(result.first.id, equals('tmpl-1'));
        verify(
          () => envelopesApiClient
              .getAllocationTemplatesByBudget('budget-1'),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(() => envelopesDao.getTemplatesByBudgetId('budget-1'))
            .thenAnswer((_) async => []);
        when(
          () => envelopesApiClient
              .getAllocationTemplatesByBudget('budget-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.getAllocationTemplates('budget-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('watchAllocationTemplates', () {
      test('streams templates with items from local storage', () {
        when(() => envelopesDao.watchTemplatesByBudgetId('budget-1'))
            .thenAnswer(
          (_) => Stream.value([testLocalTemplate]),
        );
        when(
          () => envelopesDao.getTemplateItemsByTemplateId('tmpl-1'),
        ).thenAnswer((_) async => [testLocalTemplateItem]);

        final stream =
            repository.watchAllocationTemplates('budget-1');

        expect(
          stream,
          emits(
            isA<List<AllocationTemplate>>()
                .having((l) => l.length, 'length', 1)
                .having(
                  (l) => l.first.items.length,
                  'first.items.length',
                  1,
                ),
          ),
        );
      });
    });

    group('updateAllocationTemplate', () {
      test('deletes old items from API before local (remote-first)',
          () async {
        when(
          () => envelopesApiClient.updateAllocationTemplate(any()),
        ).thenAnswer((_) async => testTemplateDto);
        when(
          () => envelopesDao.insertTemplate(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer((_) async => [testTemplateItemDto]);
        when(
          () => envelopesApiClient
              .deleteAllocationTemplateItem('item-1'),
        ).thenAnswer((_) async {});
        when(
          () =>
              envelopesDao.deleteTemplateItemsByTemplateId('tmpl-1'),
        ).thenAnswer((_) async => 1);
        when(
          () => envelopesApiClient.createAllocationTemplateItem(any()),
        ).thenAnswer((_) async => testTemplateItemDto);
        when(
          () => envelopesDao.insertTemplateItem(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final template = AllocationTemplate(
          id: 'tmpl-1',
          budgetId: 'budget-1',
          name: 'Standard Split',
          createdAt: now,
          items: const [
            AllocationTemplateItem(
              id: '',
              templateId: 'tmpl-1',
              envelopeId: 'env-1',
              percentage: 100,
            ),
          ],
        );

        await repository.updateAllocationTemplate(template);

        verify(
          () => envelopesApiClient.updateAllocationTemplate(any()),
        ).called(1);
        // API items deleted before local items.
        verify(
          () => envelopesApiClient
              .deleteAllocationTemplateItem('item-1'),
        ).called(1);
        verify(
          () =>
              envelopesDao.deleteTemplateItemsByTemplateId('tmpl-1'),
        ).called(1);
        verify(
          () => envelopesApiClient.createAllocationTemplateItem(any()),
        ).called(1);
      });
    });

    group('deleteAllocationTemplate', () {
      test('deletes items first, then template', () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer((_) async => [testTemplateItemDto]);
        when(
          () => envelopesApiClient
              .deleteAllocationTemplateItem('item-1'),
        ).thenAnswer((_) async {});
        when(
          () => envelopesApiClient
              .deleteAllocationTemplate('tmpl-1'),
        ).thenAnswer((_) async {});
        when(
          () =>
              envelopesDao.deleteTemplateItemsByTemplateId('tmpl-1'),
        ).thenAnswer((_) async => 1);
        when(() => envelopesDao.deleteTemplate('tmpl-1'))
            .thenAnswer((_) async => 1);

        await repository.deleteAllocationTemplate('tmpl-1');

        verify(
          () => envelopesApiClient
              .deleteAllocationTemplateItem('item-1'),
        ).called(1);
        verify(
          () => envelopesApiClient
              .deleteAllocationTemplate('tmpl-1'),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.deleteAllocationTemplate('tmpl-1'),
          throwsA(isA<BudgetException>()),
        );
      });

      test('succeeds even when local cleanup fails', () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer((_) async => []);
        when(
          () => envelopesApiClient
              .deleteAllocationTemplate('tmpl-1'),
        ).thenAnswer((_) async {});
        when(
          () =>
              envelopesDao.deleteTemplateItemsByTemplateId('tmpl-1'),
        ).thenThrow(Exception('local error'));

        await repository.deleteAllocationTemplate('tmpl-1');

        verify(
          () => envelopesApiClient
              .deleteAllocationTemplate('tmpl-1'),
        ).called(1);
      });
    });

    group('applyAllocationTemplate', () {
      test('creates allocations from template percentages', () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer(
          (_) async => [testTemplateItemDto, testTemplateItemDto2],
        );
        when(() => envelopesDao.getAllocationsByPeriodId('period-1'))
            .thenAnswer((_) async => []);
        when(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).thenAnswer((inv) async {
          final dto =
              inv.positionalArguments.first as EnvelopeAllocationDto;
          return dto.copyWith(id: 'alloc-new');
        });
        when(
          () => envelopesDao.insertAllocation(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.applyAllocationTemplate(
          templateId: 'tmpl-1',
          budgetPeriodId: 'period-1',
          totalAmount: 100000,
        );

        // Two items with 50% each = 50000 each
        verify(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).called(2);
      });

      test('handles rounding remainder', () async {
        const item1 = AllocationTemplateItemDto(
          id: 'i1',
          templateId: 'tmpl-1',
          envelopeId: 'env-1',
          percentage: 33.33,
        );
        const item2 = AllocationTemplateItemDto(
          id: 'i2',
          templateId: 'tmpl-1',
          envelopeId: 'env-2',
          percentage: 33.33,
        );
        const item3 = AllocationTemplateItemDto(
          id: 'i3',
          templateId: 'tmpl-1',
          envelopeId: 'env-3',
          percentage: 33.34,
        );

        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer((_) async => [item1, item2, item3]);
        when(() => envelopesDao.getAllocationsByPeriodId('period-1'))
            .thenAnswer((_) async => []);

        final createdDtos = <EnvelopeAllocationDto>[];
        when(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).thenAnswer((inv) async {
          final dto =
              inv.positionalArguments.first as EnvelopeAllocationDto;
          final created =
              dto.copyWith(id: 'alloc-${createdDtos.length}');
          createdDtos.add(created);
          return created;
        });
        when(
          () => envelopesDao.insertAllocation(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.applyAllocationTemplate(
          templateId: 'tmpl-1',
          budgetPeriodId: 'period-1',
          totalAmount: 100000,
        );

        // Total allocated should equal totalAmount
        final total = createdDtos.fold<int>(
          0,
          (sum, dto) => sum + dto.allocatedAmount,
        );
        expect(total, equals(100000));
      });

      test('throws when percentages do not sum to 100', () async {
        const badItem1 = AllocationTemplateItemDto(
          id: 'i1',
          templateId: 'tmpl-1',
          envelopeId: 'env-1',
          percentage: 30,
        );
        const badItem2 = AllocationTemplateItemDto(
          id: 'i2',
          templateId: 'tmpl-1',
          envelopeId: 'env-2',
          percentage: 30,
        );

        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer((_) async => [badItem1, badItem2]);

        expect(
          () => repository.applyAllocationTemplate(
            templateId: 'tmpl-1',
            budgetPeriodId: 'period-1',
            totalAmount: 100000,
          ),
          throwsA(
            isA<BudgetException>().having(
              (e) => e.message,
              'message',
              contains('percentages sum to'),
            ),
          ),
        );
      });

      test('throws when allocations already exist for envelopes',
          () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer(
          (_) async => [testTemplateItemDto, testTemplateItemDto2],
        );
        // Existing allocation for env-1 in the target period.
        when(() => envelopesDao.getAllocationsByPeriodId('period-1'))
            .thenAnswer((_) async => [testLocalAllocation]);

        expect(
          () => repository.applyAllocationTemplate(
            templateId: 'tmpl-1',
            budgetPeriodId: 'period-1',
            totalAmount: 100000,
          ),
          throwsA(
            isA<BudgetException>().having(
              (e) => e.message,
              'message',
              contains('Allocations already exist'),
            ),
          ),
        );
      });

      test('throws BudgetException on API failure', () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.applyAllocationTemplate(
            templateId: 'tmpl-1',
            budgetPeriodId: 'period-1',
            totalAmount: 100000,
          ),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    group('refreshAllocationTemplates', () {
      test('fetches templates and items from API and batch caches',
          () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplatesByBudget('budget-1'),
        ).thenAnswer((_) async => [testTemplateDto]);
        when(
          () => envelopesDao.batchInsertTemplates(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => envelopesApiClient
              .getAllocationTemplateItems('tmpl-1'),
        ).thenAnswer((_) async => [testTemplateItemDto]);
        when(
          () => envelopesDao.batchInsertTemplateItems(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshAllocationTemplates('budget-1');

        verify(
          () => envelopesApiClient
              .getAllocationTemplatesByBudget('budget-1'),
        ).called(1);
        verify(
          () => envelopesDao.batchInsertTemplates(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
        verify(
          () => envelopesDao.batchInsertTemplateItems(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        when(
          () => envelopesApiClient
              .getAllocationTemplatesByBudget('budget-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.refreshAllocationTemplates('budget-1'),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    // -----------------------------------------------------------------
    // updateBudgetPeriod
    // -----------------------------------------------------------------
    group('updateBudgetPeriod', () {
      test('updates via API and caches locally', () async {
        final period = BudgetPeriod(
          id: 'period-1',
          budgetId: 'budget-1',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
          totalIncome: 600000,
          totalAllocated: 300000,
          isClosed: false,
          createdAt: now,
        );

        when(() => budgetsApiClient.updateBudgetPeriod(any()))
            .thenAnswer((_) async => testBudgetPeriodDto);
        when(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateBudgetPeriod(period);

        verify(() => budgetsApiClient.updateBudgetPeriod(any()))
            .called(1);
        verify(
          () => budgetsDao.insertBudgetPeriod(
            any(),
            mode: any(named: 'mode'),
          ),
        ).called(1);
      });

      test('throws BudgetException on API failure', () async {
        final period = BudgetPeriod(
          id: 'period-1',
          budgetId: 'budget-1',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 31),
          totalIncome: 600000,
          totalAllocated: 300000,
          isClosed: false,
          createdAt: now,
        );

        when(() => budgetsApiClient.updateBudgetPeriod(any()))
            .thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.updateBudgetPeriod(period),
          throwsA(isA<BudgetException>()),
        );
      });
    });

    // -----------------------------------------------------------------
    // addIncomeToCurrentPeriod
    // -----------------------------------------------------------------
    group('addIncomeToCurrentPeriod', () {
      test(
        'finds latest period and increments totalIncome',
        () async {
          when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
              .thenAnswer((_) async => [testLocalBudgetPeriod]);
          when(() => budgetsApiClient.updateBudgetPeriod(any()))
              .thenAnswer((_) async => testBudgetPeriodDto);
          when(
            () => budgetsDao.insertBudgetPeriod(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer((_) async => 1);

          await repository.addIncomeToCurrentPeriod(
            budgetId: 'budget-1',
            amount: 10000,
          );

          final captured = verify(
            () => budgetsApiClient.updateBudgetPeriod(captureAny()),
          ).captured.single as BudgetPeriodDto;
          expect(captured.totalIncome, equals(510000));
        },
      );

      test('does nothing when no periods exist', () async {
        when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
            .thenAnswer((_) async => []);

        await repository.addIncomeToCurrentPeriod(
          budgetId: 'budget-1',
          amount: 10000,
        );

        verifyNever(
          () => budgetsApiClient.updateBudgetPeriod(any()),
        );
      });

      test(
        'picks latest period when multiple exist',
        () async {
          final olderPeriod = storage.BudgetPeriod(
            id: 'period-0',
            budgetId: 'budget-1',
            startDate: DateTime(2023, 12),
            endDate: DateTime(2023, 12, 31),
            totalIncome: 400000,
            totalAllocated: 200000,
            isClosed: true,
            createdAt: now,
          );

          when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
              .thenAnswer(
            (_) async => [olderPeriod, testLocalBudgetPeriod],
          );
          when(() => budgetsApiClient.updateBudgetPeriod(any()))
              .thenAnswer((_) async => testBudgetPeriodDto);
          when(
            () => budgetsDao.insertBudgetPeriod(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer((_) async => 1);

          await repository.addIncomeToCurrentPeriod(
            budgetId: 'budget-1',
            amount: 10000,
          );

          final captured = verify(
            () => budgetsApiClient.updateBudgetPeriod(captureAny()),
          ).captured.single as BudgetPeriodDto;
          // Should update period-1 (Jan 2024), not period-0 (Dec 2023)
          expect(captured.id, equals('period-1'));
          expect(captured.totalIncome, equals(510000));
        },
      );

      test(
        'throws BudgetException on failure',
        () async {
          when(() => budgetsDao.getPeriodsByBudgetId('budget-1'))
              .thenThrow(Exception('DB error'));

          expect(
            () => repository.addIncomeToCurrentPeriod(
              budgetId: 'budget-1',
              amount: 10000,
            ),
            throwsA(isA<BudgetException>()),
          );
        },
      );
    });

    // -----------------------------------------------------------------
    // Exceptions
    // -----------------------------------------------------------------
    group('BudgetException', () {
      test('toString includes message', () {
        const exception = BudgetException('test error');
        expect(
          exception.toString(),
          equals('BudgetException: test error'),
        );
      });

      test('toString includes error when present', () {
        const exception = BudgetException(
          'test error',
          error: 'inner error',
        );
        expect(
          exception.toString(),
          equals('BudgetException: test error (inner error)'),
        );
      });
    });
  });
}
