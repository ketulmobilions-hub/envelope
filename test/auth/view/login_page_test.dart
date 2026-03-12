import 'package:auth_repository/auth_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginPage', () {
    late MockAuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LoginPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('renders social sign-in buttons', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LoginPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('renders sign up and forgot password links', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LoginPage(),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.text("Don't have an account? Sign up"),
        findsOneWidget,
      );
      expect(find.text('Forgot password?'), findsOneWidget);
    });
  });
}
