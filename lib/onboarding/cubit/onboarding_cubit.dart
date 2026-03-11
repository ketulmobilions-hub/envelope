import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

/// Key used in [SharedPreferences] to persist onboarding completion.
const String _onboardingCompleteKey = 'onboarding_complete';

/// Cubit that manages the onboarding wizard state.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences,
        super(const OnboardingState());

  final SharedPreferences _prefs;

  /// Returns whether onboarding has been completed.
  static Future<bool> isOnboardingComplete(SharedPreferences prefs) async {
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
          when state.categoryGroups
              .every((g) => g.envelopes.isEmpty) =>
        OnboardingError.envelopeRequired,
      _ => null,
    };
  }

  /// Marks onboarding as complete and persists the flag.
  Future<void> completeOnboarding() async {
    emit(state.copyWith(status: OnboardingStatus.submitting));
    try {
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
