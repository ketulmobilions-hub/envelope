import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class FakeEnvelopeAllocation extends Fake implements EnvelopeAllocation {}

void main() {
  late MockBudgetRepository budgetRepository;
  late MockEnvelopeRepository envelopeRepository;

  final now = DateTime(2026, 3, 13);

  final testPeriod = BudgetPeriod(
    id: 'period-1',
    budgetId: 'budget-1',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 31),
    createdAt: now,
  );

  final testGroups = [
    CategoryGroup(
      id: 'group-1',
      budgetId: 'budget-1',
      name: 'Needs',
      createdAt: now,
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

  final testAllocations = [
    EnvelopeAllocation(
      id: 'alloc-1',
      envelopeId: 'env-1',
      budgetPeriodId: 'period-1',
      allocatedAmount: 100000,
      createdAt: now,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeEnvelopeAllocation());
  });

  setUp(() {
    budgetRepository = MockBudgetRepository();
    envelopeRepository = MockEnvelopeRepository();
  });

  void stubHappyPath() {
    when(() => budgetRepository.watchBudgetPeriods('budget-1'))
        .thenAnswer((_) => Stream.value([testPeriod]));
    when(() => envelopeRepository.watchCategoryGroups('budget-1'))
        .thenAnswer((_) => Stream.value(testGroups));
    when(() => envelopeRepository.watchEnvelopes('budget-1'))
        .thenAnswer((_) => Stream.value(testEnvelopes));
    when(() => budgetRepository.watchAllocationTemplates('budget-1'))
        .thenAnswer((_) => Stream.value([]));
    when(() => envelopeRepository.watchAllocations('period-1'))
        .thenAnswer((_) => Stream.value(testAllocations));

    when(() => budgetRepository.refreshBudgetPeriods('budget-1'))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.refreshCategoryGroups('budget-1'))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.refreshEnvelopes('budget-1'))
        .thenAnswer((_) async {});
    when(() => budgetRepository.refreshAllocationTemplates('budget-1'))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.refreshAllocations('period-1'))
        .thenAnswer((_) async {});
    when(() => budgetRepository.calculateReadyToAssign('period-1'))
        .thenAnswer((_) async => 50000);
  }

  BudgetBloc buildBloc() => BudgetBloc(
        budgetRepository: budgetRepository,
        envelopeRepository: envelopeRepository,
        budgetId: 'budget-1',
      );

  group('BudgetBloc', () {
    group('BudgetStarted', () {
      blocTest<BudgetBloc, BudgetState>(
        'transitions to loaded and sets selectedPeriod',
        setUp: stubHappyPath,
        build: buildBloc,
        act: (bloc) => bloc.add(const BudgetStarted()),
        verify: (bloc) {
          expect(bloc.state.status, BudgetStatus.loaded);
          expect(bloc.state.selectedPeriod?.id, 'period-1');
          expect(bloc.state.categoryGroups, testGroups);
          expect(bloc.state.envelopes, testEnvelopes);
          expect(bloc.state.readyToAssign, 50000);
        },
      );

      blocTest<BudgetBloc, BudgetState>(
        'calls all refresh methods',
        setUp: stubHappyPath,
        build: buildBloc,
        act: (bloc) => bloc.add(const BudgetStarted()),
        verify: (_) {
          verify(
            () => budgetRepository.refreshBudgetPeriods('budget-1'),
          ).called(1);
          verify(
            () => envelopeRepository.refreshCategoryGroups('budget-1'),
          ).called(1);
          verify(
            () => envelopeRepository.refreshEnvelopes('budget-1'),
          ).called(1);
          verify(
            () => budgetRepository.refreshAllocationTemplates('budget-1'),
          ).called(1);
        },
      );

      blocTest<BudgetBloc, BudgetState>(
        'emits loading as the first state then reaches loaded',
        setUp: stubHappyPath,
        build: buildBloc,
        act: (bloc) => bloc.add(const BudgetStarted()),
        expect: () => [
          BudgetState(status: BudgetStatus.loading),
          // additional states as the 4 budget-level streams + allocations arrive
          isA<BudgetState>(),
          isA<BudgetState>(),
          isA<BudgetState>(),
          isA<BudgetState>(),
        ],
        verify: (bloc) {
          expect(bloc.state.status, BudgetStatus.loaded);
        },
      );
    });

    group('AllocationAmountChanged', () {
      blocTest<BudgetBloc, BudgetState>(
        'updates localAllocations without server call',
        build: buildBloc,
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          selectedPeriod: testPeriod,
          allocations: testAllocations,
          readyToAssign: 50000,
        ),
        act: (bloc) => bloc.add(
          const AllocationAmountChanged(envelopeId: 'env-1', amount: 120000),
        ),
        expect: () => [
          isA<BudgetState>().having(
            (s) => s.localAllocations['env-1'],
            'localAllocations[env-1]',
            120000,
          ),
        ],
        verify: (_) {
          // No repository interaction for local edits.
          verifyNever(() => envelopeRepository.updateAllocation(any()));
          verifyNever(
            () => envelopeRepository.allocate(
              envelopeId: any(named: 'envelopeId'),
              budgetPeriodId: any(named: 'budgetPeriodId'),
              amount: any(named: 'amount'),
            ),
          );
        },
      );

      test('localReadyToAssign decreases when amount increases', () {
        final state = BudgetState(
          status: BudgetStatus.loaded,
          selectedPeriod: testPeriod,
          allocations: testAllocations, // env-1 allocated 100000
          readyToAssign: 50000,
          localAllocations: const {'env-1': 120000}, // +20000 delta
        );
        expect(state.localReadyToAssign, equals(30000));
      });

      test('isOverAllocated true when localReadyToAssign is negative', () {
        final state = BudgetState(
          readyToAssign: 5000,
          localAllocations: const {'env-new': 10000},
        );
        expect(state.isOverAllocated, isTrue);
      });
    });

    group('AllocationsSaveRequested', () {
      blocTest<BudgetBloc, BudgetState>(
        'updates existing allocation and clears localAllocations',
        build: buildBloc,
        setUp: () {
          when(
            () => envelopeRepository.updateAllocation(any()),
          ).thenAnswer((_) async {});
        },
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          selectedPeriod: testPeriod,
          allocations: testAllocations,
          localAllocations: const {'env-1': 150000},
        ),
        act: (bloc) => bloc.add(const AllocationsSaveRequested()),
        expect: () => [
          isA<BudgetState>().having(
            (s) => s.localAllocations,
            'localAllocations',
            isEmpty,
          ),
        ],
        verify: (_) {
          verify(() => envelopeRepository.updateAllocation(any())).called(1);
        },
      );

      blocTest<BudgetBloc, BudgetState>(
        'creates new allocation when no existing record',
        build: buildBloc,
        setUp: () {
          when(
            () => envelopeRepository.allocate(
              envelopeId: any(named: 'envelopeId'),
              budgetPeriodId: any(named: 'budgetPeriodId'),
              amount: any(named: 'amount'),
            ),
          ).thenAnswer((_) async => testAllocations.first);
        },
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          selectedPeriod: testPeriod,
          localAllocations: const {'env-2': 50000},
        ),
        act: (bloc) => bloc.add(const AllocationsSaveRequested()),
        expect: () => [
          isA<BudgetState>().having(
            (s) => s.localAllocations,
            'localAllocations',
            isEmpty,
          ),
        ],
        verify: (_) {
          verify(
            () => envelopeRepository.allocate(
              envelopeId: 'env-2',
              budgetPeriodId: 'period-1',
              amount: 50000,
            ),
          ).called(1);
        },
      );

      blocTest<BudgetBloc, BudgetState>(
        'emits error then loaded on EnvelopeException',
        build: buildBloc,
        setUp: () {
          when(
            () => envelopeRepository.updateAllocation(any()),
          ).thenThrow(const EnvelopeException('fail'));
        },
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          selectedPeriod: testPeriod,
          allocations: testAllocations,
          localAllocations: const {'env-1': 150000},
        ),
        act: (bloc) => bloc.add(const AllocationsSaveRequested()),
        expect: () => [
          isA<BudgetState>().having(
            (s) => s.error,
            'error',
            BudgetError.allocationFailed,
          ),
          isA<BudgetState>()
              .having((s) => s.status, 'status', BudgetStatus.loaded)
              .having((s) => s.error, 'error', isNull),
        ],
      );

      blocTest<BudgetBloc, BudgetState>(
        'does nothing when no period selected',
        build: buildBloc,
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          localAllocations: const {'env-1': 5000},
        ),
        act: (bloc) => bloc.add(const AllocationsSaveRequested()),
        expect: () => <BudgetState>[],
      );
    });

    group('BudgetPreviousPeriodRequested', () {
      final period2 = BudgetPeriod(
        id: 'period-2',
        budgetId: 'budget-1',
        startDate: DateTime(2026, 4, 1),
        endDate: DateTime(2026, 4, 30),
        createdAt: now,
      );

      blocTest<BudgetBloc, BudgetState>(
        'navigates to previous period and clears local state',
        build: buildBloc,
        setUp: () {
          when(() => envelopeRepository.watchAllocations('period-1'))
              .thenAnswer((_) => Stream.value([]));
          when(() => envelopeRepository.refreshAllocations('period-1'))
              .thenAnswer((_) async {});
          when(() => budgetRepository.calculateReadyToAssign('period-1'))
              .thenAnswer((_) async => 0);
        },
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          periods: [testPeriod, period2],
          selectedPeriod: period2,
          allocations: testAllocations,
          localAllocations: const {'env-1': 999},
        ),
        act: (bloc) => bloc.add(const BudgetPreviousPeriodRequested()),
        verify: (bloc) {
          expect(bloc.state.selectedPeriod?.id, 'period-1');
          expect(bloc.state.localAllocations, isEmpty);
          expect(bloc.state.allocations, isEmpty);
        },
      );

      blocTest<BudgetBloc, BudgetState>(
        'does nothing when already at first period',
        build: buildBloc,
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          periods: [testPeriod],
          selectedPeriod: testPeriod,
        ),
        act: (bloc) => bloc.add(const BudgetPreviousPeriodRequested()),
        expect: () => <BudgetState>[],
      );
    });

    group('BudgetNextPeriodRequested', () {
      final period2 = BudgetPeriod(
        id: 'period-2',
        budgetId: 'budget-1',
        startDate: DateTime(2026, 4, 1),
        endDate: DateTime(2026, 4, 30),
        createdAt: now,
      );

      blocTest<BudgetBloc, BudgetState>(
        'navigates to next period',
        build: buildBloc,
        setUp: () {
          when(() => envelopeRepository.watchAllocations('period-2'))
              .thenAnswer((_) => Stream.value([]));
          when(() => envelopeRepository.refreshAllocations('period-2'))
              .thenAnswer((_) async {});
          when(() => budgetRepository.calculateReadyToAssign('period-2'))
              .thenAnswer((_) async => 0);
        },
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          periods: [testPeriod, period2],
          selectedPeriod: testPeriod,
        ),
        act: (bloc) => bloc.add(const BudgetNextPeriodRequested()),
        verify: (bloc) {
          expect(bloc.state.selectedPeriod?.id, 'period-2');
        },
      );

      blocTest<BudgetBloc, BudgetState>(
        'does nothing when already at last period',
        build: buildBloc,
        seed: () => BudgetState(
          status: BudgetStatus.loaded,
          periods: [testPeriod],
          selectedPeriod: testPeriod,
        ),
        act: (bloc) => bloc.add(const BudgetNextPeriodRequested()),
        expect: () => <BudgetState>[],
      );
    });

    group('EnvelopeTransferRequested', () {
      blocTest<BudgetBloc, BudgetState>(
        'calls transferBetweenEnvelopes on repository',
        build: buildBloc,
        setUp: () {
          when(
            () => budgetRepository.transferBetweenEnvelopes(
              fromAllocationId: any(named: 'fromAllocationId'),
              toAllocationId: any(named: 'toAllocationId'),
              amount: any(named: 'amount'),
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => BudgetState(status: BudgetStatus.loaded),
        act: (bloc) => bloc.add(
          const EnvelopeTransferRequested(
            fromAllocationId: 'alloc-1',
            toAllocationId: 'alloc-2',
            amount: 5000,
          ),
        ),
        expect: () => <BudgetState>[],
        verify: (_) {
          verify(
            () => budgetRepository.transferBetweenEnvelopes(
              fromAllocationId: 'alloc-1',
              toAllocationId: 'alloc-2',
              amount: 5000,
            ),
          ).called(1);
        },
      );

      blocTest<BudgetBloc, BudgetState>(
        'emits error then loaded on BudgetException',
        build: buildBloc,
        setUp: () {
          when(
            () => budgetRepository.transferBetweenEnvelopes(
              fromAllocationId: any(named: 'fromAllocationId'),
              toAllocationId: any(named: 'toAllocationId'),
              amount: any(named: 'amount'),
            ),
          ).thenThrow(const BudgetException('fail'));
        },
        seed: () => BudgetState(status: BudgetStatus.loaded),
        act: (bloc) => bloc.add(
          const EnvelopeTransferRequested(
            fromAllocationId: 'alloc-1',
            toAllocationId: 'alloc-2',
            amount: 5000,
          ),
        ),
        expect: () => [
          isA<BudgetState>().having(
            (s) => s.error,
            'error',
            BudgetError.transferFailed,
          ),
          isA<BudgetState>()
              .having((s) => s.status, 'status', BudgetStatus.loaded)
              .having((s) => s.error, 'error', isNull),
        ],
      );
    });

    group('AllocationTemplateDeleted', () {
      blocTest<BudgetBloc, BudgetState>(
        'calls deleteAllocationTemplate on repository',
        build: buildBloc,
        setUp: () {
          when(() => budgetRepository.deleteAllocationTemplate('tpl-1'))
              .thenAnswer((_) async {});
        },
        seed: () => BudgetState(status: BudgetStatus.loaded),
        act: (bloc) => bloc.add(const AllocationTemplateDeleted('tpl-1')),
        expect: () => <BudgetState>[],
        verify: (_) {
          verify(
            () => budgetRepository.deleteAllocationTemplate('tpl-1'),
          ).called(1);
        },
      );
    });

    group('BudgetState computed properties', () {
      test('localReadyToAssign returns readyToAssign when no local edits', () {
        final state = BudgetState(readyToAssign: 50000);
        expect(state.localReadyToAssign, equals(50000));
      });

      test('localReadyToAssign deducts new allocations (no server record)', () {
        final state = BudgetState(
          readyToAssign: 50000,
          localAllocations: const {'env-new': 20000},
        );
        expect(state.localReadyToAssign, equals(30000));
      });

      test('localReadyToAssign applies delta for edited existing allocation', () {
        final state = BudgetState(
          readyToAssign: 50000,
          allocations: [
            EnvelopeAllocation(
              id: 'a1',
              envelopeId: 'env-1',
              budgetPeriodId: 'p1',
              allocatedAmount: 10000,
              createdAt: DateTime(2026),
            ),
          ],
          localAllocations: const {'env-1': 15000},
        );
        // server delta: 15000 - 10000 = 5000 more allocated
        expect(state.localReadyToAssign, equals(45000));
      });

      test('isOverAllocated is true when localReadyToAssign is negative', () {
        final state = BudgetState(
          readyToAssign: 5000,
          localAllocations: const {'env-new': 10000},
        );
        expect(state.isOverAllocated, isTrue);
      });

      test('isOverAllocated is false when exactly zero', () {
        final state = BudgetState(
          readyToAssign: 10000,
          localAllocations: const {'env-new': 10000},
        );
        expect(state.isOverAllocated, isFalse);
      });

      test('hasPreviousPeriod and hasNextPeriod at single period', () {
        final period = BudgetPeriod(
          id: 'p1',
          budgetId: 'b1',
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
          createdAt: DateTime(2026),
        );
        final state = BudgetState(
          periods: [period],
          selectedPeriod: period,
        );
        expect(state.hasPreviousPeriod, isFalse);
        expect(state.hasNextPeriod, isFalse);
      });

      test('hasPreviousPeriod is true when not at first period', () {
        final p1 = BudgetPeriod(
          id: 'p1',
          budgetId: 'b1',
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
          createdAt: DateTime(2026),
        );
        final p2 = BudgetPeriod(
          id: 'p2',
          budgetId: 'b1',
          startDate: DateTime(2026, 2, 1),
          endDate: DateTime(2026, 2, 28),
          createdAt: DateTime(2026),
        );
        final state = BudgetState(periods: [p1, p2], selectedPeriod: p2);
        expect(state.hasPreviousPeriod, isTrue);
        expect(state.hasNextPeriod, isFalse);
      });
    });
  });
}
