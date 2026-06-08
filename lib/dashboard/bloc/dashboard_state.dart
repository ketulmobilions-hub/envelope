part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, loaded, error, budgetDeleted }

enum DashboardError { loadFailed, allocationFailed }

/// Summary of an envelope with its allocation for the current period.
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

  /// Spent amount computed from local transactions (used as fallback when
  /// no allocation record exists yet — e.g. a never-allocated envelope).
  final int spentFromTransactions;

  int get allocated => allocation?.allocatedAmount ?? 0;

  int get rollover => allocation?.rolloverAmount ?? 0;

  /// Total funds budgeted for this envelope this period — fresh allocation
  /// plus any rolled-over balance from prior periods. Use this as the "of N"
  /// denominator in display, not [allocated] alone, otherwise pure-rollover
  /// envelopes (allocated=0) read as "X of 0".
  int get budgeted => allocated + rollover;

  int get spent => allocation?.spentAmount ?? spentFromTransactions;

  int get available => allocated - spent + rollover;
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
    this.selectedPeriod,
    this.periods = const [],
    this.readyToAssign = 0,
    this.accounts = const [],
    this.envelopes = const [],
    this.categoryGroups = const [],
    this.allocations = const [],
    this.recentTransactions = const [],
    this.transactions = const [],
    this.ccCreditLimits = const {},
    this.hasRemoteUpdate = false,
  });

  final DashboardStatus status;
  final DashboardError? error;
  final BudgetPeriod? selectedPeriod;

  /// All budget periods (unsorted as received). Use [sortedPeriods] for
  /// chronological order and the period-navigation getters.
  final List<BudgetPeriod> periods;
  final int readyToAssign;

  /// Periods sorted oldest-first, for previous/next navigation.
  List<BudgetPeriod> get sortedPeriods =>
      [...periods]..sort((a, b) => a.startDate.compareTo(b.startDate));

  int get _selectedIndex =>
      sortedPeriods.indexWhere((p) => p.id == selectedPeriod?.id);

  /// Whether an older period exists to navigate back to.
  bool get hasPreviousPeriod => _selectedIndex > 0;

  /// Whether a newer period exists to navigate forward to.
  bool get hasNextPeriod {
    final idx = _selectedIndex;
    return idx >= 0 && idx < sortedPeriods.length - 1;
  }
  final List<Account> accounts;
  final List<Envelope> envelopes;
  final List<CategoryGroup> categoryGroups;
  final List<EnvelopeAllocation> allocations;
  final List<Transaction> recentTransactions;

  /// All transactions for the budget (used to compute per-envelope spending
  /// as a fallback when no allocation record exists yet).
  final List<Transaction> transactions;

  /// Maps CC account ID → credit limit (in cents). Only populated for CC
  /// accounts that have a credit limit set on their debt account record.
  final Map<String, int?> ccCreditLimits;

  final bool hasRemoteUpdate;

  /// Sum of non-archived account balances, converted to the budget's base
  /// currency via each account's `displayFxRate`. For accounts whose currency
  /// matches the budget base, the rate defaults to 1.0 and conversion is a
  /// no-op.
  int get totalBalance => accounts.where((a) => !a.isArchived).fold(
    0,
    (sum, a) => sum + (a.currentBalance * a.displayFxRate).round(),
  );

  /// Total money that left the budget via untagged on→off-budget transfers in
  /// the selected period. Untagged (envelopeId == null) means the transfer was
  /// not funded through an envelope allocation — if it were, that allocation
  /// already reduced RTA at budget time and we must not subtract again.
  int get totalOffBudgetTransfersOut {
    final period = selectedPeriod;
    if (period == null) return 0;

    final accountMap = {for (final a in accounts) a.id: a};

    // Map transferPairId → list of accountIds for transfers in this period,
    // so we can identify the destination account of each outgoing leg.
    final pairAccounts = <String, List<String>>{};
    for (final t in transactions) {
      if (t.type != 'transfer' || t.transferPairId == null) { continue; }
      if (t.date.isBefore(period.startDate) ||
          t.date.isAfter(period.endDate)) { continue; }
      (pairAccounts[t.transferPairId!] ??= []).add(t.accountId);
    }

    var total = 0;
    for (final t in transactions) {
      if (t.type != 'transfer' || t.amount >= 0) { continue; }
      if (t.transferPairId == null || t.envelopeId != null) { continue; }
      if (t.date.isBefore(period.startDate) ||
          t.date.isAfter(period.endDate)) { continue; }

      final fromAccount = accountMap[t.accountId];
      if (fromAccount == null || !fromAccount.isOnBudget) continue;

      final legs = pairAccounts[t.transferPairId!] ?? [];
      final toAccountId = legs.firstWhere(
        (id) => id != t.accountId,
        orElse: () => '',
      );
      if (toAccountId.isEmpty) continue;

      final toAccount = accountMap[toAccountId];
      if (toAccount != null && !toAccount.isOnBudget) {
        total += t.amount.abs();
      }
    }
    return total;
  }

  /// RTA adjusted for untagged on→off-budget transfers. Use this everywhere
  /// RTA is displayed or used for allocation guards, not [readyToAssign] alone.
  int get adjustedReadyToAssign => readyToAssign - totalOffBudgetTransfersOut;

  /// Sum of allocated amounts across visible envelopes for the selected
  /// period. Excludes CC Payment envelopes (linkedAccountId != null) to avoid
  /// double-counting: the spend was already recorded in the original category
  /// envelope when the CC was charged.
  int get totalAllocated => envelopeSummaries
      .where((s) => s.envelope.linkedAccountId == null)
      .fold(0, (sum, s) => sum + s.allocated);

  /// Sum of spent amounts across visible envelopes for the selected period.
  /// Excludes CC Payment envelopes for the same reason as [totalAllocated].
  int get totalSpent => envelopeSummaries
      .where((s) => s.envelope.linkedAccountId == null)
      .fold(0, (sum, s) => sum + s.spent);

  /// Envelope summaries paired with their allocations and group names.
  List<EnvelopeSummary> get envelopeSummaries {
    final groupMap = {
      for (final g in categoryGroups) g.id: g.name,
    };

    // Compute per-envelope spending from local transactions for the current
    // period. Used as a fallback when no EnvelopeAllocation record exists yet
    // (e.g. expense added to a never-allocated envelope before the server-side
    // trigger has had a chance to create the allocation row).
    final period = selectedPeriod;
    final spentMap = <String, int>{};
    if (period != null) {
      for (final t in transactions) {
        if (t.envelopeId == null ||
            t.date.isBefore(period.startDate) ||
            t.date.isAfter(period.endDate)) {
          continue;
        }
        if (t.type == 'expense') {
          spentMap[t.envelopeId!] = (spentMap[t.envelopeId!] ?? 0) + t.amount;
        } else if (t.type == 'transfer' && t.amount < 0) {
          // Categorized transfer OUT to an off-budget account counts as spend
          // (outgoing leg amount is negative, so subtract to add).
          spentMap[t.envelopeId!] = (spentMap[t.envelopeId!] ?? 0) - t.amount;
        }
      }
    }

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
            spentFromTransactions: spentMap[e.id] ?? 0,
          );
        })
        .toList();
  }

  DashboardState copyWith({
    DashboardStatus? status,
    Object? error = _sentinel,
    Object? selectedPeriod = _sentinel,
    List<BudgetPeriod>? periods,
    int? readyToAssign,
    List<Account>? accounts,
    List<Envelope>? envelopes,
    List<CategoryGroup>? categoryGroups,
    List<EnvelopeAllocation>? allocations,
    List<Transaction>? recentTransactions,
    List<Transaction>? transactions,
    Map<String, int?>? ccCreditLimits,
    bool? hasRemoteUpdate,
  }) {
    return DashboardState(
      status: status ?? this.status,
      error: error == _sentinel ? this.error : error as DashboardError?,
      selectedPeriod: selectedPeriod == _sentinel
          ? this.selectedPeriod
          : selectedPeriod as BudgetPeriod?,
      periods: periods ?? this.periods,
      readyToAssign: readyToAssign ?? this.readyToAssign,
      accounts: accounts ?? this.accounts,
      envelopes: envelopes ?? this.envelopes,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      allocations: allocations ?? this.allocations,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      transactions: transactions ?? this.transactions,
      ccCreditLimits: ccCreditLimits ?? this.ccCreditLimits,
      hasRemoteUpdate: hasRemoteUpdate ?? this.hasRemoteUpdate,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
    status,
    error,
    selectedPeriod,
    periods,
    readyToAssign,
    accounts,
    envelopes,
    categoryGroups,
    allocations,
    recentTransactions,
    transactions,
    ccCreditLimits,
    hasRemoteUpdate,
  ];
}
