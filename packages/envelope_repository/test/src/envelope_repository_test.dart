import 'package:drift/drift.dart' show InsertMode;
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:envelope_repository/envelope_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockEnvelopeApiClient extends Mock implements EnvelopeApiClient {}

class MockEnvelopesApiClient extends Mock implements EnvelopesApiClient {}

class MockAppDatabase extends Mock implements storage.AppDatabase {}

class MockEnvelopesDao extends Mock implements storage.EnvelopesDao {}

class FakeCategoryGroupDto extends Fake implements CategoryGroupDto {}

class FakeEnvelopeDto extends Fake implements EnvelopeDto {}

class FakeEnvelopeAllocationDto extends Fake implements EnvelopeAllocationDto {}

class FakeCategoryGroupsCompanion extends Fake
    implements storage.CategoryGroupsCompanion {}

class FakeEnvelopesCompanion extends Fake
    implements storage.EnvelopesCompanion {}

class FakeEnvelopeAllocationsCompanion extends Fake
    implements storage.EnvelopeAllocationsCompanion {}

void main() {
  late EnvelopeRepository repository;
  late MockEnvelopeApiClient apiClient;
  late MockEnvelopesApiClient envelopesApiClient;
  late MockAppDatabase localDatabase;
  late MockEnvelopesDao envelopesDao;

  final now = DateTime(2024);

  // --- Test fixtures ---

  final testCategoryGroupDto = CategoryGroupDto(
    id: 'cg-1',
    budgetId: 'budget-1',
    name: 'Monthly Bills',
    createdAt: now,
  );

  final testCategoryGroup = CategoryGroup(
    id: 'cg-1',
    budgetId: 'budget-1',
    name: 'Monthly Bills',
    createdAt: now,
  );

  final testLocalCategoryGroup = storage.CategoryGroup(
    id: 'cg-1',
    budgetId: 'budget-1',
    name: 'Monthly Bills',
    sortOrder: 0,
    isDefault: false,
    isArchived: false,
    createdAt: now,
  );

  final testEnvelopeDto = EnvelopeDto(
    id: 'env-1',
    categoryGroupId: 'cg-1',
    budgetId: 'budget-1',
    name: 'Rent',
    createdAt: now,
  );

  final testEnvelope = Envelope(
    id: 'env-1',
    categoryGroupId: 'cg-1',
    budgetId: 'budget-1',
    name: 'Rent',
    createdAt: now,
  );

  final testLocalEnvelope = storage.Envelope(
    id: 'env-1',
    categoryGroupId: 'cg-1',
    budgetId: 'budget-1',
    name: 'Rent',
    sortOrder: 0,
    isArchived: false,
    createdAt: now,
  );

  final testAllocationDto = EnvelopeAllocationDto(
    id: 'alloc-1',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-1',
    allocatedAmount: 100000,
    spentAmount: 25000,
    rolloverAmount: 5000,
    createdAt: now,
  );

  final testAllocation = EnvelopeAllocation(
    id: 'alloc-1',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-1',
    allocatedAmount: 100000,
    spentAmount: 25000,
    rolloverAmount: 5000,
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

  setUpAll(() {
    registerFallbackValue(FakeCategoryGroupDto());
    registerFallbackValue(FakeEnvelopeDto());
    registerFallbackValue(FakeEnvelopeAllocationDto());
    registerFallbackValue(FakeCategoryGroupsCompanion());
    registerFallbackValue(FakeEnvelopesCompanion());
    registerFallbackValue(FakeEnvelopeAllocationsCompanion());
    registerFallbackValue(InsertMode.insert);
    registerFallbackValue(<storage.CategoryGroupsCompanion>[]);
    registerFallbackValue(<storage.EnvelopesCompanion>[]);
    registerFallbackValue(<storage.EnvelopeAllocationsCompanion>[]);
  });

  setUp(() {
    apiClient = MockEnvelopeApiClient();
    envelopesApiClient = MockEnvelopesApiClient();
    localDatabase = MockAppDatabase();
    envelopesDao = MockEnvelopesDao();

    when(() => apiClient.envelopes).thenReturn(envelopesApiClient);
    when(() => localDatabase.envelopesDao).thenReturn(envelopesDao);

    repository = EnvelopeRepository(
      apiClient: apiClient,
      localDatabase: localDatabase,
    );
  });

  group('EnvelopeRepository', () {
    // -----------------------------------------------------------------
    // Category Groups
    // -----------------------------------------------------------------
    group('createCategoryGroup', () {
      test('creates via API, caches, and returns model', () async {
        when(
          () => envelopesApiClient.createCategoryGroup(any()),
        ).thenAnswer((_) async => testCategoryGroupDto);
        when(
          () => envelopesDao.insertCategoryGroup(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createCategoryGroup(
          budgetId: 'budget-1',
          name: 'Monthly Bills',
        );

        expect(result.id, equals('cg-1'));
        expect(result.name, equals('Monthly Bills'));
        verify(
          () => envelopesApiClient.createCategoryGroup(any()),
        ).called(1);
        verify(
          () => envelopesDao.insertCategoryGroup(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.createCategoryGroup(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.createCategoryGroup(
            budgetId: 'budget-1',
            name: 'Monthly Bills',
          ),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('getCategoryGroup', () {
      test('returns from local storage when available', () async {
        when(
          () => envelopesDao.getCategoryGroup('cg-1'),
        ).thenAnswer((_) async => testLocalCategoryGroup);

        final result = await repository.getCategoryGroup('cg-1');

        expect(result.id, equals('cg-1'));
        verifyNever(
          () => envelopesApiClient.getCategoryGroup(any()),
        );
      });

      test('falls back to API when not in local storage', () async {
        when(
          () => envelopesDao.getCategoryGroup('cg-1'),
        ).thenAnswer((_) async => null);
        when(
          () => envelopesApiClient.getCategoryGroup('cg-1'),
        ).thenAnswer((_) async => testCategoryGroupDto);
        when(
          () => envelopesDao.insertCategoryGroup(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.getCategoryGroup('cg-1');

        expect(result.id, equals('cg-1'));
        verify(
          () => envelopesApiClient.getCategoryGroup('cg-1'),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesDao.getCategoryGroup('cg-1'),
        ).thenAnswer((_) async => null);
        when(
          () => envelopesApiClient.getCategoryGroup('cg-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.getCategoryGroup('cg-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('watchCategoryGroups', () {
      test('streams from local storage mapped to domain models', () {
        when(
          () => envelopesDao.watchCategoryGroupsByBudgetId('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([testLocalCategoryGroup]),
        );

        final stream = repository.watchCategoryGroups('budget-1');

        expect(
          stream,
          emits(
            isA<List<CategoryGroup>>()
                .having((l) => l.length, 'length', 1)
                .having(
                  (l) => l.first.id,
                  'first.id',
                  'cg-1',
                ),
          ),
        );
      });
    });

    group('updateCategoryGroup', () {
      test('updates via API and caches locally', () async {
        when(
          () => envelopesApiClient.updateCategoryGroup(any()),
        ).thenAnswer((_) async => testCategoryGroupDto);
        when(
          () => envelopesDao.insertCategoryGroup(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateCategoryGroup(testCategoryGroup);

        verify(
          () => envelopesApiClient.updateCategoryGroup(any()),
        ).called(1);
        verify(
          () => envelopesDao.insertCategoryGroup(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.updateCategoryGroup(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.updateCategoryGroup(testCategoryGroup),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('deleteCategoryGroup', () {
      test('deletes from API and cleans up local cache', () async {
        when(
          () => envelopesApiClient.deleteCategoryGroup('cg-1'),
        ).thenAnswer((_) async {});
        when(
          () => envelopesDao.deleteCategoryGroup('cg-1'),
        ).thenAnswer((_) async => 1);

        await repository.deleteCategoryGroup('cg-1');

        verify(
          () => envelopesApiClient.deleteCategoryGroup('cg-1'),
        ).called(1);
        verify(
          () => envelopesDao.deleteCategoryGroup('cg-1'),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.deleteCategoryGroup('cg-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.deleteCategoryGroup('cg-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });

      test('succeeds even when local cleanup fails', () async {
        when(
          () => envelopesApiClient.deleteCategoryGroup('cg-1'),
        ).thenAnswer((_) async {});
        when(
          () => envelopesDao.deleteCategoryGroup('cg-1'),
        ).thenThrow(Exception('local error'));

        await repository.deleteCategoryGroup('cg-1');

        verify(
          () => envelopesApiClient.deleteCategoryGroup('cg-1'),
        ).called(1);
      });
    });

    group('archiveCategoryGroup', () {
      test('sets isArchived to true and updates', () async {
        when(
          () => envelopesDao.getCategoryGroup('cg-1'),
        ).thenAnswer((_) async => testLocalCategoryGroup);
        when(
          () => envelopesApiClient.updateCategoryGroup(any()),
        ).thenAnswer((inv) async {
          return inv.positionalArguments.first as CategoryGroupDto;
        });
        when(
          () => envelopesDao.insertCategoryGroup(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.archiveCategoryGroup('cg-1');

        final captured =
            verify(
                  () => envelopesApiClient.updateCategoryGroup(captureAny()),
                ).captured.single
                as CategoryGroupDto;
        expect(captured.isArchived, isTrue);
      });
    });

    group('unarchiveCategoryGroup', () {
      test('sets isArchived to false and updates', () async {
        final archivedLocal = storage.CategoryGroup(
          id: 'cg-1',
          budgetId: 'budget-1',
          name: 'Monthly Bills',
          sortOrder: 0,
          isDefault: false,
          isArchived: true,
          createdAt: now,
        );
        when(
          () => envelopesDao.getCategoryGroup('cg-1'),
        ).thenAnswer((_) async => archivedLocal);
        when(
          () => envelopesApiClient.updateCategoryGroup(any()),
        ).thenAnswer((inv) async {
          return inv.positionalArguments.first as CategoryGroupDto;
        });
        when(
          () => envelopesDao.insertCategoryGroup(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.unarchiveCategoryGroup('cg-1');

        final captured =
            verify(
                  () => envelopesApiClient.updateCategoryGroup(captureAny()),
                ).captured.single
                as CategoryGroupDto;
        expect(captured.isArchived, isFalse);
      });
    });

    group('reorderCategoryGroups', () {
      test(
        'updates sort_order for each group via API and '
        'batch caches',
        () async {
          final dto2 = testCategoryGroupDto.copyWith(
            id: 'cg-2',
            name: 'Food',
          );

          when(
            () => envelopesApiClient.getCategoryGroup('cg-2'),
          ).thenAnswer((_) async => dto2);
          when(
            () => envelopesApiClient.getCategoryGroup('cg-1'),
          ).thenAnswer((_) async => testCategoryGroupDto);
          when(
            () => envelopesApiClient.updateCategoryGroup(any()),
          ).thenAnswer((inv) async {
            return inv.positionalArguments.first as CategoryGroupDto;
          });
          when(
            () => envelopesDao.batchInsertCategoryGroups(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer((_) async {});

          await repository.reorderCategoryGroups(['cg-2', 'cg-1']);

          verify(
            () => envelopesApiClient.updateCategoryGroup(any()),
          ).called(2);
          verify(
            () => envelopesDao.batchInsertCategoryGroups(
              any(),
              mode: InsertMode.insertOrReplace,
            ),
          ).called(1);
        },
      );

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.getCategoryGroup('cg-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.reorderCategoryGroups(['cg-1']),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('refreshCategoryGroups', () {
      test('fetches from API and batch caches all groups', () async {
        when(
          () => envelopesApiClient.getCategoryGroupsByBudget('budget-1'),
        ).thenAnswer((_) async => [testCategoryGroupDto]);
        when(
          () => envelopesDao.batchInsertCategoryGroups(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshCategoryGroups('budget-1');

        verify(
          () => envelopesApiClient.getCategoryGroupsByBudget('budget-1'),
        ).called(1);
        verify(
          () => envelopesDao.batchInsertCategoryGroups(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.getCategoryGroupsByBudget('budget-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.refreshCategoryGroups('budget-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    // -----------------------------------------------------------------
    // Envelopes
    // -----------------------------------------------------------------
    group('createEnvelope', () {
      test('creates via API, caches, and returns model', () async {
        when(
          () => envelopesApiClient.createEnvelope(any()),
        ).thenAnswer((_) async => testEnvelopeDto);
        when(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.createEnvelope(
          categoryGroupId: 'cg-1',
          budgetId: 'budget-1',
          name: 'Rent',
        );

        expect(result.id, equals('env-1'));
        expect(result.name, equals('Rent'));
        verify(
          () => envelopesApiClient.createEnvelope(any()),
        ).called(1);
        verify(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.createEnvelope(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.createEnvelope(
            categoryGroupId: 'cg-1',
            budgetId: 'budget-1',
            name: 'Rent',
          ),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('getEnvelope', () {
      test('returns from local storage when available', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => testLocalEnvelope);

        final result = await repository.getEnvelope('env-1');

        expect(result.id, equals('env-1'));
        verifyNever(
          () => envelopesApiClient.getEnvelope(any()),
        );
      });

      test('falls back to API when not in local storage', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => null);
        when(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).thenAnswer((_) async => testEnvelopeDto);
        when(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.getEnvelope('env-1');

        expect(result.id, equals('env-1'));
        verify(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => null);
        when(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.getEnvelope('env-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('watchEnvelopes', () {
      test('streams from local storage mapped to domain models', () {
        when(
          () => envelopesDao.watchEnvelopesByBudgetId('budget-1'),
        ).thenAnswer(
          (_) => Stream.value([testLocalEnvelope]),
        );

        final stream = repository.watchEnvelopes('budget-1');

        expect(
          stream,
          emits(
            isA<List<Envelope>>()
                .having((l) => l.length, 'length', 1)
                .having(
                  (l) => l.first.id,
                  'first.id',
                  'env-1',
                ),
          ),
        );
      });
    });

    group('watchEnvelopesByCategoryGroup', () {
      test('streams envelopes for a category group', () {
        when(
          () => envelopesDao.watchEnvelopesByCategoryGroupId('cg-1'),
        ).thenAnswer(
          (_) => Stream.value([testLocalEnvelope]),
        );

        final stream = repository.watchEnvelopesByCategoryGroup('cg-1');

        expect(
          stream,
          emits(
            isA<List<Envelope>>()
                .having((l) => l.length, 'length', 1)
                .having(
                  (l) => l.first.categoryGroupId,
                  'first.categoryGroupId',
                  'cg-1',
                ),
          ),
        );
      });
    });

    group('updateEnvelope', () {
      test('updates via API and caches locally', () async {
        when(
          () => envelopesApiClient.updateEnvelope(any()),
        ).thenAnswer((_) async => testEnvelopeDto);
        when(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateEnvelope(testEnvelope);

        verify(
          () => envelopesApiClient.updateEnvelope(any()),
        ).called(1);
        verify(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.updateEnvelope(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.updateEnvelope(testEnvelope),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('deleteEnvelope', () {
      test('deletes from API and cleans up local cache', () async {
        when(
          () => envelopesApiClient.deleteEnvelope('env-1'),
        ).thenAnswer((_) async {});
        when(
          () => envelopesDao.deleteEnvelope('env-1'),
        ).thenAnswer((_) async => 1);

        await repository.deleteEnvelope('env-1');

        verify(
          () => envelopesApiClient.deleteEnvelope('env-1'),
        ).called(1);
        verify(
          () => envelopesDao.deleteEnvelope('env-1'),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.deleteEnvelope('env-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.deleteEnvelope('env-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });

      test('succeeds even when local cleanup fails', () async {
        when(
          () => envelopesApiClient.deleteEnvelope('env-1'),
        ).thenAnswer((_) async {});
        when(
          () => envelopesDao.deleteEnvelope('env-1'),
        ).thenThrow(Exception('local error'));

        await repository.deleteEnvelope('env-1');

        verify(
          () => envelopesApiClient.deleteEnvelope('env-1'),
        ).called(1);
      });
    });

    group('archiveEnvelope', () {
      test('sets isArchived to true and updates', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => testLocalEnvelope);
        when(() => envelopesApiClient.updateEnvelope(any())).thenAnswer((
          inv,
        ) async {
          return inv.positionalArguments.first as EnvelopeDto;
        });
        when(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.archiveEnvelope('env-1');

        final captured =
            verify(
                  () => envelopesApiClient.updateEnvelope(captureAny()),
                ).captured.single
                as EnvelopeDto;
        expect(captured.isArchived, isTrue);
      });

      test('falls back to API when not in local storage', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => null);
        when(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).thenAnswer((_) async => testEnvelopeDto);
        when(() => envelopesApiClient.updateEnvelope(any())).thenAnswer((
          inv,
        ) async {
          return inv.positionalArguments.first as EnvelopeDto;
        });
        when(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.archiveEnvelope('env-1');

        verify(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => testLocalEnvelope);
        when(
          () => envelopesApiClient.updateEnvelope(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.archiveEnvelope('env-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('unarchiveEnvelope', () {
      test('sets isArchived to false and updates', () async {
        final archivedLocal = storage.Envelope(
          id: 'env-1',
          categoryGroupId: 'cg-1',
          budgetId: 'budget-1',
          name: 'Rent',
          sortOrder: 0,
          isArchived: true,
          createdAt: now,
        );
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => archivedLocal);
        when(() => envelopesApiClient.updateEnvelope(any())).thenAnswer((
          inv,
        ) async {
          return inv.positionalArguments.first as EnvelopeDto;
        });
        when(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.unarchiveEnvelope('env-1');

        final captured =
            verify(
                  () => envelopesApiClient.updateEnvelope(captureAny()),
                ).captured.single
                as EnvelopeDto;
        expect(captured.isArchived, isFalse);
      });

      test('throws when envelope not found anywhere', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => null);
        when(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).thenThrow(const EnvelopeApiException('not found'));

        expect(
          () => repository.unarchiveEnvelope('env-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('moveEnvelope', () {
      test('updates categoryGroupId and syncs', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => testLocalEnvelope);
        when(() => envelopesApiClient.updateEnvelope(any())).thenAnswer((
          inv,
        ) async {
          return inv.positionalArguments.first as EnvelopeDto;
        });
        when(
          () => envelopesDao.insertEnvelope(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.moveEnvelope(
          envelopeId: 'env-1',
          newCategoryGroupId: 'cg-2',
        );

        final captured =
            verify(
                  () => envelopesApiClient.updateEnvelope(captureAny()),
                ).captured.single
                as EnvelopeDto;
        expect(captured.categoryGroupId, equals('cg-2'));
      });

      test('throws when envelope not found anywhere', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => null);
        when(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).thenThrow(const EnvelopeApiException('not found'));

        expect(
          () => repository.moveEnvelope(
            envelopeId: 'env-1',
            newCategoryGroupId: 'cg-2',
          ),
          throwsA(isA<EnvelopeException>()),
        );
      });

      test('throws on API update failure', () async {
        when(
          () => envelopesDao.getEnvelope('env-1'),
        ).thenAnswer((_) async => testLocalEnvelope);
        when(
          () => envelopesApiClient.updateEnvelope(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.moveEnvelope(
            envelopeId: 'env-1',
            newCategoryGroupId: 'cg-2',
          ),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('reorderEnvelopes', () {
      test(
        'updates sort_order for each envelope via API and '
        'batch caches',
        () async {
          final dto2 = testEnvelopeDto.copyWith(
            id: 'env-2',
            name: 'Groceries',
          );

          when(
            () => envelopesApiClient.getEnvelope('env-2'),
          ).thenAnswer((_) async => dto2);
          when(
            () => envelopesApiClient.getEnvelope('env-1'),
          ).thenAnswer((_) async => testEnvelopeDto);
          when(
            () => envelopesApiClient.updateEnvelope(any()),
          ).thenAnswer((inv) async {
            return inv.positionalArguments.first as EnvelopeDto;
          });
          when(
            () => envelopesDao.batchInsertEnvelopes(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer((_) async {});

          await repository.reorderEnvelopes(['env-2', 'env-1']);

          verify(
            () => envelopesApiClient.updateEnvelope(any()),
          ).called(2);
          verify(
            () => envelopesDao.batchInsertEnvelopes(
              any(),
              mode: InsertMode.insertOrReplace,
            ),
          ).called(1);
        },
      );

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.getEnvelope('env-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.reorderEnvelopes(['env-1']),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('refreshEnvelopes', () {
      test('fetches from API and batch caches all', () async {
        when(
          () => envelopesApiClient.getEnvelopesByBudget('budget-1'),
        ).thenAnswer((_) async => [testEnvelopeDto]);
        when(
          () => envelopesDao.batchInsertEnvelopes(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshEnvelopes('budget-1');

        verify(
          () => envelopesApiClient.getEnvelopesByBudget('budget-1'),
        ).called(1);
        verify(
          () => envelopesDao.batchInsertEnvelopes(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.getEnvelopesByBudget('budget-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.refreshEnvelopes('budget-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    // -----------------------------------------------------------------
    // Allocations
    // -----------------------------------------------------------------
    group('allocate', () {
      test('creates via API, caches, and returns model', () async {
        when(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).thenAnswer((_) async => testAllocationDto);
        when(
          () => envelopesDao.insertAllocation(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.allocate(
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          amount: 100000,
        );

        expect(result.id, equals('alloc-1'));
        expect(result.allocatedAmount, equals(100000));
        verify(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).called(1);
        verify(
          () => envelopesDao.insertAllocation(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.createEnvelopeAllocation(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.allocate(
            envelopeId: 'env-1',
            budgetPeriodId: 'period-1',
            amount: 100000,
          ),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('watchAllocations', () {
      test('streams from local storage mapped to domain models', () {
        when(
          () => envelopesDao.watchAllocationsByPeriodId('period-1'),
        ).thenAnswer(
          (_) => Stream.value([testLocalAllocation]),
        );

        final stream = repository.watchAllocations('period-1');

        expect(
          stream,
          emits(
            isA<List<EnvelopeAllocation>>()
                .having((l) => l.length, 'length', 1)
                .having(
                  (l) => l.first.id,
                  'first.id',
                  'alloc-1',
                ),
          ),
        );
      });
    });

    group('updateAllocation', () {
      test('updates via API and caches locally', () async {
        when(
          () => envelopesApiClient.updateEnvelopeAllocation(any()),
        ).thenAnswer((_) async => testAllocationDto);
        when(
          () => envelopesDao.insertAllocation(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => 1);

        await repository.updateAllocation(testAllocation);

        verify(
          () => envelopesApiClient.updateEnvelopeAllocation(any()),
        ).called(1);
        verify(
          () => envelopesDao.insertAllocation(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.updateEnvelopeAllocation(any()),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.updateAllocation(testAllocation),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    group('deleteAllocation', () {
      test('deletes from API and cleans up local cache', () async {
        when(
          () => envelopesApiClient.deleteEnvelopeAllocation('alloc-1'),
        ).thenAnswer((_) async {});
        when(
          () => envelopesDao.deleteAllocation('alloc-1'),
        ).thenAnswer((_) async => 1);

        await repository.deleteAllocation('alloc-1');

        verify(
          () => envelopesApiClient.deleteEnvelopeAllocation('alloc-1'),
        ).called(1);
        verify(
          () => envelopesDao.deleteAllocation('alloc-1'),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.deleteEnvelopeAllocation('alloc-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.deleteAllocation('alloc-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });

      test('succeeds even when local cleanup fails', () async {
        when(
          () => envelopesApiClient.deleteEnvelopeAllocation('alloc-1'),
        ).thenAnswer((_) async {});
        when(
          () => envelopesDao.deleteAllocation('alloc-1'),
        ).thenThrow(Exception('local error'));

        await repository.deleteAllocation('alloc-1');

        verify(
          () => envelopesApiClient.deleteEnvelopeAllocation('alloc-1'),
        ).called(1);
      });
    });

    group('refreshAllocations', () {
      test('fetches from API and batch caches all', () async {
        when(
          () => envelopesApiClient.getAllocationsByPeriod('period-1'),
        ).thenAnswer((_) async => [testAllocationDto]);
        when(
          () => envelopesDao.batchInsertAllocations(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async {});

        await repository.refreshAllocations('period-1');

        verify(
          () => envelopesApiClient.getAllocationsByPeriod('period-1'),
        ).called(1);
        verify(
          () => envelopesDao.batchInsertAllocations(
            any(),
            mode: InsertMode.insertOrReplace,
          ),
        ).called(1);
      });

      test('throws EnvelopeException on API failure', () async {
        when(
          () => envelopesApiClient.getAllocationsByPeriod('period-1'),
        ).thenThrow(const EnvelopeApiException('API error'));

        expect(
          () => repository.refreshAllocations('period-1'),
          throwsA(isA<EnvelopeException>()),
        );
      });
    });

    // -----------------------------------------------------------------
    // Rollover calculation
    // -----------------------------------------------------------------
    group('calculateRollover', () {
      test('returns positive rollover for unspent funds', () {
        final allocation = EnvelopeAllocation(
          id: 'alloc-1',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 100000,
          spentAmount: 60000,
          rolloverAmount: 5000,
          createdAt: now,
        );

        expect(
          EnvelopeRepository.calculateRollover(allocation),
          equals(45000),
        );
      });

      test('returns negative rollover for overspending', () {
        final allocation = EnvelopeAllocation(
          id: 'alloc-1',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 50000,
          spentAmount: 80000,
          createdAt: now,
        );

        expect(
          EnvelopeRepository.calculateRollover(allocation),
          equals(-30000),
        );
      });

      test('includes previous rollover in calculation', () {
        final allocation = EnvelopeAllocation(
          id: 'alloc-1',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 100000,
          spentAmount: 100000,
          rolloverAmount: 10000,
          createdAt: now,
        );

        expect(
          EnvelopeRepository.calculateRollover(allocation),
          equals(10000),
        );
      });

      test('returns zero when fully spent with no rollover', () {
        final allocation = EnvelopeAllocation(
          id: 'alloc-1',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 100000,
          spentAmount: 100000,
          createdAt: now,
        );

        expect(
          EnvelopeRepository.calculateRollover(allocation),
          equals(0),
        );
      });
    });

    // -----------------------------------------------------------------
    // Exceptions
    // -----------------------------------------------------------------
    group('EnvelopeException', () {
      test('toString includes message', () {
        const exception = EnvelopeException('test error');
        expect(
          exception.toString(),
          equals('EnvelopeException: test error'),
        );
      });

      test('toString includes error when present', () {
        const exception = EnvelopeException(
          'test error',
          error: 'inner error',
        );
        expect(
          exception.toString(),
          equals(
            'EnvelopeException: test error (inner error)',
          ),
        );
      });
    });
  });
}
