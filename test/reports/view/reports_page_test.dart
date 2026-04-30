import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/reports/bloc/bloc.dart';
import 'package:envelope/reports/view/reports_page.dart';
import 'package:envelope/reports/view/reports_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:report_repository/report_repository.dart';

import '../../helpers/helpers.dart';

class MockReportRepository extends Mock implements ReportRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockReportsBloc extends MockBloc<ReportsEvent, ReportsState>
    implements ReportsBloc {}

void main() {
  late MockReportRepository reportRepository;
  late MockBudgetRepository budgetRepository;

  setUp(() {
    reportRepository = MockReportRepository();
    budgetRepository = MockBudgetRepository();

    when(
      () => budgetRepository.watchBudgetPeriods(any()),
    ).thenAnswer((_) => Stream.value([]));
  });

  group('ReportsPage', () {
    testWidgets('renders loading indicator initially', (tester) async {
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ReportRepository>.value(
              value: reportRepository,
            ),
            RepositoryProvider<BudgetRepository>.value(
              value: budgetRepository,
            ),
          ],
          child: const ReportsPage(budgetId: 'budget-1'),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows report hub when loaded', (tester) async {
      final bloc = MockReportsBloc();
      when(() => bloc.state).thenReturn(
        const ReportsState(
          status: ReportsStatus.loaded,
          budgetPeriods: [],
        ),
      );

      await tester.pumpApp(
        BlocProvider<ReportsBloc>.value(
          value: bloc,
          child: const ReportsView(budgetId: 'budget-1'),
        ),
      );

      // Verify the hub page renders with report card titles.
      expect(find.text('Reports'), findsOneWidget);
      expect(find.text('Spending'), findsOneWidget);
      expect(find.text('Trends'), findsOneWidget);
      expect(find.text('Budget vs Actual'), findsOneWidget);
      expect(find.text('Net Worth'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);
    });
  });
}
