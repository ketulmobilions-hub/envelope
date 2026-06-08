part of 'transfer_form_cubit.dart';

enum TransferFormStatus { loading, loaded, submitting, success, failure }

final class TransferFormState extends Equatable {
  const TransferFormState({
    this.status = TransferFormStatus.loading,
    this.accounts = const [],
    this.errorMessage,
  });

  final TransferFormStatus status;
  final List<Account> accounts;
  final String? errorMessage;

  TransferFormState copyWith({
    TransferFormStatus? status,
    List<Account>? accounts,
    String? errorMessage,
  }) {
    return TransferFormState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accounts, errorMessage];
}
