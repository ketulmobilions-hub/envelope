import 'package:auth_repository/auth_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('ForgotPasswordPage', () {
    late MockAuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    testWidgets('renders email field and submit button', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ForgotPasswordPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Send Reset Email'), findsOneWidget);
    });

    testWidgets('renders instruction text', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ForgotPasswordPage(),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.text(
          "Enter your email address and we'll send you a link to "
          'reset your password.',
        ),
        findsOneWidget,
      );
    });
  });
}
