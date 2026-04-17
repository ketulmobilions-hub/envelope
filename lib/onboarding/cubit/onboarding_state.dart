part of 'onboarding_cubit.dart';

/// The steps of the onboarding wizard.
enum OnboardingStep {
  welcome,
  currency,
  accounts,
  envelopes,
  allocation,
}

/// Status of the onboarding submission.
enum OnboardingStatus { initial, submitting, success, failure }

/// Error codes emitted by the cubit for localization in the UI.
enum OnboardingError {
  accountRequired,
  envelopeRequired,
  completionFailed,
}

/// An account added during onboarding.
final class OnboardingAccount extends Equatable {
  const OnboardingAccount({
    required this.name,
    required this.type,
    required this.currency,
    this.startingBalance = 0,
    this.isOnBudget = true,
  });

  final String name;
  final String type;
  final String currency;
  final double startingBalance;
  final bool isOnBudget;

  @override
  List<Object?> get props => [name, type, currency, startingBalance, isOnBudget];
}

/// A category group with its envelope names.
final class OnboardingCategoryGroup extends Equatable {
  const OnboardingCategoryGroup({
    required this.name,
    required this.envelopes,
  });

  final String name;
  final List<String> envelopes;

  OnboardingCategoryGroup copyWith({
    String? name,
    List<String>? envelopes,
  }) {
    return OnboardingCategoryGroup(
      name: name ?? this.name,
      envelopes: envelopes ?? this.envelopes,
    );
  }

  @override
  List<Object?> get props => [name, envelopes];
}

/// Default category groups for new users.
const List<OnboardingCategoryGroup> defaultCategoryGroups = [
  OnboardingCategoryGroup(
    name: 'Needs',
    envelopes: [
      'Rent/Mortgage',
      'Utilities',
      'Groceries',
      'Transportation',
      'Insurance',
      'Healthcare',
    ],
  ),
  OnboardingCategoryGroup(
    name: 'Wants',
    envelopes: [
      'Dining Out',
      'Entertainment',
      'Shopping',
      'Subscriptions',
    ],
  ),
  OnboardingCategoryGroup(
    name: 'Savings/Investments',
    envelopes: [
      'Emergency Fund',
      'Retirement',
      'Vacation',
    ],
  ),
];

/// State for the onboarding wizard.
final class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentStep = OnboardingStep.welcome,
    this.status = OnboardingStatus.initial,
    this.error,
    this.baseCurrency = 'USD',
    this.accounts = const [],
    this.categoryGroups = defaultCategoryGroups,
    this.allocations = const {},
  });

  final OnboardingStep currentStep;
  final OnboardingStatus status;
  final OnboardingError? error;
  final String baseCurrency;
  final List<OnboardingAccount> accounts;
  final List<OnboardingCategoryGroup> categoryGroups;
  final Map<String, double> allocations;

  /// Creates a copy with updated fields.
  ///
  /// Pass [clearError] = true to explicitly clear the error.
  /// Otherwise error is preserved from the current state.
  OnboardingState copyWith({
    OnboardingStep? currentStep,
    OnboardingStatus? status,
    OnboardingError? error,
    bool clearError = false,
    String? baseCurrency,
    List<OnboardingAccount>? accounts,
    List<OnboardingCategoryGroup>? categoryGroups,
    Map<String, double>? allocations,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      baseCurrency: baseCurrency ?? this.baseCurrency,
      accounts: accounts ?? this.accounts,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      allocations: allocations ?? this.allocations,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        status,
        error,
        baseCurrency,
        accounts,
        categoryGroups,
        allocations,
      ];
}
