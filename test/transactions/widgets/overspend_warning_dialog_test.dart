import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/theme.dart';
import 'package:envelope/transactions/widgets/overspend_warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  final now = DateTime(2026, 3, 17);

  late AuthBloc authBloc;

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

  group('showOverspendWarningDialog', () {
    // Pumps a MaterialApp with AuthBloc provided above the (root) navigator so
    // the dialog — shown via showDialog on the root navigator — can resolve it
    // (the dialog reads the base currency from AuthBloc via currencySymbol).
    Future<void> pumpDialog(
      WidgetTester tester, {
      void Function(bool?)? onResult,
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
                  final result = await showOverspendWarningDialog(
                    context,
                    envelopeName: 'Groceries',
                    deficitCents: -5000, // -$50.00
                  );
                  onResult?.call(result);
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
    }

    Future<void> openDialog(WidgetTester tester) async {
      await pumpDialog(tester);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    testWidgets('displays warning title and message', (tester) async {
      await openDialog(tester);
      expect(find.text('Envelope Overspent'), findsOneWidget);
      expect(
        find.textContaining('Groceries'),
        findsOneWidget,
      );
      expect(
        find.textContaining(r'$50.00'),
        findsOneWidget,
      );
    });

    testWidgets('displays warning icon', (tester) async {
      await openDialog(tester);
      expect(
        find.byIcon(Icons.warning_amber_rounded),
        findsOneWidget,
      );
    });

    testWidgets('dismiss button closes with false', (tester) async {
      bool? result;
      await pumpDialog(tester, onResult: (r) => result = r);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('cover button closes with true', (tester) async {
      bool? result;
      await pumpDialog(tester, onResult: (r) => result = r);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cover Overspending'));
      await tester.pumpAndSettle();

      expect(result, true);
    });
  });
}
