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
  group('CurrencyStep', () {
    late MockOnboardingCubit cubit;

    setUp(() {
      cubit = MockOnboardingCubit();
      when(() => cubit.state).thenReturn(
        const OnboardingState(
          currentStep: OnboardingStep.currency,
        ),
      );
    });

    testWidgets('renders title and search field', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: CurrencyStep()),
        ),
      );
      expect(
        find.text('Choose Your Currency'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders currency list', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: CurrencyStep()),
        ),
      );
      expect(find.text(r'USD - US Dollar ($)'), findsOneWidget);
    });

    testWidgets('selectCurrency called on radio tap', (tester) async {
      await tester.pumpApp(
        BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const Scaffold(body: CurrencyStep()),
        ),
      );
      // Tap the Radio for EUR
      final eurRadio = find.byWidgetPredicate(
        (widget) => widget is Radio<String> && widget.value == 'EUR',
      );
      await tester.tap(eurRadio);
      verify(() => cubit.selectCurrency('EUR')).called(1);
    });
  });
}
