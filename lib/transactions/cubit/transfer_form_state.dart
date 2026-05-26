part of 'transfer_form_cubit.dart';

enum TransferFormStatus { loading, loaded, submitting, success, failure }

final class TransferFormState extends Equatable {
  const TransferFormState({
    this.status = TransferFormStatus.loading,
    this.accounts = const [],
    this.envelopes = const [],
    this.errorMessage,
  });

  final TransferFormStatus status;
  final List<Account> accounts;

  /// Envelopes available to fund a transfer to an off-budget account.
  final List<Envelope> envelopes;
  final String? errorMessage;

  TransferFormState copyWith({
    TransferFormStatus? status,
    List<Account>? accounts,
    List<Envelope>? envelopes,
    String? errorMessage,
  }) {
    return TransferFormState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      envelopes: envelopes ?? this.envelopes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accounts, envelopes, errorMessage];
}
