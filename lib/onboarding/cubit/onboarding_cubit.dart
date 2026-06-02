import 'package:account_repository/account_repository.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/utils/cc_payments_group.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

/// Key used in [SharedPreferences] to store the active budget ID.
/// The router uses this to determine if onboarding is complete:
/// if set, the user has a budget and is onboarded.
const String activeBudgetIdKey = 'active_budget_id';

/// Cubit that manages the onboarding wizard state.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required SharedPreferences sharedPreferences,
    required EnvelopeRepository envelopeRepository,
    required AccountRepository accountRepository,
    required BudgetRepository budgetRepository,
    required AuthRepository authRepository,
    required String userId,
    DateTime Function()? now,
  }) : _prefs = sharedPreferences,
       _envelopeRepository = envelopeRepository,
       _accountRepository = accountRepository,
       _budgetRepository = budgetRepository,
       _authRepository = authRepository,
       _userId = userId,
       _now = now ?? DateTime.now,
       super(const OnboardingState());

  final SharedPreferences _prefs;
  final EnvelopeRepository _envelopeRepository;
  final AccountRepository _accountRepository;
  final BudgetRepository _budgetRepository;
  final AuthRepository _authRepository;
  final String _userId;
  final DateTime Function() _now;

  /// Returns whether onboarding has been completed (user has a budget).
  static bool isOnboardingComplete(SharedPreferences prefs) {
    final budgetId = prefs.getString(activeBudgetIdKey);
    return budgetId != null && budgetId.isNotEmpty;
  }

  /// Advances to the next step if validation passes.
  void nextStep() {
    const steps = OnboardingStep.values;
    final currentIndex = state.currentStep.index;

    // Validation per step
    final error = _validateCurrentStep();
    if (error != null) {
      emit(state.copyWith(status: OnboardingStatus.failure, error: error));
      emit(state.copyWith(status: OnboardingStatus.initial, error: error));
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

  /// Returns a validation error for the current step, or null if valid.
  OnboardingError? _validateCurrentStep() {
    return switch (state.currentStep) {
      OnboardingStep.accounts when state.accounts.isEmpty =>
        OnboardingError.accountRequired,
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
      // Persist the selected base currency on the user profile so the rest
      // of the app (settings, formatters reading AuthBloc) reflects it.
      await _authRepository.updateProfile(baseCurrency: state.baseCurrency);

      // Normalize each account's starting balance to cents up front so the
      // clamp/rounding is applied identically when seeding the budget's
      // `openingBalance` and when creating each account row.
      // startingBalance is stored as cents (int) — use .round() to handle
      // floating-point imprecision from the double input.
      final accountsWithCents = state.accounts.map((account) {
        final clampedBalance = account.startingBalance.clamp(
          -maxDollarAmount,
          maxDollarAmount,
        );
        return (account: account, balanceCents: (clampedBalance * 100).round());
      }).toList();

      // Compute the period-agnostic seed cash (sum of on-budget account
      // starting balances in cents). It is stored on the budget as
      // `openingBalance` so it remains available in any period — including
      // backdated periods auto-created later — rather than being trapped on
      // the onboarding month's `totalIncome` (issue #80).
      var openingBalance = 0;
      for (final entry in accountsWithCents) {
        if (!entry.account.isOnBudget) continue;
        if (entry.balanceCents > 0) {
          openingBalance += entry.balanceCents;
        }
      }

      final now = _now();

      // Create the budget first — RLS policies require a budget row to exist
      // before accounts/envelopes can reference it.
      final budget = await _budgetRepository.createBudget(
        name: 'My Budget',
        baseCurrency: state.baseCurrency,
        ownerId: _userId,
        openingBalance: openingBalance,
        openingDate: DateTime(now.year, now.month),
      );
      final budgetId = budget.id;

      // Create accounts.
      final ccAccounts = <({String accountId, String cardName})>[];
      for (final entry in accountsWithCents) {
        final account = entry.account;
        final balanceCents = entry.balanceCents;
        final created = await _accountRepository.createAccount(
          budgetId: budgetId,
          name: account.name,
          type: account.type,
          currency: account.currency,
          startingBalance: balanceCents,
          isOnBudget: account.isOnBudget,
        );

        if (isCreditCard(account.type)) {
          final creditLimitCents = account.creditLimitCents;
          if (creditLimitCents != null) {
            try {
              await _accountRepository.upsertDebtAccountCreditLimit(
                created.id,
                creditLimitCents,
              );
            } on Exception {
              // Best-effort; user can edit the limit later from the account.
            }
          }
          ccAccounts.add((accountId: created.id, cardName: account.name));
        }
      }

      // Issue #82: budget periods removed. RTA is global; seed cash lives on
      // `Budget.openingBalance` and folds into RTA directly. No period to
      // create here.

      // Create category groups and their envelopes.
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

      // Create CC Payments group + linked payment envelopes AFTER the user's
      // groups so it appears at the bottom of the dashboard (matches the
      // ordering produced by the regular Add Account flow).
      if (ccAccounts.isNotEmpty) {
        try {
          final ccGroup = await findOrCreateCCPaymentsGroup(
            repository: _envelopeRepository,
            budgetId: budgetId,
          );
          for (final cc in ccAccounts) {
            try {
              await _envelopeRepository.createEnvelope(
                categoryGroupId: ccGroup.id,
                budgetId: budgetId,
                name: '${cc.cardName} Payment',
                linkedAccountId: cc.accountId,
              );
            } on Exception {
              // Best-effort per-card.
            }
          }
        } on Exception {
          // Group creation failed; user can add the envelope manually.
        }
      }

      await _prefs.setString(activeBudgetIdKey, budgetId);
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
