import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:report_repository/report_repository.dart';

class MockReportRepository extends Mock implements ReportRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  late MockReportRepository reportRepository;
  late MockBudgetRepository budgetRepository;

  const budgetId = 'budget-1';

  final testPeriod = BudgetPeriod(
    id: 'period-1',
    budgetId: budgetId,
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 31),
    createdAt: DateTime(2026, 3, 1),
  );

  final testSpendingReport = SpendingReport(
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 31),
    totalSpent: 5000,
    totalIncome: 10000,
    byCategory: const [
      SpendingByCategory(
        categoryGroupId: 'cg-1',
        categoryGroupName: 'Essentials',
        amount: 5000,
        envelopes: [
          SpendingByEnvelope(
            envelopeId: 'e-1',
            envelopeName: 'Groceries',
            amount: 5000,
          ),
        ],
      ),
    ],
  );

  final testTrendReport = TrendReport(
    dataPoints: [
      TrendDataPoint(
        date: DateTime(2026, 3),
        income: 10000,
        spending: 5000,
        netSavings: 5000,
      ),
    ],
  );

  final testBudgetVsActualReport = BudgetVsActualReport(
    budgetPeriodId: 'period-1',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 31),
    totalAllocated: 10000,
    totalSpent: 5000,
    items: const [
      BudgetVsActualItem(
        envelopeId: 'e-1',
        envelopeName: 'Groceries',
        categoryGroupName: 'Essentials',
        allocated: 10000,
        spent: 5000,
        remaining: 5000,
      ),
    ],
  );

  final testNetWorthSnapshots = [
    NetWorthSnapshot(
      id: 'nw-1',
      budgetId: budgetId,
      date: DateTime(2026, 3, 1),
      assets: 100000,
      liabilities: 50000,
      netWorth: 50000,
      createdAt: DateTime(2026, 3, 1),
    ),
  ];

  setUp(() {
    reportRepository = MockReportRepository();
    budgetRepository = MockBudgetRepository();
  });

  ReportsBloc buildBloc() => ReportsBloc(
        reportRepository: reportRepository,
        budgetRepository: budgetRepository,
        budgetId: budgetId,
      );

  group('ReportsBloc', () {
    test('initial state is correct', () {
      final bloc = buildBloc();
      expect(bloc.state.status, equals(ReportsStatus.initial));
      expect(bloc.state.spendingReport, isNull);
      expect(bloc.state.trendReport, isNull);
      expect(bloc.state.budgetVsActualReport, isNull);
      expect(bloc.state.netWorthSnapshots, isEmpty);
    });

    group('ReportsStarted', () {
      blocTest<ReportsBloc, ReportsState>(
        'subscribes to budget periods and emits loaded',
        setUp: () {
          when(() => budgetRepository.watchBudgetPeriods(budgetId))
              .thenAnswer((_) => Stream.value([testPeriod]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ReportsStarted()),
        wait: const Duration(milliseconds: 50),
        expect: () => [
          // Loading + default dates set
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loading),
          isA<ReportsState>()
              .having((s) => s.startDate, 'startDate', isNotNull),
          // Periods arrive via stream
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loaded)
              .having(
                (s) => s.budgetPeriods,
                'periods',
                [testPeriod],
              ),
        ],
      );

      blocTest<ReportsBloc, ReportsState>(
        'handles empty periods on stream error',
        setUp: () {
          when(() => budgetRepository.watchBudgetPeriods(budgetId))
              .thenAnswer((_) => Stream.error(Exception('fail')));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ReportsStarted()),
        wait: const Duration(milliseconds: 50),
        expect: () => [
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loading),
          isA<ReportsState>()
              .having((s) => s.startDate, 'startDate', isNotNull),
          // Error fallback sends empty periods
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loaded)
              .having((s) => s.budgetPeriods, 'periods', isEmpty),
        ],
      );
    });

    group('SpendingReportRequested', () {
      blocTest<ReportsBloc, ReportsState>(
        'loads spending report',
        setUp: () {
          when(
            () => reportRepository.getSpendingReport(
              budgetId: budgetId,
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
            ),
          ).thenAnswer((_) async => testSpendingReport);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          SpendingReportRequested(
            startDate: DateTime(2026, 3, 1),
            endDate: DateTime(2026, 3, 31),
          ),
        ),
        expect: () => [
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loading),
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loaded)
              .having(
                (s) => s.spendingReport,
                'spendingReport',
                testSpendingReport,
              ),
        ],
      );
    });

    group('TrendReportRequested', () {
      blocTest<ReportsBloc, ReportsState>(
        'loads trend report',
        setUp: () {
          when(
            () => reportRepository.getTrendReport(
              budgetId: budgetId,
              months: 6,
            ),
          ).thenAnswer((_) async => testTrendReport);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const TrendReportRequested(months: 6)),
        expect: () => [
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loading),
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loaded)
              .having(
                (s) => s.trendReport,
                'trendReport',
                testTrendReport,
              ),
        ],
      );
    });

    group('BudgetVsActualReportRequested', () {
      blocTest<ReportsBloc, ReportsState>(
        'loads budget vs actual report',
        setUp: () {
          when(
            () => reportRepository.getBudgetVsActualReport(
              budgetPeriodId: 'period-1',
            ),
          ).thenAnswer((_) async => testBudgetVsActualReport);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const BudgetVsActualReportRequested(periodId: 'period-1'),
        ),
        expect: () => [
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loading),
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loaded)
              .having(
                (s) => s.budgetVsActualReport,
                'budgetVsActualReport',
                testBudgetVsActualReport,
              ),
        ],
      );
    });

    group('NetWorthReportRequested', () {
      blocTest<ReportsBloc, ReportsState>(
        'loads net worth history',
        setUp: () {
          when(() => reportRepository.getNetWorthHistory(budgetId))
              .thenAnswer((_) async => testNetWorthSnapshots);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const NetWorthReportRequested()),
        expect: () => [
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loading),
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loaded)
              .having(
                (s) => s.netWorthSnapshots,
                'snapshots',
                testNetWorthSnapshots,
              ),
        ],
      );
    });

    group('NetWorthSnapshotRequested', () {
      blocTest<ReportsBloc, ReportsState>(
        'records snapshot and reloads',
        setUp: () {
          when(
            () => reportRepository.recordNetWorthSnapshot(
              budgetId: budgetId,
            ),
          ).thenAnswer((_) async {});
          when(() => reportRepository.getNetWorthHistory(budgetId))
              .thenAnswer((_) async => testNetWorthSnapshots);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const NetWorthSnapshotRequested()),
        expect: () => [
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loading),
          isA<ReportsState>()
              .having((s) => s.status, 'status', ReportsStatus.loaded)
              .having(
                (s) => s.netWorthSnapshots,
                'snapshots',
                testNetWorthSnapshots,
              ),
        ],
      );
    });
  });
}
