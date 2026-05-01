import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:mocktail/mocktail.dart';
import 'package:report_repository/report_repository.dart';
import 'package:test/test.dart';

// -----------------------------------------------------------------
// Mocks
// -----------------------------------------------------------------

class MockEnvelopeApiClient extends Mock implements EnvelopeApiClient {}

class MockReportsApiClient extends Mock implements ReportsApiClient {}

class MockAppDatabase extends Mock implements storage.AppDatabase {}

class MockTransactionsDao extends Mock implements storage.TransactionsDao {}

class MockEnvelopesDao extends Mock implements storage.EnvelopesDao {}

class MockAccountsDao extends Mock implements storage.AccountsDao {}

class MockBudgetsDao extends Mock implements storage.BudgetsDao {}

class MockReportsDao extends Mock implements storage.ReportsDao {}

// -----------------------------------------------------------------
// Fakes
// -----------------------------------------------------------------

class FakeNetWorthSnapshotDto extends Fake implements NetWorthSnapshotDto {}

class FakeNetWorthSnapshotsCompanion extends Fake
    implements storage.NetWorthSnapshotsCompanion {}

void main() {
  late ReportRepository repository;
  late MockEnvelopeApiClient apiClient;
  late MockReportsApiClient reportsApiClient;
  late MockAppDatabase localDatabase;
  late MockTransactionsDao transactionsDao;
  late MockEnvelopesDao envelopesDao;
  late MockAccountsDao accountsDao;
  late MockBudgetsDao budgetsDao;
  late MockReportsDao reportsDao;

  final now = DateTime(2024, 6, 15);

  // ---------------------------------------------------------------
  // Fixtures
  // ---------------------------------------------------------------

  final testEnvelope1 = storage.Envelope(
    id: 'env-1',
    categoryGroupId: 'cg-1',
    budgetId: 'budget-1',
    name: 'Groceries',
    sortOrder: 0,
    isArchived: false,
    createdAt: now,
  );

  final testEnvelope2 = storage.Envelope(
    id: 'env-2',
    categoryGroupId: 'cg-1',
    budgetId: 'budget-1',
    name: 'Dining Out',
    sortOrder: 1,
    isArchived: false,
    createdAt: now,
  );

  final testEnvelope3 = storage.Envelope(
    id: 'env-3',
    categoryGroupId: 'cg-2',
    budgetId: 'budget-1',
    name: 'Rent',
    sortOrder: 0,
    isArchived: false,
    createdAt: now,
  );

  final testCategoryGroup1 = storage.CategoryGroup(
    id: 'cg-1',
    budgetId: 'budget-1',
    name: 'Food',
    sortOrder: 0,
    isDefault: false,
    isArchived: false,
    createdAt: now,
  );

  final testCategoryGroup2 = storage.CategoryGroup(
    id: 'cg-2',
    budgetId: 'budget-1',
    name: 'Housing',
    sortOrder: 1,
    isDefault: false,
    isArchived: false,
    createdAt: now,
  );

  storage.Transaction makeTransaction({
    required String id,
    required String type,
    required int amount,
    required DateTime date,
    String? envelopeId,
    String? transferPairId,
    double exchangeRate = 1,
    int? baseCurrencyAmount,
  }) => storage.Transaction(
    id: id,
    budgetId: 'budget-1',
    accountId: 'account-1',
    envelopeId: envelopeId,
    type: type,
    amount: amount,
    currency: 'USD',
    exchangeRate: exchangeRate,
    baseCurrencyAmount:
        baseCurrencyAmount ?? (amount * exchangeRate).round(),
    date: date,
    isReconciled: false,
    transferPairId: transferPairId,
    createdBy: 'user-1',
    createdAt: now,
    updatedAt: now,
  );

  // ---------------------------------------------------------------
  // Setup
  // ---------------------------------------------------------------

  setUpAll(() {
    registerFallbackValue(FakeNetWorthSnapshotDto());
    registerFallbackValue(
      FakeNetWorthSnapshotsCompanion(),
    );
  });

  setUp(() {
    apiClient = MockEnvelopeApiClient();
    reportsApiClient = MockReportsApiClient();
    localDatabase = MockAppDatabase();
    transactionsDao = MockTransactionsDao();
    envelopesDao = MockEnvelopesDao();
    accountsDao = MockAccountsDao();
    budgetsDao = MockBudgetsDao();
    reportsDao = MockReportsDao();

    when(() => apiClient.reports).thenReturn(reportsApiClient);
    when(() => localDatabase.transactionsDao).thenReturn(transactionsDao);
    when(() => localDatabase.envelopesDao).thenReturn(envelopesDao);
    when(() => localDatabase.accountsDao).thenReturn(accountsDao);
    when(() => localDatabase.budgetsDao).thenReturn(budgetsDao);
    when(() => localDatabase.reportsDao).thenReturn(reportsDao);

    repository = ReportRepository(
      apiClient: apiClient,
      localDatabase: localDatabase,
      now: () => now,
    );
  });

  // ---------------------------------------------------------------
  // getSpendingReport
  // ---------------------------------------------------------------

  group('getSpendingReport', () {
    void stubEnvelopesAndGroups() {
      when(
        () => envelopesDao.getEnvelopesByBudgetId('budget-1'),
      ).thenAnswer(
        (_) async => [
          testEnvelope1,
          testEnvelope2,
          testEnvelope3,
        ],
      );
      when(
        () => envelopesDao.getCategoryGroupsByBudgetId('budget-1'),
      ).thenAnswer(
        (_) async => [
          testCategoryGroup1,
          testCategoryGroup2,
        ],
      );
    }

    test('aggregates expenses by envelope and category', () async {
      final transactions = [
        makeTransaction(
          id: 'tx-1',
          type: 'expense',
          amount: 5000,
          date: DateTime(2024, 6, 10),
          envelopeId: 'env-1',
        ),
        makeTransaction(
          id: 'tx-2',
          type: 'expense',
          amount: 3000,
          date: DateTime(2024, 6, 12),
          envelopeId: 'env-1',
        ),
        makeTransaction(
          id: 'tx-3',
          type: 'expense',
          amount: 100000,
          date: DateTime(2024, 6, 14),
          envelopeId: 'env-3',
        ),
        makeTransaction(
          id: 'tx-4',
          type: 'income',
          amount: 200000,
          date: DateTime(2024, 6),
        ),
      ];

      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => transactions);

      stubEnvelopesAndGroups();

      final report = await repository.getSpendingReport(
        budgetId: 'budget-1',
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
      );

      expect(report.totalSpent, 108000);
      expect(report.totalIncome, 200000);
      expect(report.byCategory, hasLength(2));

      final food = report.byCategory.firstWhere(
        (c) => c.categoryGroupName == 'Food',
      );
      expect(food.amount, 8000);
      expect(food.envelopes, hasLength(1));
      expect(
        food.envelopes.first.envelopeName,
        'Groceries',
      );

      final housing = report.byCategory.firstWhere(
        (c) => c.categoryGroupName == 'Housing',
      );
      expect(housing.amount, 100000);
    });

    test('handles split transactions', () async {
      final transactions = [
        makeTransaction(
          id: 'tx-split',
          type: 'expense',
          amount: 10000,
          date: DateTime(2024, 6, 10),
          // null envelopeId = split
        ),
      ];

      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => transactions);

      when(
        () => transactionsDao.getSplitsByTransactionId('tx-split'),
      ).thenAnswer(
        (_) async => [
          const storage.TransactionSplit(
            id: 'split-1',
            transactionId: 'tx-split',
            envelopeId: 'env-1',
            amount: 6000,
          ),
          const storage.TransactionSplit(
            id: 'split-2',
            transactionId: 'tx-split',
            envelopeId: 'env-2',
            amount: 4000,
          ),
        ],
      );

      stubEnvelopesAndGroups();

      final report = await repository.getSpendingReport(
        budgetId: 'budget-1',
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
      );

      expect(report.totalSpent, 10000);

      final food = report.byCategory.firstWhere(
        (c) => c.categoryGroupName == 'Food',
      );
      final groceries = food.envelopes.firstWhere(
        (e) => e.envelopeName == 'Groceries',
      );
      final dining = food.envelopes.firstWhere(
        (e) => e.envelopeName == 'Dining Out',
      );
      expect(groceries.amount, 6000);
      expect(dining.amount, 4000);
    });

    test('filters out transfers', () async {
      final transactions = [
        makeTransaction(
          id: 'tx-transfer',
          type: 'expense',
          amount: 5000,
          date: DateTime(2024, 6, 10),
          envelopeId: 'env-1',
          transferPairId: 'tx-transfer-pair',
        ),
      ];

      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => transactions);

      stubEnvelopesAndGroups();

      final report = await repository.getSpendingReport(
        budgetId: 'budget-1',
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
      );

      expect(report.totalSpent, 0);
      expect(report.totalIncome, 0);
    });

    test('filters by date range', () async {
      final transactions = [
        makeTransaction(
          id: 'tx-in',
          type: 'expense',
          amount: 5000,
          date: DateTime(2024, 6, 10),
          envelopeId: 'env-1',
        ),
        makeTransaction(
          id: 'tx-out',
          type: 'expense',
          amount: 3000,
          date: DateTime(2024, 7),
          envelopeId: 'env-1',
        ),
      ];

      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => transactions);

      stubEnvelopesAndGroups();

      final report = await repository.getSpendingReport(
        budgetId: 'budget-1',
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
      );

      expect(report.totalSpent, 5000);
    });

    test('returns empty report when no transactions', () async {
      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => []);

      stubEnvelopesAndGroups();

      final report = await repository.getSpendingReport(
        budgetId: 'budget-1',
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
      );

      expect(report.totalSpent, 0);
      expect(report.totalIncome, 0);
      expect(report.byCategory, isEmpty);
    });

    test('throws ReportException on failure', () async {
      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenThrow(Exception('db error'));

      await expectLater(
        () => repository.getSpendingReport(
          budgetId: 'budget-1',
          startDate: DateTime(2024, 6),
          endDate: DateTime(2024, 6, 30),
        ),
        throwsA(isA<ReportException>()),
      );
    });
  });

  // ---------------------------------------------------------------
  // getTrendReport
  // ---------------------------------------------------------------

  group('getTrendReport', () {
    test('buckets income and expenses by month', () async {
      // now = 2024-06-15, months = 3 → start = 2024-04
      final transactions = [
        makeTransaction(
          id: 'tx-1',
          type: 'income',
          amount: 300000,
          date: DateTime(2024, 5),
        ),
        makeTransaction(
          id: 'tx-2',
          type: 'expense',
          amount: 150000,
          date: DateTime(2024, 5, 15),
          envelopeId: 'env-1',
        ),
        makeTransaction(
          id: 'tx-3',
          type: 'income',
          amount: 300000,
          date: DateTime(2024, 6),
        ),
        makeTransaction(
          id: 'tx-4',
          type: 'expense',
          amount: 200000,
          date: DateTime(2024, 6, 10),
          envelopeId: 'env-1',
        ),
      ];

      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => transactions);

      final report = await repository.getTrendReport(
        budgetId: 'budget-1',
        months: 3,
      );

      expect(report.dataPoints, hasLength(3));

      // May 2024 bucket (index 1: Apr, May, Jun)
      final may = report.dataPoints.firstWhere(
        (p) => p.date.year == 2024 && p.date.month == 5,
      );
      expect(may.income, 300000);
      expect(may.spending, 150000);
      expect(may.netSavings, 150000);

      // June 2024 bucket
      final june = report.dataPoints.firstWhere(
        (p) => p.date.year == 2024 && p.date.month == 6,
      );
      expect(june.income, 300000);
      expect(june.spending, 200000);
      expect(june.netSavings, 100000);
    });

    test('excludes transfers', () async {
      final transactions = [
        makeTransaction(
          id: 'tx-1',
          type: 'expense',
          amount: 5000,
          date: DateTime(2024, 6, 10),
          envelopeId: 'env-1',
          transferPairId: 'pair-1',
        ),
      ];

      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => transactions);

      final report = await repository.getTrendReport(
        budgetId: 'budget-1',
        months: 3,
      );

      for (final point in report.dataPoints) {
        expect(point.spending, 0);
        expect(point.income, 0);
      }
    });

    test('excludes future-dated transactions', () async {
      // now = 2024-06-15; a July tx should be excluded
      final transactions = [
        makeTransaction(
          id: 'tx-future',
          type: 'expense',
          amount: 9999,
          date: DateTime(2024, 7, 5),
          envelopeId: 'env-1',
        ),
        makeTransaction(
          id: 'tx-current',
          type: 'expense',
          amount: 1000,
          date: DateTime(2024, 6, 10),
          envelopeId: 'env-1',
        ),
      ];

      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenAnswer((_) async => transactions);

      final report = await repository.getTrendReport(
        budgetId: 'budget-1',
        months: 3,
      );

      final totalSpending = report.dataPoints.fold(
        0,
        (sum, p) => sum + p.spending,
      );
      expect(totalSpending, 1000);
    });

    test('throws ReportException on failure', () async {
      when(
        () => transactionsDao.getTransactionsByBudgetId('budget-1'),
      ).thenThrow(Exception('db error'));

      await expectLater(
        () => repository.getTrendReport(
          budgetId: 'budget-1',
          months: 3,
        ),
        throwsA(isA<ReportException>()),
      );
    });
  });

  // ---------------------------------------------------------------
  // getBudgetVsActualReport
  // ---------------------------------------------------------------

  group('getBudgetVsActualReport', () {
    test('maps allocations to items correctly', () async {
      when(
        () => budgetsDao.getBudgetPeriod('period-1'),
      ).thenAnswer(
        (_) async => storage.BudgetPeriod(
          id: 'period-1',
          budgetId: 'budget-1',
          startDate: DateTime(2024, 6),
          endDate: DateTime(2024, 6, 30),
          totalIncome: 300000,
          totalAllocated: 250000,
          isClosed: false,
          createdAt: now,
        ),
      );

      when(
        () => envelopesDao.getAllocationsByPeriodId('period-1'),
      ).thenAnswer(
        (_) async => [
          storage.EnvelopeAllocation(
            id: 'alloc-1',
            envelopeId: 'env-1',
            budgetPeriodId: 'period-1',
            allocatedAmount: 50000,
            spentAmount: 30000,
            rolloverAmount: 0,
            createdAt: now,
          ),
          storage.EnvelopeAllocation(
            id: 'alloc-2',
            envelopeId: 'env-3',
            budgetPeriodId: 'period-1',
            allocatedAmount: 200000,
            spentAmount: 195000,
            rolloverAmount: 0,
            createdAt: now,
          ),
        ],
      );

      when(
        () => envelopesDao.getEnvelopesByBudgetId('budget-1'),
      ).thenAnswer(
        (_) async => [
          testEnvelope1,
          testEnvelope2,
          testEnvelope3,
        ],
      );
      when(
        () => envelopesDao.getCategoryGroupsByBudgetId('budget-1'),
      ).thenAnswer(
        (_) async => [
          testCategoryGroup1,
          testCategoryGroup2,
        ],
      );

      final report = await repository.getBudgetVsActualReport(
        budgetPeriodId: 'period-1',
      );

      expect(report.totalAllocated, 250000);
      expect(report.totalSpent, 225000);
      expect(report.items, hasLength(2));

      final groceriesItem = report.items.firstWhere(
        (i) => i.envelopeId == 'env-1',
      );
      expect(groceriesItem.allocated, 50000);
      expect(groceriesItem.spent, 30000);
      expect(groceriesItem.remaining, 20000);
      expect(
        groceriesItem.categoryGroupName,
        'Food',
      );

      final rentItem = report.items.firstWhere(
        (i) => i.envelopeId == 'env-3',
      );
      expect(rentItem.allocated, 200000);
      expect(rentItem.spent, 195000);
      expect(rentItem.remaining, 5000);
      expect(rentItem.categoryGroupName, 'Housing');
    });

    test('throws when budget period not found', () async {
      when(
        () => budgetsDao.getBudgetPeriod('bad-id'),
      ).thenAnswer((_) async => null);

      await expectLater(
        () => repository.getBudgetVsActualReport(
          budgetPeriodId: 'bad-id',
        ),
        throwsA(
          isA<ReportException>().having(
            (e) => e.message,
            'message',
            'Budget period not found',
          ),
        ),
      );
    });

    test('throws ReportException on failure', () async {
      when(
        () => budgetsDao.getBudgetPeriod('period-1'),
      ).thenThrow(Exception('db error'));

      await expectLater(
        () => repository.getBudgetVsActualReport(
          budgetPeriodId: 'period-1',
        ),
        throwsA(isA<ReportException>()),
      );
    });
  });

  // ---------------------------------------------------------------
  // getNetWorthHistory
  // ---------------------------------------------------------------

  group('getNetWorthHistory', () {
    test('returns remote data and caches locally', () async {
      when(
        () => reportsApiClient.getNetWorthSnapshotsByBudget('budget-1'),
      ).thenAnswer(
        (_) async => [
          NetWorthSnapshotDto(
            id: 'nw-1',
            budgetId: 'budget-1',
            date: now,
            assets: 500000,
            liabilities: 100000,
            netWorth: 400000,
            createdAt: now,
          ),
        ],
      );

      when(
        () => reportsDao.insertNetWorthSnapshot(any()),
      ).thenAnswer((_) async => 1);

      final result = await repository.getNetWorthHistory('budget-1');

      expect(result, hasLength(1));
      expect(result.first.netWorth, 400000);
      expect(result.first.assets, 500000);
      verify(
        () => reportsDao.insertNetWorthSnapshot(any()),
      ).called(1);
    });

    test('falls back to local when API returns empty', () async {
      when(
        () => reportsApiClient.getNetWorthSnapshotsByBudget('budget-1'),
      ).thenAnswer((_) async => []);

      when(
        () => reportsDao.getNetWorthSnapshotsByBudgetId('budget-1'),
      ).thenAnswer(
        (_) async => [
          storage.NetWorthSnapshot(
            id: 'nw-1',
            budgetId: 'budget-1',
            date: now,
            assets: 500000,
            liabilities: 100000,
            netWorth: 400000,
            createdAt: now,
          ),
        ],
      );

      final result = await repository.getNetWorthHistory('budget-1');

      expect(result, hasLength(1));
      expect(result.first.netWorth, 400000);
    });

    test('falls back to local cache on network error', () async {
      when(
        () => reportsApiClient.getNetWorthSnapshotsByBudget('budget-1'),
      ).thenThrow(
        const EnvelopeApiException('network error'),
      );

      when(
        () => reportsDao.getNetWorthSnapshotsByBudgetId('budget-1'),
      ).thenAnswer(
        (_) async => [
          storage.NetWorthSnapshot(
            id: 'nw-1',
            budgetId: 'budget-1',
            date: now,
            assets: 500000,
            liabilities: 100000,
            netWorth: 400000,
            createdAt: now,
          ),
        ],
      );

      final result = await repository.getNetWorthHistory('budget-1');

      expect(result, hasLength(1));
      expect(result.first.netWorth, 400000);
    });

    test('throws ReportException when both API and local fail', () async {
      when(
        () => reportsApiClient.getNetWorthSnapshotsByBudget('budget-1'),
      ).thenThrow(Exception('network error'));

      when(
        () => reportsDao.getNetWorthSnapshotsByBudgetId('budget-1'),
      ).thenThrow(Exception('db error'));

      await expectLater(
        () => repository.getNetWorthHistory('budget-1'),
        throwsA(isA<ReportException>()),
      );
    });
  });

  // ---------------------------------------------------------------
  // recordNetWorthSnapshot
  // ---------------------------------------------------------------

  group('recordNetWorthSnapshot', () {
    test('calculates and records snapshot', () async {
      when(
        () => accountsDao.getAccountsByBudgetId('budget-1'),
      ).thenAnswer(
        (_) async => [
          storage.Account(
            id: 'acc-1',
            budgetId: 'budget-1',
            name: 'Checking',
            type: 'checking',
            startingBalance: 0,
            currentBalance: 300000,
            currency: 'USD',
            displayFxRate: 1.0,
            isArchived: false,
            isOnBudget: true,
            createdAt: now,
            updatedAt: now,
          ),
          storage.Account(
            id: 'acc-2',
            budgetId: 'budget-1',
            name: 'Savings',
            type: 'savings',
            startingBalance: 0,
            currentBalance: 500000,
            currency: 'USD',
            displayFxRate: 1.0,
            isArchived: false,
            isOnBudget: true,
            createdAt: now,
            updatedAt: now,
          ),
          storage.Account(
            id: 'acc-3',
            budgetId: 'budget-1',
            name: 'Credit Card',
            type: 'credit_card',
            startingBalance: 0,
            currentBalance: -50000,
            currency: 'USD',
            displayFxRate: 1.0,
            isArchived: false,
            isOnBudget: true,
            createdAt: now,
            updatedAt: now,
          ),
          // Off-budget — should be ignored
          storage.Account(
            id: 'acc-4',
            budgetId: 'budget-1',
            name: 'Cash',
            type: 'checking',
            startingBalance: 0,
            currentBalance: 10000,
            currency: 'USD',
            displayFxRate: 1.0,
            isArchived: false,
            isOnBudget: false,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );

      late NetWorthSnapshotDto capturedDto;
      when(
        () => reportsApiClient.createNetWorthSnapshot(any()),
      ).thenAnswer((invocation) async {
        return capturedDto =
            invocation.positionalArguments[0] as NetWorthSnapshotDto;
      });

      when(
        () => reportsDao.insertNetWorthSnapshot(any()),
      ).thenAnswer((_) async => 1);

      await repository.recordNetWorthSnapshot(
        budgetId: 'budget-1',
      );

      // assets = 300000 + 500000 = 800000
      // liabilities = |-50000| = 50000
      // netWorth = 800000 - 50000 = 750000
      expect(capturedDto.assets, 800000);
      expect(capturedDto.liabilities, 50000);
      expect(capturedDto.netWorth, 750000);
      // Placeholder ID — API will replace it
      expect(capturedDto.id, 'pending');

      verify(
        () => reportsDao.insertNetWorthSnapshot(any()),
      ).called(1);
    });

    test('throws ReportException on failure', () async {
      when(
        () => accountsDao.getAccountsByBudgetId('budget-1'),
      ).thenThrow(Exception('db error'));

      await expectLater(
        () => repository.recordNetWorthSnapshot(
          budgetId: 'budget-1',
        ),
        throwsA(isA<ReportException>()),
      );
    });
  });

  // ---------------------------------------------------------------
  // CSV Exports
  // ---------------------------------------------------------------

  group('exportSpendingReportCsv', () {
    test('produces correct CSV with formatted amounts', () {
      final report = SpendingReport(
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
        totalSpent: 8000,
        totalIncome: 200000,
        byCategory: [
          const SpendingByCategory(
            categoryGroupId: 'cg-1',
            categoryGroupName: 'Food',
            amount: 8000,
            envelopes: [
              SpendingByEnvelope(
                envelopeId: 'env-1',
                envelopeName: 'Groceries',
                amount: 5000,
              ),
              SpendingByEnvelope(
                envelopeId: 'env-2',
                envelopeName: 'Dining Out',
                amount: 3000,
              ),
            ],
          ),
        ],
      );

      final csv = repository.exportSpendingReportCsv(
        report,
      );

      expect(csv, contains('Category Group'));
      expect(csv, contains('Groceries'));
      expect(csv, contains('Dining Out'));
      // Amounts formatted as dollars
      expect(csv, contains('50.00'));
      expect(csv, contains('30.00'));
      expect(csv, contains('Total Spent'));
      expect(csv, contains('80.00'));
      expect(csv, contains('Total Income'));
      expect(csv, contains('2000.00'));
    });
  });

  group('exportBudgetVsActualCsv', () {
    test('produces correct CSV with formatted amounts', () {
      final report = BudgetVsActualReport(
        budgetPeriodId: 'period-1',
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
        totalAllocated: 50000,
        totalSpent: 30000,
        items: const [
          BudgetVsActualItem(
            envelopeId: 'env-1',
            envelopeName: 'Groceries',
            categoryGroupName: 'Food',
            allocated: 50000,
            spent: 30000,
            remaining: 20000,
          ),
        ],
      );

      final csv = repository.exportBudgetVsActualCsv(
        report,
      );

      expect(csv, contains('Allocated'));
      expect(csv, contains('Spent'));
      expect(csv, contains('Remaining'));
      expect(csv, contains('Groceries'));
      // Formatted amounts
      expect(csv, contains('500.00'));
      expect(csv, contains('300.00'));
      expect(csv, contains('200.00'));
    });
  });

  group('exportTrendReportCsv', () {
    test('produces correct CSV with formatted amounts', () {
      final report = TrendReport(
        dataPoints: [
          TrendDataPoint(
            date: DateTime(2024, 5),
            income: 300000,
            spending: 150000,
            netSavings: 150000,
          ),
          TrendDataPoint(
            date: DateTime(2024, 6),
            income: 300000,
            spending: 200000,
            netSavings: 100000,
          ),
        ],
      );

      final csv = repository.exportTrendReportCsv(
        report,
      );

      expect(csv, contains('Date'));
      expect(csv, contains('Income'));
      expect(csv, contains('Net Savings'));
      expect(csv, contains('2024-05'));
      expect(csv, contains('2024-06'));
      // Formatted amounts
      expect(csv, contains('3000.00'));
      expect(csv, contains('1500.00'));
    });
  });

  // ---------------------------------------------------------------
  // PDF Exports
  // ---------------------------------------------------------------

  group('exportSpendingReportPdf', () {
    test('returns non-empty bytes', () async {
      final report = SpendingReport(
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
        totalSpent: 5000,
        totalIncome: 200000,
        byCategory: const [
          SpendingByCategory(
            categoryGroupId: 'cg-1',
            categoryGroupName: 'Food',
            amount: 5000,
            envelopes: [
              SpendingByEnvelope(
                envelopeId: 'env-1',
                envelopeName: 'Groceries',
                amount: 5000,
              ),
            ],
          ),
        ],
      );

      final bytes = await repository.exportSpendingReportPdf(
        report,
      );

      expect(bytes, isNotEmpty);
      expect(
        String.fromCharCodes(bytes.take(5)),
        startsWith('%PDF'),
      );
    });
  });

  group('exportBudgetVsActualPdf', () {
    test('returns non-empty bytes', () async {
      final report = BudgetVsActualReport(
        budgetPeriodId: 'period-1',
        startDate: DateTime(2024, 6),
        endDate: DateTime(2024, 6, 30),
        totalAllocated: 50000,
        totalSpent: 30000,
        items: const [
          BudgetVsActualItem(
            envelopeId: 'env-1',
            envelopeName: 'Groceries',
            categoryGroupName: 'Food',
            allocated: 50000,
            spent: 30000,
            remaining: 20000,
          ),
        ],
      );

      final bytes = await repository.exportBudgetVsActualPdf(
        report,
      );

      expect(bytes, isNotEmpty);
      expect(
        String.fromCharCodes(bytes.take(5)),
        startsWith('%PDF'),
      );
    });
  });

  group('exportTrendReportPdf', () {
    test('returns non-empty bytes', () async {
      final report = TrendReport(
        dataPoints: [
          TrendDataPoint(
            date: DateTime(2024, 6),
            income: 300000,
            spending: 200000,
            netSavings: 100000,
          ),
        ],
      );

      final bytes = await repository.exportTrendReportPdf(
        report,
      );

      expect(bytes, isNotEmpty);
      expect(
        String.fromCharCodes(bytes.take(5)),
        startsWith('%PDF'),
      );
    });
  });

  // ---------------------------------------------------------------
  // ReportException
  // ---------------------------------------------------------------

  group('ReportException', () {
    test('toString without error', () {
      const exception = ReportException('test');
      expect(
        exception.toString(),
        'ReportException: test',
      );
    });

    test('toString with error', () {
      final exception = ReportException(
        'test',
        error: Exception('inner'),
      );
      expect(
        exception.toString(),
        contains('ReportException: test'),
      );
      expect(
        exception.toString(),
        contains('inner'),
      );
    });
  });
}
