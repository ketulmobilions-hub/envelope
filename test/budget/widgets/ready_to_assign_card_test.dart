import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/budget/bloc/bloc.dart';
import 'package:envelope/budget/widgets/ready_to_assign_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockBudgetBloc extends MockBloc<BudgetEvent, BudgetState>
    implements BudgetBloc {}

void main() {
  late MockBudgetBloc budgetBloc;

  setUp(() {
    budgetBloc = MockBudgetBloc();
  });

  Widget buildSubject(BudgetState state) {
    when(() => budgetBloc.state).thenReturn(state);
    when(() => budgetBloc.stream).thenAnswer((_) => Stream.value(state));
    return BlocProvider<BudgetBloc>.value(
      value: budgetBloc,
      child: const ReadyToAssignCard(),
    );
  }

  group('ReadyToAssignCard', () {
    testWidgets('displays the ready-to-assign amount', (tester) async {
      await tester.pumpApp(
        buildSubject(BudgetState(readyToAssign: 150000)),
      );
      expect(find.text(r'$1500.00'), findsOneWidget);
    });

    testWidgets('does not show warning when not over-allocated', (
      tester,
    ) async {
      await tester.pumpApp(
        buildSubject(BudgetState(readyToAssign: 5000)),
      );
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
    });

    testWidgets('shows warning icon when over-allocated', (tester) async {
      await tester.pumpApp(
        buildSubject(
          BudgetState(
            readyToAssign: 5000,
            localAllocations: const {'env-1': 10000},
          ),
        ),
      );
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('shows negative amount when over-allocated', (tester) async {
      await tester.pumpApp(
        buildSubject(
          BudgetState(
            readyToAssign: 5000,
            localAllocations: const {'env-1': 10000},
          ),
        ),
      );
      // localReadyToAssign = 5000 - 10000 = -5000 = -$50.00
      expect(find.text(r'-$50.00'), findsOneWidget);
    });
  });
}
