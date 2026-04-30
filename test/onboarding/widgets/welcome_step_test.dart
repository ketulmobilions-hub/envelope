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
  group('WelcomeStep', () {
    late MockOnboardingCubit cubit;

    setUp(() {
      cubit = MockOnboardingCubit();
      when(() => cubit.state).thenReturn(const OnboardingState());
    });

    testWidgets('renders welcome text and get started button', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: WelcomeStep()),
        ),
      );
      expect(find.text('Welcome to Envelope'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('get started button calls nextStep', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: WelcomeStep()),
        ),
      );
      await tester.tap(find.text('Get Started'));
      verify(() => cubit.nextStep()).called(1);
    });
  });
}
