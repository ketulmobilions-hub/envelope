part of 'account_form_cubit.dart';

enum AccountFormStatus { initial, submitting, success, failure }

final class AccountFormState extends Equatable {
  const AccountFormState({
    this.status = AccountFormStatus.initial,
    this.errorMessage,
  });

  final AccountFormStatus status;
  final String? errorMessage;

  AccountFormState copyWith({
    AccountFormStatus? status,
    String? errorMessage,
  }) {
    return AccountFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
