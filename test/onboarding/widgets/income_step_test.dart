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
  group('IncomeStep', () {
    late MockOnboardingCubit cubit;

    setUp(() {
      cubit = MockOnboardingCubit();
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.income,
        ),
      );
    });

    testWidgets('renders title and input', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: IncomeStep()),
        ),
      );
      expect(
        find.text('Expected Monthly Income'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('calls setExpectedIncome on text change',
        (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: IncomeStep()),
        ),
      );
      await tester.enterText(
        find.byType(TextField),
        '5000',
      );
      verify(() => cubit.setExpectedIncome(5000)).called(1);
    });
  });
}
