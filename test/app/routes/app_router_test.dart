import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/app/routes/app_router.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AppRouter', () {
    late MockAuthBloc authBloc;
    late MockAuthRepository authRepository;
    late GoRouter router;

    setUp(() {
      authBloc = MockAuthBloc();
      authRepository = MockAuthRepository();
    });

    Widget buildApp() {
      return RepositoryProvider<AuthRepository>.value(
        value: authRepository,
        child: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
    }

    testWidgets('shows splash when auth status is unknown', (tester) async {
      when(() => authBloc.state).thenReturn(const AuthState.unknown());
      router = createRouter(authBloc: authBloc);
      await tester.pumpWidget(buildApp());
      await tester.pump();
      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets(
      'redirects to login when unauthenticated',
      (tester) async {
        when(() => authBloc.state)
            .thenReturn(const AuthState.unauthenticated());
        router = createRouter(authBloc: authBloc);
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();
        expect(find.byType(LoginPage), findsOneWidget);
      },
    );

    testWidgets(
      'redirects to home when authenticated',
      (tester) async {
        when(() => authBloc.state).thenReturn(
          AuthState.authenticated(
            User(
              id: '1',
              email: 'test@test.com',
              displayName: 'Test',
              createdAt: DateTime(2024),
              updatedAt: DateTime(2024),
            ),
          ),
        );
        router = createRouter(authBloc: authBloc);
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();
        expect(find.byType(HomePage), findsOneWidget);
      },
    );
  });
}
