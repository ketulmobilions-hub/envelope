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
  group('EnvelopesStep', () {
    late MockOnboardingCubit cubit;

    setUp(() {
      cubit = MockOnboardingCubit();
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.envelopes,
        ),
      );
    });

    testWidgets('renders title and description', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: EnvelopesStep()),
        ),
      );
      expect(
        find.text('Set Up Your Envelopes'),
        findsOneWidget,
      );
    });

    testWidgets('renders default category groups', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: EnvelopesStep()),
        ),
      );
      expect(find.text('Needs'), findsOneWidget);
      expect(find.text('Wants'), findsOneWidget);
      expect(
        find.text('Savings/Investments'),
        findsOneWidget,
      );
    });

    testWidgets('renders add group button', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: EnvelopesStep()),
        ),
      );
      expect(find.text('Add Group'), findsOneWidget);
    });

    testWidgets('delete button calls removeCategoryGroup', (tester) async {
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.envelopes,
          categoryGroups: [
            OnboardingCategoryGroup(
              name: 'Test',
              envelopes: <String>[],
            ),
          ],
        ),
      );
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: EnvelopesStep()),
        ),
      );
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      verify(() => cubit.removeCategoryGroup(0)).called(1);
    });
  });
}
