import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/onboarding/cubit/onboarding_cubit.dart';
import 'package:envelope/settings/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helpers.dart';

class _MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  late SharedPreferences prefs;
  late _MockBudgetRepository budgetRepository;

  final now = DateTime(2026, 6);

  setUp(() {
    budgetRepository = _MockBudgetRepository();
    SharedPreferences.setMockInitialValues({
      activeBudgetIdKey: 'budget-1',
    });
  });

  Future<void> pumpTile(WidgetTester tester) async {
    prefs = await SharedPreferences.getInstance();
    await tester.pumpApp(
      RepositoryProvider<SharedPreferences>.value(
        value: prefs,
        child: RepositoryProvider<BudgetRepository>.value(
          value: budgetRepository,
          child: const Material(
            child: OpeningBalanceTile(),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'shows configured opening balance with currency symbol + anchor date '
    '(#80)',
    (tester) async {
      when(() => budgetRepository.watchBudget('budget-1')).thenAnswer(
        (_) => Stream.value(
          Budget(
            id: 'budget-1',
            ownerId: 'owner-1',
            name: 'My Budget',
            // EUR — proves the tile reads `budget.baseCurrency` instead of
            // hard-coding `$`.
            baseCurrency: 'EUR',
            openingBalance: 1234500,
            openingDate: DateTime(2026, 4, 15),
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );

      await pumpTile(tester);
      await tester.pump();

      expect(find.text('Opening Balance'), findsOneWidget);
      final subtitle = find.byWidgetPredicate(
        (w) =>
            w is Text &&
            (w.data?.startsWith('€') ?? false) &&
            w.data!.contains('Seed cash anchored on Apr 15, 2026'),
      );
      expect(subtitle, findsOneWidget);
    },
  );

  testWidgets(
    'shows "Not configured" subtitle when openingDate is null (legacy)',
    (tester) async {
      when(() => budgetRepository.watchBudget('budget-1')).thenAnswer(
        (_) => Stream.value(
          Budget(
            id: 'budget-1',
            ownerId: 'owner-1',
            name: 'My Budget',
            baseCurrency: 'USD',
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );

      await pumpTile(tester);
      await tester.pump();

      expect(find.text('Not configured'), findsOneWidget);
    },
  );

  testWidgets('hides itself when no active budget is set', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await pumpTile(tester);

    expect(find.text('Opening Balance'), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('rebuilds when the stream emits a shifted anchor', (tester) async {
    final stream = Stream<Budget>.fromIterable([
      Budget(
        id: 'budget-1',
        ownerId: 'owner-1',
        name: 'My Budget',
        baseCurrency: 'USD',
        openingBalance: 500000,
        openingDate: DateTime(2026, 5),
        createdAt: now,
        updatedAt: now,
      ),
      Budget(
        id: 'budget-1',
        ownerId: 'owner-1',
        name: 'My Budget',
        baseCurrency: 'USD',
        openingBalance: 500000,
        openingDate: DateTime(2026, 4),
        createdAt: now,
        updatedAt: now,
      ),
    ]);
    when(
      () => budgetRepository.watchBudget('budget-1'),
    ).thenAnswer((_) => stream);

    await pumpTile(tester);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Seed cash anchored on Apr 1, 2026'),
      findsOneWidget,
    );
  });

  testWidgets(
    'renders empty subtitle while waiting for first emission (no flicker)',
    (tester) async {
      // Open controller that never emits nor closes → keeps the StreamBuilder
      // in `ConnectionState.waiting` with no data, exercising the no-flicker
      // gate added in phase 5.
      final controller = StreamController<Budget>();
      addTearDown(controller.close);
      when(() => budgetRepository.watchBudget('budget-1')).thenAnswer(
        (_) => controller.stream,
      );

      await pumpTile(tester);
      await tester.pump(Duration.zero);

      expect(find.text('Opening Balance'), findsOneWidget);
      expect(find.text('Not configured'), findsNothing);
    },
  );
}
