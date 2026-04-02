import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

part 'account_form_state.dart';

class AccountFormCubit extends Cubit<AccountFormState> {
  AccountFormCubit({
    required AccountRepository accountRepository,
    required this.budgetId,
    BudgetRepository? budgetRepository,
    this.account,
  })  : _accountRepository = accountRepository,
        _budgetRepository = budgetRepository,
        super(const AccountFormState());

  final AccountRepository _accountRepository;
  final BudgetRepository? _budgetRepository;
  final String budgetId;
  final Account? account;

  bool get isEditing => account != null;

  Future<void> submit({
    required String name,
    required String type,
    required int balanceCents,
    required String currency,
    required bool isOnBudget,
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
        await _accountRepository.createAccount(
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
}
