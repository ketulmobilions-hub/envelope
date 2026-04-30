import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/routes/app_router.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/onboarding.dart';
import 'package:envelope/splash/splash.dart';
import 'package:envelope/sync/bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSyncBloc extends MockBloc<SyncEvent, SyncBlocState>
    implements SyncBloc {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

void main() {
  group('AppRouter', () {
    late MockAuthBloc authBloc;
    late MockAuthRepository authRepository;
    late MockSyncBloc syncBloc;
    late MockTransactionRepository transactionRepository;
    late MockAccountRepository accountRepository;
    late MockBudgetRepository budgetRepository;
    late MockEnvelopeRepository envelopeRepository;
    late GoRouter router;

    late SharedPreferences prefs;

    setUp(() async {
      authBloc = MockAuthBloc();
      authRepository = MockAuthRepository();
      syncBloc = MockSyncBloc();
      transactionRepository = MockTransactionRepository();
      accountRepository = MockAccountRepository();
      budgetRepository = MockBudgetRepository();
      envelopeRepository = MockEnvelopeRepository();
      when(() => syncBloc.state).thenReturn(const SyncBlocState());
      when(
        () => transactionRepository.watchRecurringRules(any()),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => transactionRepository.watchBillReminders(any()),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => transactionRepository.watchTransactions(
          budgetId: any(named: 'budgetId'),
        ),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => transactionRepository.refreshTransactions(any()),
      ).thenAnswer((_) async {});
      when(
        () => budgetRepository.watchBudgetPeriods(any()),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => budgetRepository.refreshBudgetPeriods(any()),
      ).thenAnswer((_) async {});
      when(
        () => accountRepository.watchAccounts(any()),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => accountRepository.refreshAccounts(any()),
      ).thenAnswer((_) async {});
      when(
        () => envelopeRepository.watchEnvelopes(any()),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => envelopeRepository.watchCategoryGroups(any()),
      ).thenAnswer((_) => Stream.value([]));
      when(
        () => envelopeRepository.refreshEnvelopes(any()),
      ).thenAnswer((_) async {});
      when(
        () => envelopeRepository.refreshCategoryGroups(any()),
      ).thenAnswer((_) async {});
      SharedPreferences.setMockInitialValues(
        {'onboarding_complete': true},
      );
      prefs = await SharedPreferences.getInstance();
    });

    Widget buildApp() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SharedPreferences>.value(value: prefs),
          RepositoryProvider<AuthRepository>.value(value: authRepository),
          RepositoryProvider<TransactionRepository>.value(
            value: transactionRepository,
          ),
          RepositoryProvider<AccountRepository>.value(
            value: accountRepository,
          ),
          RepositoryProvider<BudgetRepository>.value(
            value: budgetRepository,
          ),
          RepositoryProvider<EnvelopeRepository>.value(
            value: envelopeRepository,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<SyncBloc>.value(value: syncBloc),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
    }

    testWidgets(
      'shows splash when auth status is unknown',
      (tester) async {
        when(() => authBloc.state).thenReturn(const AuthState.unknown());
        router = createRouter(
          authBloc: authBloc,
          sharedPreferences: prefs,
        );
        await tester.pumpWidget(buildApp());
        await tester.pump();
        expect(find.byType(SplashPage), findsOneWidget);
      },
    );

    testWidgets(
      'redirects to login when unauthenticated',
      (tester) async {
        when(
          () => authBloc.state,
        ).thenReturn(const AuthState.unauthenticated());
        router = createRouter(
          authBloc: authBloc,
          sharedPreferences: prefs,
        );
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();
        expect(find.byType(LoginPage), findsOneWidget);
      },
    );

    testWidgets(
      'redirects to home when authenticated and onboarded',
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
        router = createRouter(
          authBloc: authBloc,
          sharedPreferences: prefs,
        );
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();
        expect(find.byType(HomePage), findsOneWidget);
      },
    );

    testWidgets(
      'redirects to onboarding when authenticated but not onboarded',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        prefs = await SharedPreferences.getInstance();
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
        router = createRouter(
          authBloc: authBloc,
          sharedPreferences: prefs,
        );
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();
        expect(find.byType(OnboardingPage), findsOneWidget);
      },
    );
  });
}
