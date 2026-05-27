import 'package:account_repository/account_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockEnvelopeRepository envelopeRepository;
  late MockTransactionRepository transactionRepository;
  late MockBudgetRepository budgetRepository;
  late MockAccountRepository accountRepository;

  final now = DateTime(2026, 5, 25);
  final apr5 = DateTime(2026, 4, 5);
  final may5 = DateTime(2026, 5, 5);

  final testEnvelope = Envelope(
    id: 'env-1',
    categoryGroupId: 'group-1',
    budgetId: 'budget-1',
    name: 'Rent',
    createdAt: apr5,
  );

  final aprPeriod = BudgetPeriod(
    id: 'period-apr',
    budgetId: 'budget-1',
    startDate: DateTime(2026, 4),
    endDate: DateTime(2026, 4, 30),
    createdAt: apr5,
  );
  final mayPeriod = BudgetPeriod(
    id: 'period-may',
    budgetId: 'budget-1',
    startDate: DateTime(2026, 5),
    endDate: DateTime(2026, 5, 31),
    createdAt: apr5,
  );

  final aprAllocation = EnvelopeAllocation(
    id: 'alloc-apr',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-apr',
    allocatedAmount: 0,
    spentAmount: 2000,
    createdAt: apr5,
  );
  final mayAllocation = EnvelopeAllocation(
    id: 'alloc-may',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-may',
    allocatedAmount: 0,
    spentAmount: 2000,
    createdAt: apr5,
  );

  final aprTxn = Transaction(
    id: 'txn-apr',
    budgetId: 'budget-1',
    accountId: 'acc-1',
    type: 'expense',
    amount: 2000,
    currency: 'USD',
    date: apr5,
    createdBy: 'user-1',
    envelopeId: 'env-1',
    createdAt: apr5,
    updatedAt: apr5,
  );
  final mayTxn = Transaction(
    id: 'txn-may',
    budgetId: 'budget-1',
    accountId: 'acc-1',
    type: 'expense',
    amount: 2000,
    currency: 'USD',
    date: may5,
    createdBy: 'user-1',
    envelopeId: 'env-1',
    createdAt: may5,
    updatedAt: may5,
  );

  setUp(() {
    envelopeRepository = MockEnvelopeRepository();
    transactionRepository = MockTransactionRepository();
    budgetRepository = MockBudgetRepository();
    accountRepository = MockAccountRepository();

    when(
      () => transactionRepository.watchTransactions(
        budgetId: any(named: 'budgetId'),
        envelopeId: any(named: 'envelopeId'),
      ),
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => transactionRepository.refreshTransactions(any()),
    ).thenAnswer((_) async {});
    when(
      () => budgetRepository.watchBudgetPeriods(any()),
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => envelopeRepository.watchAllocationsForEnvelope(any()),
    ).thenAnswer((_) => const Stream.empty());
  });

  EnvelopeDetailCubit buildCubit({DateTime Function()? clock}) {
    return EnvelopeDetailCubit(
      envelopeRepository: envelopeRepository,
      transactionRepository: transactionRepository,
      budgetRepository: budgetRepository,
      accountRepository: accountRepository,
      envelope: testEnvelope,
      now: clock ?? () => now,
    );
  }

  group('EnvelopeDetailCubit', () {
    test('initial state exposes the envelope and empty groups', () {
      final cubit = buildCubit();

      expect(cubit.state.envelope, equals(testEnvelope));
      expect(cubit.state.periods, isEmpty);
      expect(cubit.state.allocations, isEmpty);
      expect(cubit.state.transactions, isEmpty);
      expect(cubit.state.groups, isEmpty);
      expect(cubit.state.currentGroup, isNull);
      expect(cubit.state.isCreditCardEnvelope, isFalse);
      addTearDown(cubit.close);
    });

    test('CC Payment envelope exposes due and available credit', () async {
      final ccEnvelope = Envelope(
        id: 'cc-env',
        categoryGroupId: 'group-1',
        budgetId: 'budget-1',
        name: 'Visa Payment',
        createdAt: apr5,
        linkedAccountId: 'acc-cc',
      );
      final ccAccount = Account(
        id: 'acc-cc',
        budgetId: 'budget-1',
        name: 'Visa',
        type: 'credit_card',
        currency: 'USD',
        currentBalance: -300000, // owes 3,000.00
        createdAt: apr5,
        updatedAt: apr5,
      );
      when(
        () => transactionRepository.watchTransactions(
          budgetId: any(named: 'budgetId'),
          accountId: any(named: 'accountId'),
          envelopeId: any(named: 'envelopeId'),
        ),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => accountRepository.watchAccounts('budget-1'),
      ).thenAnswer((_) => Stream.value([ccAccount]));
      when(
        () => accountRepository.getDebtAccount('acc-cc'),
      ).thenAnswer(
        (_) async => const DebtAccount(
          accountId: 'acc-cc',
          interestRate: 0,
          minimumPayment: 0,
          originalBalance: 0,
          creditLimit: 500000,
        ),
      );

      final cubit = EnvelopeDetailCubit(
        envelopeRepository: envelopeRepository,
        transactionRepository: transactionRepository,
        budgetRepository: budgetRepository,
        accountRepository: accountRepository,
        envelope: ccEnvelope,
        now: () => now,
      );
      addTearDown(cubit.close);

      await cubit.stream.firstWhere(
        (s) => s.linkedAccount != null && s.ccCreditLimit != null,
      );

      expect(cubit.state.isCreditCardEnvelope, isTrue);
      expect(cubit.state.ccDueCents, 300000);
      // 500000 limit + (-300000) balance = 200000 available credit.
      expect(cubit.state.ccAvailableCreditCents, 200000);
    });

    blocTest<EnvelopeDetailCubit, EnvelopeDetailState>(
      'currentPeriodId is set to the period containing now',
      setUp: () {
        when(
          () => budgetRepository.watchBudgetPeriods(any()),
        ).thenAnswer((_) => Stream.value([aprPeriod, mayPeriod]));
      },
      build: buildCubit,
      verify: (cubit) {
        expect(cubit.state.currentPeriodId, mayPeriod.id);
      },
    );

    blocTest<EnvelopeDetailCubit, EnvelopeDetailState>(
      'groups one section per period with allocations or transactions',
      setUp: () {
        when(
          () => budgetRepository.watchBudgetPeriods(any()),
        ).thenAnswer((_) => Stream.value([aprPeriod, mayPeriod]));
        when(
          () => envelopeRepository.watchAllocationsForEnvelope(any()),
        ).thenAnswer((_) => Stream.value([aprAllocation, mayAllocation]));
        when(
          () => transactionRepository.watchTransactions(
            budgetId: any(named: 'budgetId'),
            envelopeId: any(named: 'envelopeId'),
          ),
        ).thenAnswer((_) => Stream.value([aprTxn, mayTxn]));
      },
      build: buildCubit,
      verify: (cubit) {
        final groups = cubit.state.groups;
        expect(groups, hasLength(2));
        // Newest first.
        expect(groups[0].period?.id, mayPeriod.id);
        expect(groups[1].period?.id, aprPeriod.id);
        // Per-period bucket of transactions.
        expect(groups[0].transactions, [mayTxn]);
        expect(groups[1].transactions, [aprTxn]);
        // Per-period spent comes from the period's own allocation.
        expect(groups[0].spent, 2000);
        expect(groups[1].spent, 2000);
        // current group flagged correctly.
        expect(cubit.state.currentGroup?.period?.id, mayPeriod.id);
      },
    );

    blocTest<EnvelopeDetailCubit, EnvelopeDetailState>(
      'transactions outside every period fall into an uncategorized group',
      setUp: () {
        final stray = aprTxn.copyWith(
          id: 'txn-stray',
          date: DateTime(2025, 12, 31),
        );
        when(
          () => budgetRepository.watchBudgetPeriods(any()),
        ).thenAnswer((_) => Stream.value([mayPeriod]));
        when(
          () => transactionRepository.watchTransactions(
            budgetId: any(named: 'budgetId'),
            envelopeId: any(named: 'envelopeId'),
          ),
        ).thenAnswer((_) => Stream.value([stray, mayTxn]));
      },
      build: buildCubit,
      verify: (cubit) {
        final groups = cubit.state.groups;
        expect(groups, hasLength(2));
        expect(groups.last.period, isNull);
        expect(groups.last.transactions.map((t) => t.id), ['txn-stray']);
      },
    );

    blocTest<EnvelopeDetailCubit, EnvelopeDetailState>(
      'refresh updates envelope from repository',
      build: () {
        final updated = testEnvelope.copyWith(name: 'Updated Rent');
        when(
          () => envelopeRepository.getEnvelope('env-1'),
        ).thenAnswer((_) async => updated);
        return buildCubit();
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<EnvelopeDetailState>().having(
          (s) => s.envelope.name,
          'envelope name',
          'Updated Rent',
        ),
      ],
    );

    blocTest<EnvelopeDetailCubit, EnvelopeDetailState>(
      'refresh keeps current data on failure',
      build: () {
        when(
          () => envelopeRepository.getEnvelope('env-1'),
        ).thenThrow(const EnvelopeException('Error'));
        return buildCubit();
      },
      act: (cubit) => cubit.refresh(),
      expect: () => <EnvelopeDetailState>[],
    );

    test('deleteEnvelope returns true on success', () async {
      when(
        () => envelopeRepository.deleteEnvelope('env-1'),
      ).thenAnswer((_) async {});
      final cubit = buildCubit();

      final result = await cubit.deleteEnvelope();

      expect(result, isTrue);
      verify(() => envelopeRepository.deleteEnvelope('env-1')).called(1);
      addTearDown(cubit.close);
    });

    test('deleteEnvelope returns false on failure', () async {
      when(
        () => envelopeRepository.deleteEnvelope('env-1'),
      ).thenThrow(const EnvelopeException('Error'));
      final cubit = buildCubit();

      final result = await cubit.deleteEnvelope();

      expect(result, isFalse);
      addTearDown(cubit.close);
    });
  });
}
