import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/utils/cc_payments_group.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';

part 'account_form_state.dart';

class AccountFormCubit extends Cubit<AccountFormState> {
  AccountFormCubit({
    required AccountRepository accountRepository,
    required this.budgetId,
    BudgetRepository? budgetRepository,
    EnvelopeRepository? envelopeRepository,
    this.account,
  }) : _accountRepository = accountRepository,
       _budgetRepository = budgetRepository,
       _envelopeRepository = envelopeRepository,
       super(const AccountFormState());

  final AccountRepository _accountRepository;
  final BudgetRepository? _budgetRepository;
  final EnvelopeRepository? _envelopeRepository;
  final String budgetId;
  final Account? account;

  bool get isEditing => account != null;

  /// Loads the existing credit limit for the account being edited.
  ///
  /// Emits [AccountFormState.existingCreditLimitCents] once resolved.
  Future<void> loadExistingCreditLimit() async {
    if (account == null) return;
    try {
      final debt = await _accountRepository.getDebtAccount(account!.id);
      emit(
        state.copyWith(existingCreditLimitCents: debt?.creditLimit),
      );
    } on AccountException {
      // Non-critical; form still works without the pre-fill.
    }
  }

  Future<void> submit({
    required String name,
    required String type,
    required int balanceCents,
    required String currency,
    required bool isOnBudget,
    double displayFxRate = 1.0,
    int? creditLimitCents,
  }) async {
    emit(state.copyWith(status: AccountFormStatus.submitting));
    try {
      if (isEditing) {
        final oldAccount = account!;
        final balanceDelta = balanceCents - oldAccount.startingBalance;
        final updated = oldAccount.copyWith(
          name: name,
          type: type,
          startingBalance: balanceCents,
          currentBalance: oldAccount.currentBalance + balanceDelta,
          currency: currency,
          displayFxRate: displayFxRate,
          isOnBudget: isOnBudget,
          updatedAt: DateTime.now(),
        );
        await _accountRepository.updateAccount(updated);

        if (isCreditCard(type) && creditLimitCents != null) {
          await _accountRepository.upsertDebtAccountCreditLimit(
            oldAccount.id,
            creditLimitCents,
          );
        }
      } else {
        final created = await _accountRepository.createAccount(
          budgetId: budgetId,
          name: name,
          type: type,
          currency: currency,
          displayFxRate: displayFxRate,
          startingBalance: balanceCents,
          isOnBudget: isOnBudget,
        );

        if (isCreditCard(type)) {
          if (_envelopeRepository != null) {
            await _createCCPaymentEnvelope(
              accountId: created.id,
              cardName: name,
            );
          }
          if (creditLimitCents != null) {
            await _accountRepository.upsertDebtAccountCreditLimit(
              created.id,
              creditLimitCents,
            );
          }
        }
      }

      // Recompute `Budget.openingBalance` from the current on-budget account
      // set and cascade `carriedRta` forward (issue #81). Replaces the old
      // `addIncomeToCurrentPeriod` deltas that wrote against the current
      // period — the seed cash now lives on the budget row (phase 3 of #80).
      if (_budgetRepository != null) {
        await _budgetRepository.refreshOpeningBalanceForBudget(budgetId);
      }
      emit(state.copyWith(status: AccountFormStatus.success));
    } on AccountException catch (e) {
      emit(
        state.copyWith(
          status: AccountFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on BudgetException catch (e) {
      emit(
        state.copyWith(
          status: AccountFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: AccountFormStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }

  // Finds or creates the "Credit Card Payments" category group, then creates
  // a linked payment envelope for the given CC account.
  Future<void> _createCCPaymentEnvelope({
    required String accountId,
    required String cardName,
  }) async {
    try {
      final repo = _envelopeRepository!;
      final group = await findOrCreateCCPaymentsGroup(
        repository: repo,
        budgetId: budgetId,
      );
      await repo.createEnvelope(
        categoryGroupId: group.id,
        budgetId: budgetId,
        name: '$cardName Payment',
        linkedAccountId: accountId,
      );
    } on Exception {
      // Best-effort; the user can create the envelope manually if needed.
    }
  }
}
