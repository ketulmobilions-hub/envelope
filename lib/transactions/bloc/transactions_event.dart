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
