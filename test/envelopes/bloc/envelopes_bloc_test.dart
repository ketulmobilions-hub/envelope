import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/envelopes/bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

void main() {
  late MockEnvelopeRepository envelopeRepository;

  final now = DateTime(2024);

  final testGroups = [
    CategoryGroup(
      id: 'group-1',
      budgetId: 'budget-1',
      name: 'Needs',
      createdAt: now,
    ),
    CategoryGroup(
      id: 'group-2',
      budgetId: 'budget-1',
      name: 'Wants',
      createdAt: now,
      sortOrder: 1,
    ),
  ];

  final testEnvelopes = [
    Envelope(
      id: 'env-1',
      categoryGroupId: 'group-1',
      budgetId: 'budget-1',
      name: 'Rent',
      createdAt: now,
    ),
    Envelope(
      id: 'env-2',
      categoryGroupId: 'group-1',
      budgetId: 'budget-1',
      name: 'Groceries',
      createdAt: now,
      sortOrder: 1,
    ),
  ];

  setUp(() {
    envelopeRepository = MockEnvelopeRepository();
  });

  group('EnvelopesBloc', () {
    blocTest<EnvelopesBloc, EnvelopesState>(
      'emits [loading, loaded] when EnvelopesStarted is added',
      build: () {
        when(() => envelopeRepository.watchCategoryGroups('budget-1'))
            .thenAnswer((_) => Stream.value(testGroups));
        when(() => envelopeRepository.watchEnvelopes('budget-1'))
            .thenAnswer((_) => Stream.value(testEnvelopes));
        when(() => envelopeRepository.refreshCategoryGroups('budget-1'))
            .thenAnswer((_) async {});
        when(() => envelopeRepository.refreshEnvelopes('budget-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const EnvelopesStarted()),
      expect: () => [
        const EnvelopesState(status: EnvelopesStatus.loading),
        isA<EnvelopesState>().having(
          (s) => s.status,
          'status',
          anyOf(EnvelopesStatus.loading, EnvelopesStatus.loaded),
        ),
        isA<EnvelopesState>().having(
          (s) => s.status,
          'status',
          EnvelopesStatus.loaded,
        ),
      ],
      verify: (_) {
        verify(
          () => envelopeRepository.watchCategoryGroups('budget-1'),
        ).called(1);
        verify(
          () => envelopeRepository.watchEnvelopes('budget-1'),
        ).called(1);
        verify(
          () => envelopeRepository.refreshCategoryGroups('budget-1'),
        ).called(1);
        verify(
          () => envelopeRepository.refreshEnvelopes('budget-1'),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'still loads from local stream when refresh fails',
      build: () {
        when(() => envelopeRepository.watchCategoryGroups('budget-1'))
            .thenAnswer((_) => Stream.value(testGroups));
        when(() => envelopeRepository.watchEnvelopes('budget-1'))
            .thenAnswer((_) => Stream.value(testEnvelopes));
        when(() => envelopeRepository.refreshCategoryGroups('budget-1'))
            .thenThrow(const EnvelopeException('Network error'));
        when(() => envelopeRepository.refreshEnvelopes('budget-1'))
            .thenThrow(const EnvelopeException('Network error'));
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const EnvelopesStarted()),
      expect: () => [
        const EnvelopesState(status: EnvelopesStatus.loading),
        isA<EnvelopesState>()
            .having((s) => s.categoryGroups, 'categoryGroups', isNotEmpty),
        isA<EnvelopesState>()
            .having((s) => s.status, 'status', EnvelopesStatus.loaded),
      ],
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'archives category group when CategoryGroupArchiveToggled is added '
      'with non-archived group',
      build: () {
        when(() => envelopeRepository.archiveCategoryGroup('group-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) =>
          bloc.add(CategoryGroupArchiveToggled(testGroups.first)),
      verify: (_) {
        verify(
          () => envelopeRepository.archiveCategoryGroup('group-1'),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'unarchives category group when CategoryGroupArchiveToggled is added '
      'with archived group',
      build: () {
        when(() => envelopeRepository.unarchiveCategoryGroup('group-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(
        CategoryGroupArchiveToggled(
          testGroups.first.copyWith(isArchived: true),
        ),
      ),
      verify: (_) {
        verify(
          () => envelopeRepository.unarchiveCategoryGroup('group-1'),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'emits error then loaded when category group archive fails',
      build: () {
        when(() => envelopeRepository.archiveCategoryGroup('group-1'))
            .thenThrow(const EnvelopeException('Failed'));
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) =>
          bloc.add(CategoryGroupArchiveToggled(testGroups.first)),
      expect: () => [
        const EnvelopesState(
          status: EnvelopesStatus.error,
          error: EnvelopesError.updateFailed,
        ),
        const EnvelopesState(status: EnvelopesStatus.loaded),
      ],
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'deletes category group when CategoryGroupDeleted is added',
      build: () {
        when(() => envelopeRepository.deleteCategoryGroup('group-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const CategoryGroupDeleted('group-1')),
      verify: (_) {
        verify(
          () => envelopeRepository.deleteCategoryGroup('group-1'),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'emits error then loaded when category group delete fails',
      build: () {
        when(() => envelopeRepository.deleteCategoryGroup('group-1'))
            .thenThrow(const EnvelopeException('Failed'));
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const CategoryGroupDeleted('group-1')),
      expect: () => [
        const EnvelopesState(
          status: EnvelopesStatus.error,
          error: EnvelopesError.deleteFailed,
        ),
        const EnvelopesState(status: EnvelopesStatus.loaded),
      ],
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'archives envelope when EnvelopeArchiveToggled is added '
      'with non-archived envelope',
      build: () {
        when(() => envelopeRepository.archiveEnvelope('env-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(EnvelopeArchiveToggled(testEnvelopes.first)),
      verify: (_) {
        verify(
          () => envelopeRepository.archiveEnvelope('env-1'),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'unarchives envelope when EnvelopeArchiveToggled is added '
      'with archived envelope',
      build: () {
        when(() => envelopeRepository.unarchiveEnvelope('env-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(
        EnvelopeArchiveToggled(
          testEnvelopes.first.copyWith(isArchived: true),
        ),
      ),
      verify: (_) {
        verify(
          () => envelopeRepository.unarchiveEnvelope('env-1'),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'emits error then loaded when envelope archive fails',
      build: () {
        when(() => envelopeRepository.archiveEnvelope('env-1'))
            .thenThrow(const EnvelopeException('Failed'));
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(EnvelopeArchiveToggled(testEnvelopes.first)),
      expect: () => [
        const EnvelopesState(
          status: EnvelopesStatus.error,
          error: EnvelopesError.updateFailed,
        ),
        const EnvelopesState(status: EnvelopesStatus.loaded),
      ],
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'reorders envelopes when EnvelopesReordered is added',
      build: () {
        when(
          () => envelopeRepository.reorderEnvelopes(
            ['env-2', 'env-1'],
          ),
        ).thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) =>
          bloc.add(const EnvelopesReordered(['env-2', 'env-1'])),
      verify: (_) {
        verify(
          () => envelopeRepository.reorderEnvelopes(
            ['env-2', 'env-1'],
          ),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'emits error then loaded when envelope reorder fails',
      build: () {
        when(
          () => envelopeRepository.reorderEnvelopes(any()),
        ).thenThrow(const EnvelopeException('Failed'));
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) =>
          bloc.add(const EnvelopesReordered(['env-2', 'env-1'])),
      expect: () => [
        const EnvelopesState(
          status: EnvelopesStatus.error,
          error: EnvelopesError.reorderFailed,
        ),
        const EnvelopesState(status: EnvelopesStatus.loaded),
      ],
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'deletes envelope when EnvelopeDeleted is added',
      build: () {
        when(() => envelopeRepository.deleteEnvelope('env-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const EnvelopeDeleted('env-1')),
      verify: (_) {
        verify(
          () => envelopeRepository.deleteEnvelope('env-1'),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'emits error then loaded when envelope delete fails',
      build: () {
        when(() => envelopeRepository.deleteEnvelope('env-1'))
            .thenThrow(const EnvelopeException('Failed'));
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const EnvelopeDeleted('env-1')),
      expect: () => [
        const EnvelopesState(
          status: EnvelopesStatus.error,
          error: EnvelopesError.deleteFailed,
        ),
        const EnvelopesState(status: EnvelopesStatus.loaded),
      ],
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'reorders category groups when CategoryGroupsReordered is added',
      build: () {
        when(
          () => envelopeRepository.reorderCategoryGroups(
            ['group-2', 'group-1'],
          ),
        ).thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) =>
          bloc.add(const CategoryGroupsReordered(['group-2', 'group-1'])),
      verify: (_) {
        verify(
          () => envelopeRepository.reorderCategoryGroups(
            ['group-2', 'group-1'],
          ),
        ).called(1);
      },
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'emits error then loaded when reorder fails',
      build: () {
        when(
          () => envelopeRepository.reorderCategoryGroups(any()),
        ).thenThrow(const EnvelopeException('Failed'));
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) =>
          bloc.add(const CategoryGroupsReordered(['group-2', 'group-1'])),
      expect: () => [
        const EnvelopesState(
          status: EnvelopesStatus.error,
          error: EnvelopesError.reorderFailed,
        ),
        const EnvelopesState(status: EnvelopesStatus.loaded),
      ],
    );

    blocTest<EnvelopesBloc, EnvelopesState>(
      'refreshes data when EnvelopesRefreshRequested is added',
      build: () {
        when(() => envelopeRepository.refreshCategoryGroups('budget-1'))
            .thenAnswer((_) async {});
        when(() => envelopeRepository.refreshEnvelopes('budget-1'))
            .thenAnswer((_) async {});
        return EnvelopesBloc(
          envelopeRepository: envelopeRepository,
          budgetId: 'budget-1',
        );
      },
      act: (bloc) => bloc.add(const EnvelopesRefreshRequested()),
      verify: (_) {
        verify(
          () => envelopeRepository.refreshCategoryGroups('budget-1'),
        ).called(1);
        verify(
          () => envelopeRepository.refreshEnvelopes('budget-1'),
        ).called(1);
      },
    );
  });

  group('EnvelopesState', () {
    test('activeGroupsWithEnvelopes groups envelopes by sorted group', () {
      final state = EnvelopesState(
        status: EnvelopesStatus.loaded,
        categoryGroups: testGroups,
        envelopes: testEnvelopes,
      );

      final active = state.activeGroupsWithEnvelopes;
      expect(active.length, equals(2));
      expect(active.first.$1.id, equals('group-1'));
      expect(active.first.$2.length, equals(2));
      expect(active[1].$2, isEmpty);
    });

    test('activeGroupsWithEnvelopes excludes archived groups and envelopes',
        () {
      final state = EnvelopesState(
        status: EnvelopesStatus.loaded,
        categoryGroups: [
          ...testGroups,
          CategoryGroup(
            id: 'group-archived',
            budgetId: 'budget-1',
            name: 'Archived Group',
            createdAt: now,
            isArchived: true,
          ),
        ],
        envelopes: [
          ...testEnvelopes,
          Envelope(
            id: 'env-archived',
            categoryGroupId: 'group-1',
            budgetId: 'budget-1',
            name: 'Archived Env',
            createdAt: now,
            isArchived: true,
          ),
        ],
      );

      final active = state.activeGroupsWithEnvelopes;
      expect(active.length, equals(2));
      expect(active.first.$2.length, equals(2)); // archived env excluded
    });

    test('archivedGroups returns only archived category groups', () {
      final state = EnvelopesState(
        categoryGroups: [
          ...testGroups,
          CategoryGroup(
            id: 'group-archived',
            budgetId: 'budget-1',
            name: 'Archived Group',
            createdAt: now,
            isArchived: true,
          ),
        ],
      );

      expect(state.archivedGroups.length, equals(1));
      expect(state.archivedGroups.first.id, equals('group-archived'));
    });

    test('archivedEnvelopes returns only archived envelopes', () {
      final state = EnvelopesState(
        envelopes: [
          ...testEnvelopes,
          Envelope(
            id: 'env-archived',
            categoryGroupId: 'group-1',
            budgetId: 'budget-1',
            name: 'Archived',
            createdAt: now,
            isArchived: true,
          ),
        ],
      );

      expect(state.archivedEnvelopes.length, equals(1));
      expect(state.archivedEnvelopes.first.id, equals('env-archived'));
    });
  });
}
