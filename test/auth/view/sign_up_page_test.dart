import 'package:auth_repository/auth_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignUpPage', () {
    late MockAuthRepository authRepository;

    setUp(() {
      authRepository = MockAuthRepository();
    });

    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SignUpPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Display Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Create Account'),
        findsOneWidget,
      );
    });

    testWidgets('renders back to login link', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthRepository>.value(
          value: authRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SignUpPage(),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.text('Already have an account? Sign in'),
        findsOneWidget,
      );
    });
  });
}
