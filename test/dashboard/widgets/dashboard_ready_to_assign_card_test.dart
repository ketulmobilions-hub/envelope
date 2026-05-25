import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
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
    int carriedRta = 0,
  }) {
    return tester.pumpApp(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: DashboardReadyToAssignCard(
          readyToAssign: readyToAssign,
          carriedRta: carriedRta,
        ),
      ),
    );
  }

  group('DashboardReadyToAssignCard', () {
    testWidgets('displays the ready-to-assign amount', (tester) async {
      await pumpCard(tester, readyToAssign: 150000);
      expect(find.text(r'$1500.00'), findsOneWidget);
    });

    testWidgets('shows no carry subtitle when carriedRta is zero', (
      tester,
    ) async {
      await pumpCard(tester, readyToAssign: 150000);
      expect(find.textContaining('carried from last period'), findsNothing);
      expect(find.textContaining('deducted'), findsNothing);
    });

    testWidgets('explains a positive carried-forward balance', (tester) async {
      await pumpCard(tester, readyToAssign: 160000, carriedRta: 10000);
      // formatCents(10000) -> $100.00
      expect(
        find.text(r'Includes $100.00 carried from last period'),
        findsOneWidget,
      );
    });

    testWidgets('explains a negative carried balance as a deduction', (
      tester,
    ) async {
      await pumpCard(tester, readyToAssign: -5000, carriedRta: -5000);
      // Shows the absolute deducted amount, not the signed value.
      expect(
        find.text(
          r'$50.00 deducted: overspend or over-assignment last period',
        ),
        findsOneWidget,
      );
    });
  });
}
