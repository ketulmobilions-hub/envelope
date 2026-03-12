part of 'accounts_bloc.dart';

enum AccountsStatus { initial, loading, loaded, error }

/// Error codes for account operations, translated in the UI layer.
enum AccountsError { loadFailed, updateFailed, deleteFailed }

final class AccountsState extends Equatable {
  const AccountsState({
    this.status = AccountsStatus.initial,
    this.accounts = const [],
    this.error,
  });

  final AccountsStatus status;
  final List<Account> accounts;
  final AccountsError? error;

  /// Active (non-archived) accounts grouped by type.
  Map<String, List<Account>> get activeAccountsByType {
    final active = accounts.where((a) => !a.isArchived).toList();
    final grouped = <String, List<Account>>{};
    for (final account in active) {
      grouped.putIfAbsent(account.type, () => []).add(account);
    }
    return grouped;
  }

  /// Archived accounts.
  List<Account> get archivedAccounts =>
      accounts.where((a) => a.isArchived).toList();

  /// Total balance across all active accounts.
  int get totalBalance => accounts
      .where((a) => !a.isArchived)
      .fold(0, (sum, a) => sum + a.currentBalance);

  AccountsState copyWith({
    AccountsStatus? status,
    List<Account>? accounts,
    Object? error = _sentinel,
  }) {
    return AccountsState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      error: error == _sentinel ? this.error : error as AccountsError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, accounts, error];
}
