import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/theme.dart';
import 'package:envelope/transactions/widgets/cover_overspend_dialog.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  final now = DateTime(2026, 3, 17);

  final overspentAllocation = EnvelopeAllocation(
    id: 'alloc-1',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-1',
    allocatedAmount: 10000,
    spentAmount: 15000,
    createdAt: now,
  );

  final sourceAllocation = EnvelopeAllocation(
    id: 'alloc-2',
    envelopeId: 'env-2',
    budgetPeriodId: 'period-1',
    allocatedAmount: 50000,
    spentAmount: 10000,
    createdAt: now,
  );

  final envelopes = [
    Envelope(
      id: 'env-1',
      categoryGroupId: 'group-1',
      budgetId: 'budget-1',
      name: 'Groceries',
      createdAt: now,
    ),
    Envelope(
      id: 'env-2',
      categoryGroupId: 'group-1',
      budgetId: 'budget-1',
      name: 'Entertainment',
      createdAt: now,
    ),
  ];

  late MockBudgetRepository budgetRepository;
  late MockEnvelopeRepository envelopeRepository;
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(overspentAllocation);
  });

  setUp(() {
    budgetRepository = MockBudgetRepository();
    envelopeRepository = MockEnvelopeRepository();
    authBloc = _MockAuthBloc();
    when(
      () => envelopeRepository.updateAllocation(any()),
    ).thenAnswer((_) async {});
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

  // Pumps a MaterialApp with AuthBloc provided above the (root) navigator so
  // the dialog — shown via showDialog on the root navigator — can resolve it.
  Future<void> pumpDialog(
    WidgetTester tester, {
    required void Function(bool?) onResult,
    List<EnvelopeAllocation>? allocations,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: child ?? const SizedBox.shrink(),
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final result = await showCoverOverspendDialog(
                  context,
                  budgetRepository: budgetRepository,
                  envelopeRepository: envelopeRepository,
                  allocations:
                      allocations ?? [overspentAllocation, sourceAllocation],
                  envelopes: envelopes,
                  overspentAllocation: overspentAllocation,
                  overspentEnvelopeName: 'Groceries',
                  deficitCents: 5000,
                );
                onResult(result);
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
  }

  group('showCoverOverspendDialog', () {
    testWidgets('shows locked destination envelope', (tester) async {
      await pumpDialog(tester, onResult: (_) {});
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // The overspent envelope name should appear in a disabled field.
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Cover Overspending'), findsOneWidget);
    });

    testWidgets(
      'shows source dropdown with available balance',
      (tester) async {
        await pumpDialog(tester, onResult: (_) {});
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Tap the dropdown to reveal items.
        await tester.tap(
          find.byWidgetPredicate(
            (w) => w.runtimeType
                .toString()
                .startsWith('DropdownButtonFormField'),
          ),
        );
        await tester.pumpAndSettle();

        // Source dropdown should show Entertainment with available.
        expect(
          find.textContaining('Entertainment'),
          findsWidgets,
        );
      },
    );

    testWidgets('pre-fills amount with deficit', (tester) async {
      await pumpDialog(tester, onResult: (_) {});
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Deficit is 5000 cents = $50.00
      expect(find.text('50.00'), findsOneWidget);
    });

    testWidgets(
      'shows no-source message when no envelopes have funds',
      (tester) async {
        await pumpDialog(
          tester,
          onResult: (_) {},
          allocations: [overspentAllocation],
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(
          find.text('No envelopes with available funds'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'calls transferBetweenEnvelopes on submit',
      (tester) async {
        when(
          () => budgetRepository.transferBetweenEnvelopes(
            fromAllocationId: any(named: 'fromAllocationId'),
            toAllocationId: any(named: 'toAllocationId'),
            amount: any(named: 'amount'),
          ),
        ).thenAnswer((_) async {});

        bool? result;
        await pumpDialog(tester, onResult: (r) => result = r);
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Select source envelope from dropdown.
        await tester.tap(
          find.byWidgetPredicate(
            (w) => w.runtimeType
                .toString()
                .startsWith('DropdownButtonFormField'),
          ),
        );
        await tester.pumpAndSettle();
        // Tap the Entertainment item in the dropdown overlay.
        await tester.tap(
          find.textContaining('Entertainment').last,
        );
        await tester.pumpAndSettle();

        // Tap Transfer button.
        await tester.tap(find.text('Transfer'));
        await tester.pumpAndSettle();

        verify(
          () => budgetRepository.transferBetweenEnvelopes(
            fromAllocationId: 'alloc-2',
            toAllocationId: 'alloc-1',
            amount: 5000,
          ),
        ).called(1);
        expect(result, true);
      },
    );
  });
}
