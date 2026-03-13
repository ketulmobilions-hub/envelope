import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/budget/widgets/allocation_row.dart';
import 'package:envelope_repository/envelope_repository.dart';
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

  final testEnvelope = Envelope(
    id: 'env-1',
    categoryGroupId: 'group-1',
    budgetId: 'budget-1',
    name: 'Rent',
    createdAt: now,
  );

  setUp(() {
    budgetBloc = MockBudgetBloc();
    when(() => budgetBloc.state).thenReturn(BudgetState());
    when(() => budgetBloc.stream)
        .thenAnswer((_) => Stream.value(BudgetState()));
  });

  Widget buildSubject({EnvelopeAllocation? allocation}) {
    return BlocProvider<BudgetBloc>.value(
      value: budgetBloc,
      child: Scaffold(
        body: AllocationRow(
          key: ValueKey(testEnvelope.id),
          envelope: testEnvelope,
          allocation: allocation,
        ),
      ),
    );
  }

  group('AllocationRow', () {
    testWidgets('displays envelope name', (tester) async {
      await tester.pumpApp(buildSubject());
      expect(find.text('Rent'), findsOneWidget);
    });

    testWidgets('shows empty field when no allocation exists', (tester) async {
      await tester.pumpApp(buildSubject());
      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller?.text, isEmpty);
    });

    testWidgets('pre-fills field with existing allocated amount', (tester) async {
      final allocation = EnvelopeAllocation(
        id: 'alloc-1',
        envelopeId: 'env-1',
        budgetPeriodId: 'period-1',
        allocatedAmount: 120000, // $1200.00
        createdAt: now,
      );
      await tester.pumpApp(buildSubject(allocation: allocation));
      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller?.text, '1200.00');
    });

    testWidgets('dispatches AllocationAmountChanged on text input',
        (tester) async {
      await tester.pumpApp(buildSubject());
      await tester.enterText(find.byType(TextFormField), '500.00');
      verify(
        () => budgetBloc.add(
          const AllocationAmountChanged(envelopeId: 'env-1', amount: 50000),
        ),
      ).called(greaterThanOrEqualTo(1));
    });
  });
}
