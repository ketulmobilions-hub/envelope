import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/widgets/dashboard_ready_to_assign_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {
}

void main() {
  late AuthBloc authBloc;
  final now = DateTime(2024);

  final junePeriod = BudgetPeriod(
    id: 'period-jun',
    budgetId: 'b1',
    startDate: DateTime(2024, 6),
    endDate: DateTime(2024, 6, 30),
    createdAt: now,
  );

  setUp(() {
    authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(
      AuthState.authenticated(
        User(
          id: 'u1',
          email: 't@t.com',
          displayName: 'T',
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );
  });

  Future<void> pumpCard(
    WidgetTester tester, {
    required int readyToAssign,
    int totalSpent = 0,
    int totalAllocated = 0,
    BudgetPeriod? period,
    bool hasPreviousPeriod = false,
    bool hasNextPeriod = false,
    VoidCallback? onPreviousPeriod,
    VoidCallback? onNextPeriod,
  }) {
    return tester.pumpApp(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: DashboardReadyToAssignCard(
          readyToAssign: readyToAssign,
          totalSpent: totalSpent,
          totalAllocated: totalAllocated,
          period: period,
          hasPreviousPeriod: hasPreviousPeriod,
          hasNextPeriod: hasNextPeriod,
          onPreviousPeriod: onPreviousPeriod,
          onNextPeriod: onNextPeriod,
        ),
      ),
    );
  }

  group('DashboardReadyToAssignCard', () {
    testWidgets('displays the ready-to-assign amount', (tester) async {
      await pumpCard(tester, readyToAssign: 150000);
      expect(find.text(r'$1500.00'), findsOneWidget);
    });

    testWidgets('shows no period nav when period is null', (tester) async {
      await pumpCard(tester, readyToAssign: 1000);
      expect(find.byIcon(Icons.chevron_left), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('shows period label and nav chevrons when period given', (
      tester,
    ) async {
      await pumpCard(
        tester,
        readyToAssign: 1000,
        period: junePeriod,
        hasPreviousPeriod: true,
        hasNextPeriod: true,
      );
      expect(find.text('Jun 2024'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('labels a year-crossing period with both years', (
      tester,
    ) async {
      final crossYear = BudgetPeriod(
        id: 'period-xy',
        budgetId: 'b1',
        startDate: DateTime(2025, 12, 30),
        endDate: DateTime(2026, 1, 5),
        createdAt: now,
      );
      await pumpCard(tester, readyToAssign: 1000, period: crossYear);
      expect(find.text('Dec 2025 – Jan 2026'), findsOneWidget);
    });

    testWidgets('disables chevrons at the ends', (tester) async {
      await pumpCard(
        tester,
        readyToAssign: 1000,
        period: junePeriod,
        onPreviousPeriod: () {},
        onNextPeriod: () {},
      );
      final prev = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_left),
      );
      final next = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      // Callbacks supplied, but hasPrevious/hasNext default false → disabled.
      expect(prev.onPressed, isNull);
      expect(next.onPressed, isNull);
    });

    testWidgets('chevron taps fire the navigation callbacks', (tester) async {
      var prevTaps = 0;
      var nextTaps = 0;
      await pumpCard(
        tester,
        readyToAssign: 1000,
        period: junePeriod,
        hasPreviousPeriod: true,
        hasNextPeriod: true,
        onPreviousPeriod: () => prevTaps++,
        onNextPeriod: () => nextTaps++,
      );
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(prevTaps, 1);
      expect(nextTaps, 1);
    });

    testWidgets('renders Spent / Allocated totals row', (tester) async {
      await pumpCard(
        tester,
        readyToAssign: 0,
        totalSpent: 12345,
        totalAllocated: 67890,
      );
      expect(find.text('Spent / Allocated'), findsOneWidget);
      expect(find.text(r'$123.45'), findsOneWidget);
      expect(find.text(r' / $678.90'), findsOneWidget);
    });

    testWidgets('clamps huge totals via FittedBox without overflow', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpCard(
        tester,
        readyToAssign: 99999999999,
        totalSpent: 99999999999,
        totalAllocated: 99999999999,
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
      expect(find.byType(FittedBox), findsNWidgets(2));
    });
  });
}
