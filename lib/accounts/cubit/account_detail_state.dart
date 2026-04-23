part of 'account_detail_cubit.dart';

enum AccountDetailStatus { idle, submitting, reconciled, failure }

final class AccountDetailState extends Equatable {
  const AccountDetailState({
    required this.account,
    this.debtAccount,
    this.status = AccountDetailStatus.idle,
    this.errorMessage,
  });

  final Account account;
  final DebtAccount? debtAccount;
  final AccountDetailStatus status;
  final String? errorMessage;

  AccountDetailState copyWith({
    Account? account,
    Object? debtAccount = _sentinel,
    AccountDetailStatus? status,
    Object? errorMessage = _sentinel,
  }) {
    return AccountDetailState(
      account: account ?? this.account,
      debtAccount: debtAccount == _sentinel
          ? this.debtAccount
          : debtAccount as DebtAccount?,
      status: status ?? this.status,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [account, debtAccount, status, errorMessage];
}
