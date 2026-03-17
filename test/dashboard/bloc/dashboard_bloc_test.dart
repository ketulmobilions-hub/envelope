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

  final period = BudgetPeriod(
    id: 'period-1',
    budgetId: budgetId,
    startDate: DateTime(2024, 6, 1),
    endDate: DateTime(2024, 6, 30),
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
    when(() => budgetRepository.watchBudgetPeriods(any()))
        .thenAnswer((_) => Stream.value([period]));
    when(() => budgetRepository.calculateReadyToAssign(any()))
        .thenAnswer((_) async => 50000);
    when(() => budgetRepository.refreshBudgetPeriods(any()))
        .thenAnswer((_) async {});
    when(() => accountRepository.watchAccounts(any()))
        .thenAnswer((_) => Stream.value(accounts));
    when(() => accountRepository.refreshAccounts(any()))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.watchEnvelopes(any()))
        .thenAnswer((_) => Stream.value([envelope]));
    when(() => envelopeRepository.watchCategoryGroups(any()))
        .thenAnswer((_) => Stream.value([categoryGroup]));
    when(() => envelopeRepository.watchAllocations(any()))
        .thenAnswer((_) => Stream.value([allocation]));
    when(() => envelopeRepository.refreshEnvelopes(any()))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.refreshCategoryGroups(any()))
        .thenAnswer((_) async {});
    when(() => envelopeRepository.refreshAllocations(any()))
        .thenAnswer((_) async {});
    when(() => transactionRepository.watchTransactions(
          budgetId: any(named: 'budgetId'),
        )).thenAnswer((_) => Stream.value(transactions));
    when(() => transactionRepository.refreshTransactions(any()))
        .thenAnswer((_) async {});
  });

  DashboardBloc buildBloc() => DashboardBloc(
        budgetRepository: budgetRepository,
        accountRepository: accountRepository,
        envelopeRepository: envelopeRepository,
        transactionRepository: transactionRepository,
        budgetId: budgetId,
      );

  group('DashboardBloc', () {
    test('initial state is correct', () {
      expect(buildBloc().state, const DashboardState());
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
        when(() => accountRepository.watchAccounts(any()))
            .thenAnswer((_) => Stream.error(Exception('fail')));
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
        final firstCallController =
            StreamController<List<Account>>.broadcast();
        var callCount = 0;
        when(() => accountRepository.watchAccounts(any()))
            .thenAnswer((_) {
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
