import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:envelope/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockOnboardingCubit extends MockCubit<OnboardingState>
    implements OnboardingCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const OnboardingAccount(
        name: '_',
        type: 'checking',
        currency: 'USD',
      ),
    );
  });

  group('AccountsStep', () {
    late MockOnboardingCubit cubit;

    setUp(() {
      cubit = MockOnboardingCubit();
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.accounts,
        ),
      );
    });

    testWidgets('renders title and add account button', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: AccountsStep()),
        ),
      );
      expect(
        find.text('Add Your Accounts'),
        findsOneWidget,
      );
      expect(find.text('Add Account'), findsOneWidget);
    });

    testWidgets('displays added accounts', (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.accounts,
          accounts: [
            OnboardingAccount(
              name: 'My Checking',
              type: 'checking',
              currency: 'USD',
            ),
          ],
        ),
      );
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: AccountsStep()),
        ),
      );
      expect(find.text('My Checking'), findsOneWidget);
    });

    testWidgets('delete button calls removeAccount', (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.accounts,
          accounts: [
            OnboardingAccount(
              name: 'Test',
              type: 'checking',
              currency: 'USD',
            ),
          ],
        ),
      );
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: AccountsStep()),
        ),
      );
      await tester.tap(find.byIcon(Icons.delete_outline));
      verify(() => cubit.removeAccount(0)).called(1);
    });

    testWidgets(
      'displays CC account with credit_card type label',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const OnboardingState(
            currentStep: OnboardingStep.accounts,
            accounts: [
              OnboardingAccount(
                name: 'Visa',
                type: 'credit_card',
                currency: 'USD',
                creditLimitCents: 500000,
              ),
            ],
          ),
        );
        await tester.pumpApp(
          BlocProvider<OnboardingCubit>.value(
            value: cubit,
            child: const Scaffold(body: AccountsStep()),
          ),
        );
        expect(find.text('Visa'), findsOneWidget);
        expect(find.textContaining('Credit Card'), findsWidgets);
      },
    );
  });
}
