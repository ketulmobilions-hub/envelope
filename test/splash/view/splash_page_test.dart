import 'package:envelope/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SplashPage', () {
    testWidgets('renders loading indicator', (tester) async {
      await tester.pumpApp(const SplashPage());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders app title', (tester) async {
      await tester.pumpApp(const SplashPage());
      expect(find.text('Envelope'), findsOneWidget);
    });
  });
}
