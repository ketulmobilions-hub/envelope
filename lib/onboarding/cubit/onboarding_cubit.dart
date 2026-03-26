import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

/// Key used in [SharedPreferences] to persist onboarding completion.
const String _onboardingCompleteKey = 'onboarding_complete';

/// Key used in [SharedPreferences] to store the active budget ID.
const String activeBudgetIdKey = 'active_budget_id';

/// Cubit that manages the onboarding wizard state.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required SharedPreferences sharedPreferences,
    required EnvelopeRepository envelopeRepository,
    required AccountRepository accountRepository,
    required BudgetRepository budgetRepository,
    required String userId,
  }) : _prefs = sharedPreferences,
       _envelopeRepository = envelopeRepository,
       _accountRepository = accountRepository,
       _budgetRepository = budgetRepository,
       _userId = userId,
       super(const OnboardingState());

  final SharedPreferences _prefs;
  final EnvelopeRepository _envelopeRepository;
  final AccountRepository _accountRepository;
  final BudgetRepository _budgetRepository;
  final String _userId;

  /// Returns whether onboarding has been completed.
  static bool isOnboardingComplete(SharedPreferences prefs) {
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Advances to the next step if validation passes.
  void nextStep() {
    const steps = OnboardingStep.values;
    final currentIndex = state.currentStep.index;

    // Validation per step
    final error = _validateCurrentStep();
    if (error != null) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          error: error,
        ),
      );
      return;
    }

    if (currentIndex < steps.length - 1) {
      emit(
        state.copyWith(
          currentStep: steps[currentIndex + 1],
          status: OnboardingStatus.initial,
          clearError: true,
        ),
      );
    }
  }

  /// Goes back to the previous step.
  void previousStep() {
    const steps = OnboardingStep.values;
    final currentIndex = state.currentStep.index;

    if (currentIndex > 0) {
      emit(
        state.copyWith(
          currentStep: steps[currentIndex - 1],
          status: OnboardingStatus.initial,
          clearError: true,
        ),
      );
    }
  }

  /// Selects the base currency.
  void selectCurrency(String code) {
    emit(state.copyWith(baseCurrency: code));
  }

  /// Adds an account.
  void addAccount(OnboardingAccount account) {
    emit(state.copyWith(accounts: [...state.accounts, account]));
  }

  /// Removes an account by index.
  void removeAccount(int index) {
    final accounts = [...state.accounts]..removeAt(index);
    emit(state.copyWith(accounts: accounts));
  }

  /// Sets the expected monthly income.
  void setExpectedIncome(double amount) {
    emit(state.copyWith(expectedIncome: amount));
  }

  /// Adds a new category group.
  void addCategoryGroup(String name) {
    emit(
      state.copyWith(
        categoryGroups: [
          ...state.categoryGroups,
          OnboardingCategoryGroup(name: name, envelopes: const []),
        ],
      ),
    );
  }

  /// Removes a category group by index.
  void removeCategoryGroup(int index) {
    final groups = [...state.categoryGroups]..removeAt(index);
    emit(state.copyWith(categoryGroups: groups));
  }

  /// Renames a category group.
  void renameCategoryGroup(int index, String name) {
    final groups = [...state.categoryGroups];
    groups[index] = groups[index].copyWith(name: name);
    emit(state.copyWith(categoryGroups: groups));
  }

  /// Adds an envelope to a category group.
  void addEnvelope(int groupIndex, String name) {
    final groups = [...state.categoryGroups];
    groups[groupIndex] = groups[groupIndex].copyWith(
      envelopes: [...groups[groupIndex].envelopes, name],
    );
    emit(state.copyWith(categoryGroups: groups));
  }

  /// Removes an envelope from a category group.
  void removeEnvelope(int groupIndex, int envelopeIndex) {
    final groups = [...state.categoryGroups];
    final envelopes = [...groups[groupIndex].envelopes]
      ..removeAt(envelopeIndex);
    groups[groupIndex] = groups[groupIndex].copyWith(envelopes: envelopes);
    emit(state.copyWith(categoryGroups: groups));
  }

  /// Renames an envelope in a category group.
  void renameEnvelope(int groupIndex, int envelopeIndex, String name) {
    final groups = [...state.categoryGroups];
    final envelopes = [...groups[groupIndex].envelopes];
    envelopes[envelopeIndex] = name;
    groups[groupIndex] = groups[groupIndex].copyWith(envelopes: envelopes);
    emit(state.copyWith(categoryGroups: groups));
  }

  /// Sets the allocation amount for an envelope.
  ///
  /// Uses a composite key `groupIndex:envelopeName` to avoid collisions
  /// when multiple groups have envelopes with the same name.
  void setAllocation(
    int groupIndex,
    String envelopeName,
    double amount,
  ) {
    final key = '$groupIndex:$envelopeName';
    emit(
      state.copyWith(
        allocations: {...state.allocations, key: amount},
      ),
    );
  }

  /// Returns the allocation for a specific envelope.
  double getAllocation(int groupIndex, String envelopeName) {
    return state.allocations['$groupIndex:$envelopeName'] ?? 0;
  }

  /// Returns a validation error for the current step, or null if valid.
  OnboardingError? _validateCurrentStep() {
    return switch (state.currentStep) {
      OnboardingStep.accounts when state.accounts.isEmpty =>
        OnboardingError.accountRequired,
      OnboardingStep.income when state.expectedIncome <= 0 =>
        OnboardingError.incomeRequired,
      OnboardingStep.envelopes
          when state.categoryGroups.every((g) => g.envelopes.isEmpty) =>
        OnboardingError.envelopeRequired,
      _ => null,
    };
  }

  /// Marks onboarding as complete, persists all data to the backend,
  /// and sets the SharedPreferences flag.
  ///
  /// NOTE: If a failure occurs mid-way, already-created entities remain in
  /// the backend (partial persistence). On retry the user may get duplicates.
  // TODO(ketulmobilions-hub): Add idempotency keys or upsert
  //  logic to prevent duplicates (#46).
  Future<void> completeOnboarding() async {
    emit(state.copyWith(status: OnboardingStatus.submitting));
    try {
      // Create the budget first — RLS policies require a budget row to exist
      // before accounts/envelopes can reference it.
      final budget = await _budgetRepository.createBudget(
        name: 'My Budget',
        baseCurrency: state.baseCurrency,
        ownerId: _userId,
      );
      final budgetId = budget.id;

      // Create accounts.
      // startingBalance is stored as cents (int) — use .round() to handle
      // floating-point imprecision from the double input.
      var totalStartingBalance = 0;
      for (final account in state.accounts) {
        final balanceCents = (account.startingBalance * 100).round();
        if (account.isOnBudget) {
          totalStartingBalance += balanceCents;
        }
        await _accountRepository.createAccount(
          budgetId: budgetId,
          name: account.name,
          type: account.type,
          currency: account.currency,
          startingBalance: balanceCents,
          isOnBudget: account.isOnBudget,
        );
      }

      // Create the initial budget period for the current month.
      // totalIncome is seeded with the sum of all account starting balances
      // so that "Ready to Assign" reflects money available to budget.
      final now = DateTime.now();
      final periodStart = DateTime(now.year, now.month);
      final periodEnd = DateTime(now.year, now.month + 1)
          .subtract(const Duration(days: 1));
      await _budgetRepository.createBudgetPeriod(
        budgetId: budgetId,
        startDate: periodStart,
        endDate: periodEnd,
        totalIncome: totalStartingBalance,
      );

      // Create category groups and their envelopes
      for (final group in state.categoryGroups) {
        final createdGroup = await _envelopeRepository.createCategoryGroup(
          budgetId: budgetId,
          name: group.name,
        );

        for (final envelopeName in group.envelopes) {
          await _envelopeRepository.createEnvelope(
            categoryGroupId: createdGroup.id,
            budgetId: budgetId,
            name: envelopeName,
          );
        }
      }

      await _prefs.setString(activeBudgetIdKey, budgetId);
      await _prefs.setBool(_onboardingCompleteKey, true);
      emit(state.copyWith(status: OnboardingStatus.success));
    } on Exception {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          error: OnboardingError.completionFailed,
        ),
      );
    }
  }
}
