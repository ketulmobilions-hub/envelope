import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class _MockBudgetRepository extends Mock implements BudgetRepository {}

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late BudgetRepository budgetRepository;
  late AccountRepository accountRepository;
  late EnvelopeRepository envelopeRepository;
  late TransactionRepository transactionRepository;

  const budgetId = 'budget-1';
  final now = DateTime(2024, 6, 15);

  final budget = Budget(
    id: budgetId,
    ownerId: 'owner-1',
    name: 'My Budget',
    baseCurrency: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  final period = BudgetPeriod(
    id: 'period-1',
    budgetId: budgetId,
    startDate: DateTime(2024, 6, 1),
    endDate: DateTime(2024, 6, 30),
    createdAt: now,
  );

  // Older period for period-navigation tests (May 2024, before `now`).
  final mayPeriod = BudgetPeriod(
    id: 'period-may',
    budgetId: budgetId,
    startDate: DateTime(2024, 5),
    endDate: DateTime(2024, 5, 31),
    createdAt: now,
  );

  final accounts = [
    Account(
      id: 'acc-1',
      budgetId: budgetId,
      name: 'Checking',
      type: 'checking',
      currency: 'USD',
      currentBalance: 50000,
      createdAt: now,
      updatedAt: now,
    ),
    Account(
      id: 'acc-2',
      budgetId: budgetId,
      name: 'Savings',
      type: 'savings',
      currency: 'USD',
      currentBalance: 100000,
      createdAt: now,
      updatedAt: now,
    ),
    Account(
      id: 'acc-3',
      budgetId: budgetId,
      name: 'Archived',
      type: 'checking',
      currency: 'USD',
      currentBalance: 25000,
      isArchived: true,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  final categoryGroup = CategoryGroup(
    id: 'cg-1',
    budgetId: budgetId,
    name: 'Bills',
    createdAt: now,
  );

  final envelope = Envelope(
    id: 'env-1',
    categoryGroupId: 'cg-1',
    budgetId: budgetId,
    name: 'Rent',
    createdAt: now,
  );

  final allocation = EnvelopeAllocation(
    id: 'alloc-1',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-1',
    allocatedAmount: 100000,
    spentAmount: 50000,
    createdAt: now,
  );

  final transactions = [
    Transaction(
      id: 'tx-1',
      budgetId: budgetId,
      accountId: 'acc-1',
      type: 'expense',
      amount: 2500,
      currency: 'USD',
      date: DateTime(2024, 6, 14),
      payee: 'Coffee Shop',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
    Transaction(
      id: 'tx-2',
      budgetId: budgetId,
      accountId: 'acc-1',
      type: 'income',
      amount: 500000,
      currency: 'USD',
      date: DateTime(2024, 6, 15),
      payee: 'Employer',
      createdBy: 'user-1',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    budgetRepository = _MockBudgetRepository();
    accountRepository = _MockAccountRepository();
    envelopeRepository = _MockEnvelopeRepository();
    transactionRepository = _MockTransactionRepository();

    // Default stubs
    when(
      () => budgetRepository.watchBudget(any()),
    ).thenAnswer((_) => Stream.value(budget));
    when(
      () => budgetRepository.watchBudgetPeriods(any()),
    ).thenAnswer((_) => Stream.value([period]));
    when(
      () => budgetRepository.calculateReadyToAssign(any()),
    ).thenAnswer((_) async => 50000);
    when(
      () => budgetRepository.refreshBudgetPeriods(any()),
    ).thenAnswer((_) async {});
    when(
      () => budgetRepository.ensureCurrentPeriod(
        any(),
        asOf: any(named: 'asOf'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => accountRepository.watchAccounts(any()),
    ).thenAnswer((_) => Stream.value(accounts));
    when(
      () => accountRepository.refreshAccounts(any()),
    ).thenAnswer((_) async {});
    when(
      () => envelopeRepository.watchEnvelopes(any()),
    ).thenAnswer((_) => Stream.value([envelope]));
    when(
      () => envelopeRepository.watchCategoryGroups(any()),
    ).thenAnswer((_) => Stream.value([categoryGroup]));
    when(
      () => envelopeRepository.watchAllocations(any()),
    ).thenAnswer((_) => Stream.value([allocation]));
    when(
      () => envelopeRepository.refreshEnvelopes(any()),
    ).thenAnswer((_) async {});
    when(
      () => envelopeRepository.refreshCategoryGroups(any()),
    ).thenAnswer((_) async {});
    when(
      () => envelopeRepository.refreshAllocations(any()),
    ).thenAnswer((_) async {});
    when(
      () => transactionRepository.watchTransactions(
        budgetId: any(named: 'budgetId'),
      ),
    ).thenAnswer((_) => Stream.value(transactions));
    when(
      () => transactionRepository.refreshTransactions(any()),
    ).thenAnswer((_) async {});

    // DashboardBloc merges these remote-change streams on start.
    when(
      () => budgetRepository.onRemoteChange,
    ).thenAnswer((_) => const Stream<void>.empty());
    when(
      () => accountRepository.onRemoteChange,
    ).thenAnswer((_) => const Stream<void>.empty());
    when(
      () => envelopeRepository.onRemoteChange,
    ).thenAnswer((_) => const Stream<void>.empty());
    when(
      () => transactionRepository.onRemoteChange,
    ).thenAnswer((_) => const Stream<void>.empty());
  });

  DashboardBloc buildBloc() => DashboardBloc(
    budgetRepository: budgetRepository,
    accountRepository: accountRepository,
    envelopeRepository: envelopeRepository,
    transactionRepository: transactionRepository,
    budgetId: budgetId,
    // Inject a fixed clock so the fixture period (Jun 2024) is treated as the
    // current period. Without this, real DateTime.now() is after the period's
    // end date, so the bloc calls ensureCurrentPeriod and returns early
    // without selecting a period, computing RTA, or loading allocations.
    now: () => now,
  );

  group('DashboardBloc', () {
    test('initial state is correct', () {
      expect(buildBloc().state, const DashboardState());
    });

    group('period navigation', () {
      blocTest<DashboardBloc, DashboardState>(
        'auto-selects current period and exposes all periods',
        setUp: () {
          when(
            () => budgetRepository.watchBudgetPeriods(any()),
          ).thenAnswer((_) => Stream.value([mayPeriod, period]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const DashboardStarted()),
        wait: const Duration(milliseconds: 100),
        verify: (bloc) {
          expect(bloc.state.selectedPeriod?.id, 'period-1');
          expect(bloc.state.periods.length, 2);
          expect(bloc.state.hasPreviousPeriod, isTrue);
          expect(bloc.state.hasNextPeriod, isFalse);
        },
      );

      blocTest<DashboardBloc, DashboardState>(
        'DashboardPreviousPeriodRequested selects the older period and '
        'rebinds allocations',
        setUp: () {
          when(
            () => budgetRepository.watchBudgetPeriods(any()),
          ).thenAnswer((_) => Stream.value([mayPeriod, period]));
        },
        build: buildBloc,
        act: (bloc) async {
          bloc.add(const DashboardStarted());
          await Future<void>.delayed(const Duration(milliseconds: 50));
          bloc.add(const DashboardPreviousPeriodRequested());
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
        verify: (bloc) {
          expect(bloc.state.selectedPeriod?.id, 'period-may');
          expect(bloc.state.hasNextPeriod, isTrue);
          verify(
            () => envelopeRepository.refreshAllocations('period-may'),
          ).called(1);
        },
      );

      blocTest<DashboardBloc, DashboardState>(
        'DashboardNextPeriodRequested returns to the newer period',
        setUp: () {
          when(
            () => budgetRepository.watchBudgetPeriods(any()),
          ).thenAnswer((_) => Stream.value([mayPeriod, period]));
        },
        build: buildBloc,
        act: (bloc) async {
          bloc.add(const DashboardStarted());
          await Future<void>.delayed(const Duration(milliseconds: 50));
          bloc.add(const DashboardPreviousPeriodRequested());
          await Future<void>.delayed(const Duration(milliseconds: 50));
          bloc.add(const DashboardNextPeriodRequested());
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
        verify: (bloc) {
          expect(bloc.state.selectedPeriod?.id, 'period-1');
        },
      );

      blocTest<DashboardBloc, DashboardState>(
        'next is a no-op at the newest period',
        setUp: () {
          when(
            () => budgetRepository.watchBudgetPeriods(any()),
          ).thenAnswer((_) => Stream.value([mayPeriod, period]));
        },
        build: buildBloc,
        act: (bloc) async {
          bloc.add(const DashboardStarted());
          await Future<void>.delayed(const Duration(milliseconds: 50));
          // Already on the newest (Jun); next should do nothing.
          bloc.add(const DashboardNextPeriodRequested());
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
        verify: (bloc) {
          expect(bloc.state.selectedPeriod?.id, 'period-1');
        },
      );
    });

    blocTest<DashboardBloc, DashboardState>(
      'DashboardStarted emits loading then loaded with data',
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        final state = bloc.state;
        expect(state.status, DashboardStatus.loaded);
        expect(state.accounts, accounts);
        expect(state.recentTransactions, hasLength(2));
        expect(state.readyToAssign, 50000);
        expect(state.selectedPeriod, period);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'totalBalance sums non-archived accounts',
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        // 50000 + 100000 = 150000 (archived 25000 excluded)
        expect(bloc.state.totalBalance, 150000);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'envelopeSummaries pairs envelopes with allocations',
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        final summaries = bloc.state.envelopeSummaries;
        expect(summaries, hasLength(1));
        expect(summaries.first.envelope, envelope);
        expect(summaries.first.allocation, allocation);
        expect(summaries.first.categoryGroupName, 'Bills');
        expect(summaries.first.allocated, 100000);
        expect(summaries.first.spent, 50000);
        expect(summaries.first.available, 50000);
        expect(summaries.first.isOverspent, false);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'recent transactions sorted by date descending, max 5',
      build: buildBloc,
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 100),
      verify: (bloc) {
        final recent = bloc.state.recentTransactions;
        expect(recent.first.id, 'tx-2'); // Jun 15 before Jun 14
        expect(recent.last.id, 'tx-1');
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'DashboardRefreshRequested calls repository refresh methods',
      build: buildBloc,
      seed: () => DashboardState(
        status: DashboardStatus.loaded,
        selectedPeriod: period,
      ),
      act: (bloc) => bloc.add(const DashboardRefreshRequested()),
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(
          () => budgetRepository.refreshBudgetPeriods(budgetId),
        ).called(1);
        verify(
          () => accountRepository.refreshAccounts(budgetId),
        ).called(1);
        verify(
          () => envelopeRepository.refreshEnvelopes(budgetId),
        ).called(1);
        verify(
          () => envelopeRepository.refreshCategoryGroups(budgetId),
        ).called(1);
        verify(
          () => transactionRepository.refreshTransactions(budgetId),
        ).called(1);
        verify(
          () => envelopeRepository.refreshAllocations(period.id),
        ).called(1);
      },
    );

    test(
      'stream error emits error status then clears to loaded',
      () async {
        when(
          () => accountRepository.watchAccounts(any()),
        ).thenAnswer((_) => Stream.error(Exception('fail')));
        final bloc = buildBloc();
        final states = <DashboardState>[];
        final sub = bloc.stream.listen(states.add);

        bloc.add(const DashboardStarted());
        await Future<void>.delayed(const Duration(milliseconds: 200));

        await sub.cancel();
        await bloc.close();

        // Verify an error state was emitted then cleared.
        final errorIdx = states.indexWhere(
          (s) => s.status == DashboardStatus.error,
        );
        expect(errorIdx, greaterThanOrEqualTo(0));
        expect(states[errorIdx].error, DashboardError.loadFailed);

        // The very next state should clear the error.
        expect(states[errorIdx + 1].error, isNull);
        expect(
          states[errorIdx + 1].status,
          DashboardStatus.loaded,
        );
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'calling DashboardStarted twice discards stale stream events',
      build: () {
        final firstCallController = StreamController<List<Account>>.broadcast();
        var callCount = 0;
        when(() => accountRepository.watchAccounts(any())).thenAnswer((_) {
          callCount++;
          if (callCount == 1) {
            return firstCallController.stream;
          }
          return Stream.value(accounts);
        });
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const DashboardStarted());
        await Future<void>.delayed(
          const Duration(milliseconds: 50),
        );
        // Second start increments generation, stale events from
        // first subscription should be discarded.
        bloc.add(const DashboardStarted());
      },
      wait: const Duration(milliseconds: 200),
      verify: (bloc) {
        // Final state should have accounts from the second
        // subscription, not be stuck or corrupted.
        expect(bloc.state.accounts, accounts);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'refreshes RTA when the budget row emits a new openingBalance / '
      'openingDate anchor (#80, phase 4)',
      build: () {
        final controller = StreamController<Budget>();
        when(
          () => budgetRepository.watchBudget(any()),
        ).thenAnswer((_) => controller.stream);

        // Initial-load RTA calls (periods + allocations) return 50000; the
        // anchor-shift recompute returns the distinctive 100000 so the test
        // is robust to load-sequence changes that adjust the initial-call
        // count.
        var calls = 0;
        when(() => budgetRepository.calculateReadyToAssign(any())).thenAnswer(
          (_) async {
            calls++;
            return calls <= 2 ? 50000 : 100000;
          },
        );

        scheduleMicrotask(() async {
          controller.add(budget);
          await Future<void>.delayed(const Duration(milliseconds: 30));
          controller.add(
            budget.copyWith(
              openingBalance: 100000,
              openingDate: DateTime(2024, 6),
            ),
          );
        });

        return buildBloc();
      },
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 150),
      verify: (bloc) {
        expect(bloc.state.readyToAssign, equals(100000));
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'does NOT refresh RTA when an unrelated budget field changes',
      build: () {
        final controller = StreamController<Budget>();
        when(
          () => budgetRepository.watchBudget(any()),
        ).thenAnswer((_) => controller.stream);

        // Initial-load calls return 50000; any extra call (which would only
        // come from `_onBudgetUpdated`) returns the distinctive 999999. State
        // staying at 50000 proves no anchor-shift recompute fired.
        var calls = 0;
        when(() => budgetRepository.calculateReadyToAssign(any())).thenAnswer(
          (_) async {
            calls++;
            return calls <= 2 ? 50000 : 999999;
          },
        );

        scheduleMicrotask(() async {
          controller.add(budget);
          await Future<void>.delayed(const Duration(milliseconds: 30));
          controller.add(budget.copyWith(name: 'Renamed'));
        });

        return buildBloc();
      },
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 150),
      verify: (bloc) {
        expect(bloc.state.readyToAssign, equals(50000));
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'A -> B -> A anchor round-trip refreshes RTA twice (#80, phase 4)',
      build: () {
        final controller = StreamController<Budget>();
        when(
          () => budgetRepository.watchBudget(any()),
        ).thenAnswer((_) => controller.stream);

        final initial = budget.copyWith(
          openingBalance: 50000,
          openingDate: DateTime(2024, 6),
        );
        final shifted = budget.copyWith(
          openingBalance: 200000,
          openingDate: DateTime(2024, 6),
        );

        var calls = 0;
        when(() => budgetRepository.calculateReadyToAssign(any())).thenAnswer(
          (_) async {
            calls++;
            // Initial loads (periods + allocations) → 50000. Anchor shifts
            // come next: B (3rd call) then back to A (4th call).
            return switch (calls) {
              <= 2 => 50000,
              3 => 200000,
              _ => 75000,
            };
          },
        );

        scheduleMicrotask(() async {
          controller.add(initial);
          await Future<void>.delayed(const Duration(milliseconds: 30));
          controller.add(shifted);
          await Future<void>.delayed(const Duration(milliseconds: 30));
          controller.add(initial);
        });

        return buildBloc();
      },
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 200),
      verify: (bloc) {
        expect(bloc.state.readyToAssign, equals(75000));
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'anchor shift BEFORE periods land is picked up by initial RTA call '
      '(#80, phase 4 race)',
      build: () {
        // Emit two distinct anchors via the budget stream BEFORE we ever
        // expose periods. The `_onPeriodsUpdated` initial computation should
        // produce RTA using whichever budget state `calculateReadyToAssign`
        // sees at that point — phase 3 guarantees the repo reads fresh data.
        final budgetController = StreamController<Budget>();
        final periodsController = StreamController<List<BudgetPeriod>>();
        when(
          () => budgetRepository.watchBudget(any()),
        ).thenAnswer((_) => budgetController.stream);
        when(
          () => budgetRepository.watchBudgetPeriods(any()),
        ).thenAnswer((_) => periodsController.stream);

        when(
          () => budgetRepository.calculateReadyToAssign(any()),
        ).thenAnswer((_) async => 314159);

        scheduleMicrotask(() async {
          budgetController.add(budget);
          await Future<void>.delayed(const Duration(milliseconds: 10));
          budgetController.add(
            budget.copyWith(
              openingBalance: 500000,
              openingDate: DateTime(2024, 6),
            ),
          );
          await Future<void>.delayed(const Duration(milliseconds: 10));
          periodsController.add([period]);
        });

        return buildBloc();
      },
      act: (bloc) => bloc.add(const DashboardStarted()),
      wait: const Duration(milliseconds: 200),
      verify: (bloc) {
        // RTA reflects the initial post-load value; the new anchor was
        // observed via the cached value but no extra recompute fired because
        // periods landed AFTER all budget emissions (the periods handler runs
        // calculateReadyToAssign once with the latest budget state).
        expect(bloc.state.readyToAssign, equals(314159));
        expect(bloc.state.selectedPeriod?.id, equals('period-1'));
      },
    );
  });

  group('EnvelopeSummary', () {
    test('isOverspent returns true when available < 0', () {
      final overspent = EnvelopeSummary(
        envelope: envelope,
        categoryGroupName: 'Bills',
        allocation: EnvelopeAllocation(
          id: 'alloc-2',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 5000,
          spentAmount: 10000,
          createdAt: now,
        ),
      );
      expect(overspent.isOverspent, true);
      expect(overspent.available, -5000);
    });

    test('available includes rollover', () {
      final withRollover = EnvelopeSummary(
        envelope: envelope,
        categoryGroupName: 'Bills',
        allocation: EnvelopeAllocation(
          id: 'alloc-3',
          envelopeId: 'env-1',
          budgetPeriodId: 'period-1',
          allocatedAmount: 5000,
          spentAmount: 3000,
          rolloverAmount: 1000,
          createdAt: now,
        ),
      );
      expect(withRollover.available, 3000); // 5000 - 3000 + 1000
    });
  });
}
