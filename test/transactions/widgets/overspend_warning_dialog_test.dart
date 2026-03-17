import 'package:envelope/transactions/widgets/overspend_warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('showOverspendWarningDialog', () {
    Future<void> openDialog(WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await showOverspendWarningDialog(
                  context,
                  envelopeName: 'Groceries',
                  deficitCents: -5000, // -$50.00
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
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
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showOverspendWarningDialog(
                  context,
                  envelopeName: 'Groceries',
                  deficitCents: -5000,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('cover button closes with true', (tester) async {
      bool? result;
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showOverspendWarningDialog(
                  context,
                  envelopeName: 'Groceries',
                  deficitCents: -5000,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cover Overspending'));
      await tester.pumpAndSettle();

      expect(result, true);
    });
  });
}
