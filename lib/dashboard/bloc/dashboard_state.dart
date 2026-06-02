part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, loaded, error, budgetDeleted }

enum DashboardError { loadFailed, allocationFailed }

/// Summary of an envelope with its global allocation and derived spent.
final class EnvelopeSummary extends Equatable {
  const EnvelopeSummary({
    required this.envelope,
    required this.categoryGroupName,
    this.allocation,
    this.spentFromTransactions = 0,
  });

  final Envelope envelope;
  final String categoryGroupName;
  final EnvelopeAllocation? allocation;

  /// Spent amount computed from local transactions.
  final int spentFromTransactions;

  int get allocated => allocation?.allocatedAmount ?? 0;

  /// Total funds budgeted for this envelope (= allocated under the global
  /// model, with no rollover layer).
  int get budgeted => allocated;

  int get spent => spentFromTransactions;

  int get available => allocated - spent;
  bool get isOverspent => available < 0;

  @override
  List<Object?> get props => [
    envelope,
    categoryGroupName,
    allocation,
    spentFromTransactions,
  ];
}

final class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.error,
    this.readyToAssign = 0,
    this.accounts = const [],
    this.envelopes = const [],
    this.categoryGroups = const [],
    this.allocations = const [],
    this.recentTransactions = const [],
    this.transactions = const [],
    this.spentByEnvelope = const {},
    this.ccCreditLimits = const {},
    this.hasRemoteUpdate = false,
  });

  final DashboardStatus status;
  final DashboardError? error;
  final int readyToAssign;
  final List<Account> accounts;
  final List<Envelope> envelopes;
  final List<CategoryGroup> categoryGroups;
  final List<EnvelopeAllocation> allocations;
  final List<Transaction> recentTransactions;

  /// All transactions for the budget (used for recent-transactions display).
  final List<Transaction> transactions;

  /// Per-envelope expense total in budget base currency, including split
  /// contributions. Sourced from the same DAO stream the budget page uses so
  /// the two views agree on which envelopes are overspent.
  final Map<String, int> spentByEnvelope;

  /// Maps CC account ID → credit limit (in cents). Only populated for CC
  /// accounts that have a credit limit set on their debt account record.
  final Map<String, int?> ccCreditLimits;

  final bool hasRemoteUpdate;

  /// Sum of non-archived account balances, converted to the budget's base
  /// currency via each account's `displayFxRate`.
  int get totalBalance => accounts.where((a) => !a.isArchived).fold(
    0,
    (sum, a) => sum + (a.currentBalance * a.displayFxRate).round(),
  );

  /// Envelope summaries paired with their allocations and group names. The
  /// spent total reads from the canonical per-budget map so split-mode
  /// contributions are folded in by the DAO, not lost in a per-row filter.
  List<EnvelopeSummary> get envelopeSummaries {
    final groupMap = {for (final g in categoryGroups) g.id: g.name};

    return envelopes
        .where((e) {
          if (e.isArchived) return false;
          if (e.linkedAccountId != null) {
            final linked = accounts
                .where((a) => a.id == e.linkedAccountId)
                .firstOrNull;
            if (linked != null && linked.isArchived) return false;
          }
          return true;
        })
        .map((e) {
          final allocation = allocations
              .where((a) => a.envelopeId == e.id)
              .firstOrNull;
          return EnvelopeSummary(
            envelope: e,
            categoryGroupName: groupMap[e.categoryGroupId] ?? '',
            allocation: allocation,
            spentFromTransactions: spentByEnvelope[e.id] ?? 0,
          );
        })
        .toList();
  }

  DashboardState copyWith({
    DashboardStatus? status,
    Object? error = _sentinel,
    int? readyToAssign,
    List<Account>? accounts,
    List<Envelope>? envelopes,
    List<CategoryGroup>? categoryGroups,
    List<EnvelopeAllocation>? allocations,
    List<Transaction>? recentTransactions,
    List<Transaction>? transactions,
    Map<String, int>? spentByEnvelope,
    Map<String, int?>? ccCreditLimits,
    bool? hasRemoteUpdate,
  }) {
    return DashboardState(
      status: status ?? this.status,
      error: error == _sentinel ? this.error : error as DashboardError?,
      readyToAssign: readyToAssign ?? this.readyToAssign,
      accounts: accounts ?? this.accounts,
      envelopes: envelopes ?? this.envelopes,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      allocations: allocations ?? this.allocations,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      transactions: transactions ?? this.transactions,
      spentByEnvelope: spentByEnvelope ?? this.spentByEnvelope,
      ccCreditLimits: ccCreditLimits ?? this.ccCreditLimits,
      hasRemoteUpdate: hasRemoteUpdate ?? this.hasRemoteUpdate,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
    status,
    error,
    readyToAssign,
    accounts,
    envelopes,
    categoryGroups,
    allocations,
    recentTransactions,
    transactions,
    spentByEnvelope,
    ccCreditLimits,
    hasRemoteUpdate,
  ];
}
