import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/routes/routes.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:envelope/onboarding/widgets/widgets.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    assert(user != null, 'OnboardingPage requires an authenticated user');

    return BlocProvider(
      create: (_) => OnboardingCubit(
        sharedPreferences: context.read<SharedPreferences>(),
        envelopeRepository: context.read<EnvelopeRepository>(),
        accountRepository: context.read<AccountRepository>(),
        budgetRepository: context.read<BudgetRepository>(),
        authRepository: context.read<AuthRepository>(),
        userId: user!.id,
        now: context.read<AppClock>().now,
      ),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.error != current.error,
      listener: (context, state) {
        if (state.status == OnboardingStatus.success) {
          context.go(AppRoutes.home);
        }
        if (state.status == OnboardingStatus.failure && state.error != null) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                _localizeError(context.l10n, state.error!),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final stepIndex = state.currentStep.index;
        final totalSteps = OnboardingStep.values.length;
        final isWelcome = state.currentStep == OnboardingStep.welcome;
        final isLastStep = stepIndex == totalSteps - 1;
        final isSubmitting = state.status == OnboardingStatus.submitting;

        return Scaffold(
          appBar: isWelcome
              ? null
              : AppBar(
                  title: Text(l10n.onboardingTitle),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () =>
                        context.read<OnboardingCubit>().previousStep(),
                  ),
                ),
          bottomNavigationBar: isWelcome
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                final cubit = context.read<OnboardingCubit>();
                                if (isLastStep) {
                                  unawaited(cubit.completeOnboarding());
                                } else {
                                  cubit.nextStep();
                                }
                              },
                        child: isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isLastStep
                                    ? l10n.onboardingComplete
                                    : l10n.onboardingContinue,
                              ),
                      ),
                    ),
                  ),
                ),
          body: Column(
            children: [
              if (!isWelcome)
                LinearProgressIndicator(
                  value: (stepIndex + 1) / totalSteps,
                ),
              Expanded(
                child: _buildStep(state.currentStep),
              ),
            ],
          ),
        );
      },
    );
  }

  String _localizeError(AppLocalizations l10n, OnboardingError error) {
    return switch (error) {
      OnboardingError.accountRequired => l10n.onboardingErrorAccountRequired,
      OnboardingError.envelopeRequired => l10n.onboardingErrorEnvelopeRequired,
      OnboardingError.completionFailed => l10n.onboardingErrorCompletionFailed,
    };
  }

  Widget _buildStep(OnboardingStep step) {
    return switch (step) {
      OnboardingStep.welcome => const WelcomeStep(),
      OnboardingStep.currency => const CurrencyStep(),
      OnboardingStep.accounts => const AccountsStep(),
      OnboardingStep.envelopes => const EnvelopesStep(),
    };
  }
}
