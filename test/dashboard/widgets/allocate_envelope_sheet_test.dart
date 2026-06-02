import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/dashboard/widgets/allocate_envelope_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {
}

void main() {
  late DashboardBloc dashboardBloc;
  late AuthBloc authBloc;
  final now = DateTime(2024);

  setUpAll(() {
    registerFallbackValue(
      const QuickAllocationRequested(envelopeId: '_', amount: 0),
    );
  });

  setUp(() {
    dashboardBloc = _MockDashboardBloc();
    authBloc = _MockAuthBloc();
    when(() => dashboardBloc.state).thenReturn(
      const DashboardState(readyToAssign: 50000),
    );
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

  Future<void> openSheet(
    WidgetTester tester, {
    int currentAllocatedCents = 10000,
  }) async {
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<DashboardBloc>.value(value: dashboardBloc),
          BlocProvider<AuthBloc>.value(value: authBloc),
        ],
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showAllocateEnvelopeSheet(
                  context,
                  envelopeId: 'e1',
                  envelopeName: 'Groceries',
                  currentAllocatedCents: currentAllocatedCents,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('AllocateEnvelopeSheet', () {
    testWidgets('renders current allocation and live ready-to-assign', (
      tester,
    ) async {
      await openSheet(tester);
      expect(find.textContaining(r'Currently allocated: $100.00'), findsOne);
      expect(find.textContaining(r'Ready to assign: $500.00'), findsOne);
      expect(find.text('Add'), findsOne);
      expect(find.text('Set to'), findsOne);
    });

    testWidgets('defaults to Add mode with empty input', (tester) async {
      await openSheet(tester);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, isEmpty);
    });

    testWidgets('Add mode: 50.00 + current 100.00 previews 150.00', (
      tester,
    ) async {
      await openSheet(tester);
      await tester.enterText(find.byType(TextField), '50.00');
      await tester.pump();
      expect(find.textContaining(r'New allocation: $150.00'), findsOne);
    });

    testWidgets('toggling to Set mode pre-fills current allocation', (
      tester,
    ) async {
      await openSheet(tester);
      await tester.tap(find.text('Set to'));
      await tester.pump();
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, '100.00');
      expect(find.textContaining(r'New allocation: $100.00'), findsOne);
    });

    testWidgets('Set mode: typing 200 previews 200.00 (replace)', (
      tester,
    ) async {
      await openSheet(tester);
      await tester.tap(find.text('Set to'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '200.00');
      await tester.pump();
      expect(find.textContaining(r'New allocation: $200.00'), findsOne);
    });

    testWidgets(
      'mode toggle preserves user-typed input (Add -> Set -> Add)',
      (tester) async {
        await openSheet(tester);
        await tester.enterText(find.byType(TextField), '50');
        await tester.pump();
        await tester.tap(find.text('Set to'));
        await tester.pump();
        final afterSet =
            tester.widget<TextField>(find.byType(TextField)).controller!.text;
        expect(afterSet, '50');
        await tester.tap(find.text('Add'));
        await tester.pump();
        final afterAdd =
            tester.widget<TextField>(find.byType(TextField)).controller!.text;
        expect(afterAdd, '50');
      },
    );

    testWidgets(
      'Set auto-prefill is cleared when toggling back to Add untouched',
      (tester) async {
        await openSheet(tester);
        await tester.tap(find.text('Set to'));
        await tester.pump();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          '100.00',
        );
        await tester.tap(find.text('Add'));
        await tester.pump();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty,
        );
      },
    );

    testWidgets('submit disabled when Add amount is empty or zero', (
      tester,
    ) async {
      await openSheet(tester);
      final saveButton = find.widgetWithText(FilledButton, 'Save');
      expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);

      await tester.enterText(find.byType(TextField), '0');
      await tester.pump();
      expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);
    });

    testWidgets('Set mode submit disabled when value equals current', (
      tester,
    ) async {
      await openSheet(tester);
      await tester.tap(find.text('Set to'));
      await tester.pump();
      final saveButton = find.widgetWithText(FilledButton, 'Save');
      expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);
    });

    testWidgets('submit disabled on overflow input', (tester) async {
      await openSheet(tester);
      await tester.enterText(find.byType(TextField), '9999999999.99');
      await tester.pump();
      final saveButton = find.widgetWithText(FilledButton, 'Save');
      expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);
    });

    testWidgets('shows over-allocated warning when delta exceeds pool', (
      tester,
    ) async {
      await openSheet(tester);
      await tester.enterText(find.byType(TextField), '600');
      await tester.pump();
      expect(find.text('Exceeds Ready to Assign'), findsOne);
      final saveButton = find.widgetWithText(FilledButton, 'Save');
      expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);
    });

    testWidgets('Add mode submit dispatches Add+current', (tester) async {
      await openSheet(tester);
      await tester.enterText(find.byType(TextField), '50');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      verify(
        () => dashboardBloc.add(
          const QuickAllocationRequested(envelopeId: 'e1', amount: 15000),
        ),
      ).called(1);
    });

    testWidgets('Set mode submit dispatches absolute amount', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Set to'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '7');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      verify(
        () => dashboardBloc.add(
          const QuickAllocationRequested(envelopeId: 'e1', amount: 700),
        ),
      ).called(1);
    });

    testWidgets('cancel pops sheet without dispatching', (tester) async {
      await openSheet(tester);
      await tester.enterText(find.byType(TextField), '50');
      await tester.pump();
      await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      verifyNever(() => dashboardBloc.add(any()));
    });
  });
}
