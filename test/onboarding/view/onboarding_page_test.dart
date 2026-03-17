import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:envelope/onboarding/view/onboarding_page.dart';
import 'package:envelope/onboarding/widgets/widgets.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockOnboardingCubit extends MockCubit<OnboardingState>
    implements OnboardingCubit {}

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  group('OnboardingPage', () {
    late SharedPreferences prefs;
    late MockEnvelopeRepository envelopeRepository;
    late MockAccountRepository accountRepository;
    late MockAuthBloc authBloc;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      envelopeRepository = MockEnvelopeRepository();
      accountRepository = MockAccountRepository();
      authBloc = MockAuthBloc();

      final now = DateTime.now();
      when(() => authBloc.state).thenReturn(
        AuthState.authenticated(
          User(
            id: 'test-user-id',
            email: 'test@test.com',
            displayName: 'Test',
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );
    });

    testWidgets('renders OnboardingView', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<SharedPreferences>.value(value: prefs),
            RepositoryProvider<EnvelopeRepository>.value(
              value: envelopeRepository,
            ),
            RepositoryProvider<AccountRepository>.value(
              value: accountRepository,
            ),
          ],
          child: BlocProvider<AuthBloc>.value(
            value: authBloc,
            child: MaterialApp(
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const OnboardingPage(),
            ),
          ),
        ),
      );
      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });

  group('OnboardingView', () {
    late MockOnboardingCubit cubit;

    setUp(() {
      cubit = MockOnboardingCubit();
    });

    Widget buildSubject() {
      return BlocProvider<OnboardingCubit>.value(
        value: cubit,
        child: MaterialApp(
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OnboardingView(),
        ),
      );
    }

    testWidgets('renders WelcomeStep on welcome step',
        (tester) async {
      when(() => cubit.state).thenReturn(const OnboardingState());
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeStep), findsOneWidget);
    });

    testWidgets('renders CurrencyStep on currency step',
        (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.currency,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(CurrencyStep), findsOneWidget);
    });

    testWidgets('renders AccountsStep on accounts step',
        (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.accounts,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(AccountsStep), findsOneWidget);
    });

    testWidgets('renders IncomeStep on income step',
        (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.income,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(IncomeStep), findsOneWidget);
    });

    testWidgets('renders EnvelopesStep on envelopes step',
        (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.envelopes,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(EnvelopesStep), findsOneWidget);
    });

    testWidgets('renders AllocationStep on allocation step',
        (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.allocation,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(AllocationStep), findsOneWidget);
    });

    testWidgets(
        'shows progress indicator on non-welcome steps',
        (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.currency,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(
        find.byType(LinearProgressIndicator),
        findsOneWidget,
      );
    });

    testWidgets(
        'hides progress indicator on welcome step',
        (tester) async {
      when(() => cubit.state).thenReturn(const OnboardingState());
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(
        find.byType(LinearProgressIndicator),
        findsNothing,
      );
    });

    testWidgets('back button calls previousStep', (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.currency,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      verify(() => cubit.previousStep()).called(1);
    });

    testWidgets('continue button calls nextStep', (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.currency,
        ),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      verify(() => cubit.nextStep()).called(1);
    });

    testWidgets('shows snackbar on failure with error',
        (tester) async {
      when(() => cubit.state).thenReturn(const OnboardingState());
      whenListen(
        cubit,
        Stream.fromIterable([
          const OnboardingState(
            status: OnboardingStatus.failure,
            error: OnboardingError.completionFailed,
          ),
        ]),
        initialState: const OnboardingState(),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
