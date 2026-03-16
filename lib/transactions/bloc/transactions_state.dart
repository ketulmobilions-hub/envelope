part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, loading, loaded, error }

/// Error codes for transaction operations, translated in the UI layer.
enum TransactionsError { loadFailed, deleteFailed, undoFailed }

/// Filter criteria for transactions.
final class TransactionsFilter extends Equatable {
  const TransactionsFilter({
    this.accountId,
    this.envelopeId,
    this.type,
    this.startDate,
    this.endDate,
    this.tagIds = const [],
  });

  final String? accountId;
  final String? envelopeId;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tagIds;

  /// Whether any filter is active.
  bool get isActive =>
      accountId != null ||
      envelopeId != null ||
      type != null ||
      startDate != null ||
      endDate != null ||
      tagIds.isNotEmpty;

  TransactionsFilter copyWith({
    Object? accountId = _sentinel,
    Object? envelopeId = _sentinel,
    Object? type = _sentinel,
    Object? startDate = _sentinel,
    Object? endDate = _sentinel,
    List<String>? tagIds,
  }) {
    return TransactionsFilter(
      accountId:
          accountId == _sentinel ? this.accountId : accountId as String?,
      envelopeId:
          envelopeId == _sentinel ? this.envelopeId : envelopeId as String?,
      type: type == _sentinel ? this.type : type as String?,
      startDate:
          startDate == _sentinel ? this.startDate : startDate as DateTime?,
      endDate: endDate == _sentinel ? this.endDate : endDate as DateTime?,
      tagIds: tagIds ?? this.tagIds,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props =>
      [accountId, envelopeId, type, startDate, endDate, tagIds];
}

final class TransactionsState extends Equatable {
  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.filter = const TransactionsFilter(),
    this.error,
  });

  final TransactionsStatus status;
  final List<Transaction> transactions;
  final TransactionsFilter filter;
  final TransactionsError? error;

  /// Transactions after applying the current filter.
  List<Transaction> get filteredTransactions {
    var result = List<Transaction>.of(transactions);
    final f = filter;

    if (f.accountId != null) {
      result = result.where((t) => t.accountId == f.accountId).toList();
    }
    if (f.envelopeId != null) {
      result = result.where((t) => t.envelopeId == f.envelopeId).toList();
    }
    if (f.type != null) {
      result = result.where((t) => t.type == f.type).toList();
    }
    if (f.startDate != null) {
      result = result.where((t) => !t.date.isBefore(f.startDate!)).toList();
    }
    if (f.endDate != null) {
      result = result.where((t) => !t.date.isAfter(f.endDate!)).toList();
    }
    // Tag filtering would require async lookup; deferred to UI layer.
    return result;
  }

  /// Filtered transactions grouped by date (descending).
  Map<DateTime, List<Transaction>> get transactionsByDate {
    final filtered = filteredTransactions
      ..sort((a, b) => b.date.compareTo(a.date));

    final grouped = <DateTime, List<Transaction>>{};
    for (final txn in filtered) {
      final dateOnly = DateTime(txn.date.year, txn.date.month, txn.date.day);
      grouped.putIfAbsent(dateOnly, () => []).add(txn);
    }
    return grouped;
  }

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactions,
    TransactionsFilter? filter,
    Object? error = _sentinel,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      error: error == _sentinel ? this.error : error as TransactionsError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, transactions, filter, error];
}
