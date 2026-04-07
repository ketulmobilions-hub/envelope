part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to transactions for the given budget.
final class TransactionsStarted extends TransactionsEvent {
  const TransactionsStarted();
}

/// Internal event when the transactions stream emits new data.
final class _TransactionsUpdated extends TransactionsEvent {
  const _TransactionsUpdated(this.transactions);

  final List<Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

/// Internal event when the transactions stream errors.
final class _TransactionsStreamError extends TransactionsEvent {
  const _TransactionsStreamError();
}

/// Internal event when the accounts stream emits new data.
final class _AccountsUpdated extends TransactionsEvent {
  const _AccountsUpdated(this.accounts);

  final List<Account> accounts;

  @override
  List<Object?> get props => [accounts];
}

/// Internal event when the envelopes stream emits new data.
final class _EnvelopesUpdated extends TransactionsEvent {
  const _EnvelopesUpdated(this.envelopes);

  final List<Envelope> envelopes;

  @override
  List<Object?> get props => [envelopes];
}

/// Internal event when the split envelope IDs stream emits new data.
final class _SplitEnvelopeIdsUpdated extends TransactionsEvent {
  const _SplitEnvelopeIdsUpdated(this.splitEnvelopeIds);

  final Map<String, List<String>> splitEnvelopeIds;

  @override
  List<Object?> get props => [splitEnvelopeIds];
}

/// Pull latest transactions from the API.
final class TransactionsRefreshRequested extends TransactionsEvent {
  const TransactionsRefreshRequested();
}

/// Delete a transaction by its ID.
final class TransactionDeleted extends TransactionsEvent {
  const TransactionDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Re-create the last deleted transaction (undo).
final class TransactionUndoDeleteRequested extends TransactionsEvent {
  const TransactionUndoDeleteRequested();
}

/// Update the active filter.
final class TransactionsFilterChanged extends TransactionsEvent {
  const TransactionsFilterChanged(this.filter);

  final TransactionsFilter filter;

  @override
  List<Object?> get props => [filter];
}
