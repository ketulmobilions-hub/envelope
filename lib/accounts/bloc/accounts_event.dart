part of 'accounts_bloc.dart';

sealed class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to accounts for the given budget.
final class AccountsStarted extends AccountsEvent {
  const AccountsStarted();
}

/// Internal event when the accounts stream emits new data.
final class _AccountsUpdated extends AccountsEvent {
  const _AccountsUpdated(this.accounts);

  final List<Account> accounts;

  @override
  List<Object?> get props => [accounts];
}

/// Internal event when the accounts stream errors.
final class _AccountsStreamError extends AccountsEvent {
  const _AccountsStreamError();
}

/// Pull latest accounts from the API.
final class AccountsRefreshRequested extends AccountsEvent {
  const AccountsRefreshRequested();
}

/// Archive or unarchive an account.
final class AccountArchiveToggled extends AccountsEvent {
  const AccountArchiveToggled(this.account);

  final Account account;

  @override
  List<Object?> get props => [account];
}

/// Delete an account permanently.
final class AccountDeleted extends AccountsEvent {
  const AccountDeleted(this.accountId);

  final String accountId;

  @override
  List<Object?> get props => [accountId];
}
