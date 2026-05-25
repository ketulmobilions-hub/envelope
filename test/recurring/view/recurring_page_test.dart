import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/recurring/bloc/bloc.dart';
import 'package:envelope/recurring/view/recurring_page.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../../helpers/helpers.dart';

class _MockRecurringBloc extends MockBloc<RecurringEvent, RecurringState>
    implements RecurringBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late RecurringBloc recurringBloc;
  late AuthBloc authBloc;
  late AppClock appClock;

  final now = DateTime(2024);
  final testRules = [
    RecurringRule(
      id: 'rule-1',
      budgetId: 'budget-1',
      accountId: 'acc-1',
      type: 'expense',
      amount: 5000,
      currency: 'USD',
      frequency: 'monthly',
      startDate: now,
      nextOccurrence: now.add(const Duration(days: 30)),
      createdAt: now,
      payee: 'Netflix',
    ),
  ];

  final testReminders = [
    BillReminder(
      id: 'bill-1',
      budgetId: 'budget-1',
      name: 'Electricity',
      estimatedAmount: 12000,
      dueDay: 15,
      frequency: 'monthly',
      createdAt: now,
    ),
  ];

  setUp(() async {
    recurringBloc = _MockRecurringBloc();
    authBloc = _MockAuthBloc();

    when(() => authBloc.state).thenReturn(
      AuthState.authenticated(
        User(
          id: 'user-1',
          email: 'test@test.com',
          displayName: 'Test',
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    appClock = AppClock(prefs);
  });

  Widget buildSubject({int initialTab = 0}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecurringBloc>.value(value: recurringBloc),
        BlocProvider<AuthBloc>.value(value: authBloc),
      ],
      child: ChangeNotifierProvider<AppClock>.value(
        value: appClock,
        child: RecurringView(budgetId: 'budget-1', initialTab: initialTab),
      ),
    );
  }

  group('RecurringView', () {
    testWidgets('shows loading indicator when status is loading', (
      tester,
    ) async {
      when(() => recurringBloc.state).thenReturn(
        const RecurringState(status: RecurringStatus.loading),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows tabs when loaded', (tester) async {
      when(() => recurringBloc.state).thenReturn(
        const RecurringState(status: RecurringStatus.loaded),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      expect(find.text('Recurring'), findsOneWidget);
      expect(find.text('Bills'), findsOneWidget);
    });

    testWidgets('shows empty state when no recurring rules', (tester) async {
      when(() => recurringBloc.state).thenReturn(
        const RecurringState(status: RecurringStatus.loaded),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      expect(find.text('No recurring transactions'), findsOneWidget);
    });

    testWidgets('shows recurring rules list', (tester) async {
      when(() => recurringBloc.state).thenReturn(
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
        ),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      expect(find.text('Netflix'), findsOneWidget);
    });

    testWidgets('shows bill reminders list on bills tab', (tester) async {
      when(() => recurringBloc.state).thenReturn(
        RecurringState(
          status: RecurringStatus.loaded,
          billReminders: testReminders,
        ),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      // Tap the Bills tab.
      await tester.tap(find.text('Bills'));
      await tester.pumpAndSettle();

      expect(find.text('Electricity'), findsOneWidget);
    });

    testWidgets('shows FAB', (tester) async {
      when(() => recurringBloc.state).thenReturn(
        const RecurringState(status: RecurringStatus.loaded),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('dispatches delete event after confirmation', (tester) async {
      when(() => recurringBloc.state).thenReturn(
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
        ),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      // Swipe to delete (endToStart).
      await tester.drag(find.text('Netflix'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Confirm deletion.
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(
        () => recurringBloc.add(const RecurringRuleDeleted('rule-1')),
      ).called(1);

      // Drain the undo snackbar's 5s dismissal timer before the test ends.
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('dispatches pause toggle when pause button tapped', (
      tester,
    ) async {
      when(() => recurringBloc.state).thenReturn(
        RecurringState(
          status: RecurringStatus.loaded,
          recurringRules: testRules,
        ),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      // Pause/resume is a visible IconButton (tooltip "Pause").
      await tester.tap(find.byTooltip('Pause'));
      await tester.pumpAndSettle();

      verify(
        () => recurringBloc.add(const RecurringRulePauseToggled('rule-1')),
      ).called(1);
    });

    testWidgets('dispatches bill delete event after confirmation', (
      tester,
    ) async {
      when(() => recurringBloc.state).thenReturn(
        RecurringState(
          status: RecurringStatus.loaded,
          billReminders: testReminders,
        ),
      );

      await tester.pumpApp(
        buildSubject(),
      );

      // Switch to Bills tab.
      await tester.tap(find.text('Bills'));
      await tester.pumpAndSettle();

      // Swipe to delete.
      await tester.drag(
        find.text('Electricity'),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();

      // Confirm deletion.
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(
        () => recurringBloc.add(const BillReminderDeleted('bill-1')),
      ).called(1);

      // Drain the undo snackbar's 5s dismissal timer before the test ends.
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('shows error snackbar', (tester) async {
      when(() => recurringBloc.state).thenReturn(
        const RecurringState(status: RecurringStatus.loaded),
      );

      whenListen(
        recurringBloc,
        Stream.fromIterable([
          const RecurringState(
            status: RecurringStatus.error,
            error: RecurringError.loadFailed,
          ),
          const RecurringState(status: RecurringStatus.loaded),
        ]),
        initialState: const RecurringState(status: RecurringStatus.loaded),
      );

      await tester.pumpApp(
        buildSubject(),
      );
      await tester.pump();

      expect(
        find.text('Failed to load recurring data. Please try again.'),
        findsOneWidget,
      );
    });
  });
}
