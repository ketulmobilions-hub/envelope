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

        // Adjust income when isOnBudget or startingBalance changes.
        if (_budgetRepository != null) {
          if (oldAccount.isOnBudget != isOnBudget) {
            // isOnBudget toggled: add or remove the full new balance.
            if (isOnBudget && balanceCents > 0) {
              await _budgetRepository.addIncomeToCurrentPeriod(
                budgetId: budgetId,
                amount: balanceCents,
              );
            } else if (!isOnBudget && oldAccount.startingBalance > 0) {
              await _budgetRepository.addIncomeToCurrentPeriod(
                budgetId: budgetId,
                amount: -oldAccount.startingBalance,
              );
            }
          } else if (isOnBudget && balanceDelta != 0) {
            // Balance changed while staying on-budget: adjust by delta.
            await _budgetRepository.addIncomeToCurrentPeriod(
              budgetId: budgetId,
              amount: balanceDelta,
            );
          }
        }
      } else {
        final created = await _accountRepository.createAccount(
          budgetId: budgetId,
          name: name,
          type: type,
          currency: currency,
          startingBalance: balanceCents,
          isOnBudget: isOnBudget,
        );

        if (balanceCents != 0 && isOnBudget && _budgetRepository != null) {
          await _budgetRepository.addIncomeToCurrentPeriod(
            budgetId: budgetId,
            amount: balanceCents,
          );
        }

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
