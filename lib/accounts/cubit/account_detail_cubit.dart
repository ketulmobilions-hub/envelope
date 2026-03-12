import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_detail_state.dart';

class AccountDetailCubit extends Cubit<AccountDetailState> {
  AccountDetailCubit({
    required AccountRepository accountRepository,
    required Account account,
  })  : _accountRepository = accountRepository,
        super(AccountDetailState(account: account));

  final AccountRepository _accountRepository;

  /// Refreshes the account data from the repository.
  Future<void> refresh() async {
    try {
      final updated =
          await _accountRepository.getAccount(state.account.id);
      emit(state.copyWith(account: updated));
    } on AccountException {
      // Keep current data if refresh fails.
    }
  }

  /// Reconciles the account to [balanceCents].
  Future<void> reconcile(int balanceCents) async {
    emit(state.copyWith(status: AccountDetailStatus.submitting));
    try {
      await _accountRepository.reconcileAccount(
        state.account.id,
        balanceCents,
      );
      final refreshed =
          await _accountRepository.getAccount(state.account.id);
      emit(
        state.copyWith(
          status: AccountDetailStatus.reconciled,
          account: refreshed,
        ),
      );
    } on AccountException catch (e) {
      emit(
        state.copyWith(
          status: AccountDetailStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
    // Reset status so future operations emit new states.
    emit(state.copyWith(status: AccountDetailStatus.idle, errorMessage: null));
  }
}
