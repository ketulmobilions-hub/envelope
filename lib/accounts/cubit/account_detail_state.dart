part of 'account_detail_cubit.dart';

enum AccountDetailStatus { idle, submitting, reconciled, failure }

final class AccountDetailState extends Equatable {
  const AccountDetailState({
    required this.account,
    this.status = AccountDetailStatus.idle,
    this.errorMessage,
  });

  final Account account;
  final AccountDetailStatus status;
  final String? errorMessage;

  AccountDetailState copyWith({
    Account? account,
    AccountDetailStatus? status,
    Object? errorMessage = _sentinel,
  }) {
    return AccountDetailState(
      account: account ?? this.account,
      status: status ?? this.status,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [account, status, errorMessage];
}
