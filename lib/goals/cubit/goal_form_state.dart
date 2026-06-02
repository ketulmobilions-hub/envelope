part of 'goal_form_cubit.dart';

enum GoalFormStatus { initial, submitting, success, failure }

const Object _unset = Object();

final class GoalFormState extends Equatable {
  const GoalFormState({
    this.status = GoalFormStatus.initial,
    this.errorMessage,
    this.envelopeId,
    this.accountId,
    this.envelopes = const [],
    this.accounts = const [],
    this.envelopesLoading = true,
    this.accountsLoading = true,
  });

  final GoalFormStatus status;
  final String? errorMessage;
  final String? envelopeId;
  final String? accountId;
  final List<Envelope> envelopes;
  final List<Account> accounts;
  final bool envelopesLoading;
  final bool accountsLoading;

  GoalFormState copyWith({
    GoalFormStatus? status,
    String? errorMessage,
    Object? envelopeId = _unset,
    Object? accountId = _unset,
    List<Envelope>? envelopes,
    List<Account>? accounts,
    bool? envelopesLoading,
    bool? accountsLoading,
  }) {
    return GoalFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      envelopeId: identical(envelopeId, _unset)
          ? this.envelopeId
          : envelopeId as String?,
      accountId: identical(accountId, _unset)
          ? this.accountId
          : accountId as String?,
      envelopes: envelopes ?? this.envelopes,
      accounts: accounts ?? this.accounts,
      envelopesLoading: envelopesLoading ?? this.envelopesLoading,
      accountsLoading: accountsLoading ?? this.accountsLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    envelopeId,
    accountId,
    envelopes,
    accounts,
    envelopesLoading,
    accountsLoading,
  ];
}
