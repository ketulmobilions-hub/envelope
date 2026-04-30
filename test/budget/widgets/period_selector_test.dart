import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/budget/widgets/period_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockBudgetBloc extends MockBloc<BudgetEvent, BudgetState>
    implements BudgetBloc {}

void main() {
  late MockBudgetBloc budgetBloc;

  final now = DateTime(2026, 3, 13);

  final march = BudgetPeriod(
    id: 'period-march',
    budgetId: 'budget-1',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 3, 31),
    createdAt: now,
  );

  final april = BudgetPeriod(
    id: 'period-april',
    budgetId: 'budget-1',
    startDate: DateTime(2026, 4, 1),
    endDate: DateTime(2026, 4, 30),
    createdAt: now,
  );

  setUp(() {
    budgetBloc = MockBudgetBloc();
  });

  Widget buildSubject(BudgetState state) {
    when(() => budgetBloc.state).thenReturn(state);
    when(() => budgetBloc.stream).thenAnswer((_) => Stream.value(state));
    return BlocProvider<BudgetBloc>.value(
      value: budgetBloc,
      child: const PeriodSelector(),
    );
  }

  group('PeriodSelector', () {
    testWidgets('shows em-dash when no period is selected', (tester) async {
      await tester.pumpApp(
        buildSubject(BudgetState(status: BudgetStatus.loaded)),
      );
      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('formats a single-month period correctly', (tester) async {
      await tester.pumpApp(
        buildSubject(
          BudgetState(
            status: BudgetStatus.loaded,
            periods: [march],
            selectedPeriod: march,
          ),
        ),
      );
      expect(find.text('Mar 2026'), findsOneWidget);
    });

    testWidgets('previous button is disabled at first period', (tester) async {
      await tester.pumpApp(
        buildSubject(
          BudgetState(
            status: BudgetStatus.loaded,
            periods: [march],
            selectedPeriod: march,
          ),
        ),
      );
      final prevButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_left),
      );
      expect(prevButton.onPressed, isNull);
    });

    testWidgets('next button is disabled at last period', (tester) async {
      await tester.pumpApp(
        buildSubject(
          BudgetState(
            status: BudgetStatus.loaded,
            periods: [march],
            selectedPeriod: march,
          ),
        ),
      );
      final nextButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('tapping previous dispatches BudgetPreviousPeriodRequested', (
      tester,
    ) async {
      await tester.pumpApp(
        buildSubject(
          BudgetState(
            status: BudgetStatus.loaded,
            periods: [march, april],
            selectedPeriod: april,
          ),
        ),
      );
      await tester.tap(find.widgetWithIcon(IconButton, Icons.chevron_left));
      verify(
        () => budgetBloc.add(const BudgetPreviousPeriodRequested()),
      ).called(1);
    });

    testWidgets('tapping next dispatches BudgetNextPeriodRequested', (
      tester,
    ) async {
      await tester.pumpApp(
        buildSubject(
          BudgetState(
            status: BudgetStatus.loaded,
            periods: [march, april],
            selectedPeriod: march,
          ),
        ),
      );
      await tester.tap(find.widgetWithIcon(IconButton, Icons.chevron_right));
      verify(
        () => budgetBloc.add(const BudgetNextPeriodRequested()),
      ).called(1);
    });
  });
}
