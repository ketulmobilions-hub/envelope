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
  group('AllocationStep', () {
    late MockOnboardingCubit cubit;

    setUp(() {
      cubit = MockOnboardingCubit();
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.allocation,
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Needs',
              envelopes: ['Rent'],
            ),
          ],
        ),
      );
    });

    testWidgets('renders title', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: AllocationStep()),
        ),
      );
      expect(
        find.text('Allocate Your Income'),
        findsOneWidget,
      );
    });

    testWidgets('renders complete setup button', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: AllocationStep()),
        ),
      );
      expect(find.text('Complete Setup'), findsOneWidget);
    });

    testWidgets(
        'complete button calls completeOnboarding',
        (tester) async {
      when(() => cubit.completeOnboarding())
          .thenAnswer((_) async {});
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: AllocationStep()),
        ),
      );
      await tester.tap(find.text('Complete Setup'));
      verify(() => cubit.completeOnboarding()).called(1);
    });
  });
}
