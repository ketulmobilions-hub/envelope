part of 'account_form_cubit.dart';

enum AccountFormStatus { initial, submitting, success, failure }

final class AccountFormState extends Equatable {
  const AccountFormState({
    this.status = AccountFormStatus.initial,
    this.errorMessage,
    this.existingCreditLimitCents,
  });

  final AccountFormStatus status;
  final String? errorMessage;

  /// Populated after [AccountFormCubit.loadExistingCreditLimit] resolves.
  final int? existingCreditLimitCents;

  AccountFormState copyWith({
    AccountFormStatus? status,
    String? errorMessage,
    Object? existingCreditLimitCents = _sentinel,
  }) {
    return AccountFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      existingCreditLimitCents: existingCreditLimitCents == _sentinel
          ? this.existingCreditLimitCents
          : existingCreditLimitCents as int?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, errorMessage, existingCreditLimitCents];
}
