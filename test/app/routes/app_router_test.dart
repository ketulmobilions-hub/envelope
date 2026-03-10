import 'package:envelope/app/routes/app_router.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('AppRouter', () {
    late GoRouter router;

    setUp(() {
      router = createRouter();
    });

    Widget buildApp() {
      return MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }

    testWidgets('initial route is splash', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('navigates to login', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      router.go(AppRoutes.login);
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to home', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      router.go(AppRoutes.home);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
