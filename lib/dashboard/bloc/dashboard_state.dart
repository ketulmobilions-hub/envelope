part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, loaded, error }

enum DashboardError { loadFailed }

/// Summary of an envelope with its allocation for the current period.
final class EnvelopeSummary extends Equatable {
  const EnvelopeSummary({
    required this.envelope,
    required this.categoryGroupName,
    this.allocation,
  });

  final Envelope envelope;
  final String categoryGroupName;
  final EnvelopeAllocation? allocation;

  int get allocated => allocation?.allocatedAmount ?? 0;
  int get spent => allocation?.spentAmount ?? 0;
  int get available => allocated - spent + (allocation?.rolloverAmount ?? 0);
  bool get isOverspent => available < 0;

  @override
  List<Object?> get props => [envelope, categoryGroupName, allocation];
}

final class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.error,
    this.selectedPeriod,
    this.readyToAssign = 0,
    this.accounts = const [],
    this.envelopes = const [],
    this.categoryGroups = const [],
    this.allocations = const [],
    this.recentTransactions = const [],
  });

  final DashboardStatus status;
  final DashboardError? error;
  final BudgetPeriod? selectedPeriod;
  final int readyToAssign;
  final List<Account> accounts;
  final List<Envelope> envelopes;
  final List<CategoryGroup> categoryGroups;
  final List<EnvelopeAllocation> allocations;
  final List<Transaction> recentTransactions;

  /// Sum of non-archived account balances.
  int get totalBalance => accounts
      .where((a) => !a.isArchived)
      .fold(0, (sum, a) => sum + a.currentBalance);

  /// Envelope summaries paired with their allocations and group names.
  List<EnvelopeSummary> get envelopeSummaries {
    final groupMap = {
      for (final g in categoryGroups) g.id: g.name,
    };
    return envelopes
        .where((e) => !e.isArchived)
        .map((e) {
          final allocation = allocations
              .where((a) => a.envelopeId == e.id)
              .firstOrNull;
          return EnvelopeSummary(
            envelope: e,
            categoryGroupName: groupMap[e.categoryGroupId] ?? '',
            allocation: allocation,
          );
        })
        .toList();
  }

  DashboardState copyWith({
    DashboardStatus? status,
    Object? error = _sentinel,
    Object? selectedPeriod = _sentinel,
    int? readyToAssign,
    List<Account>? accounts,
    List<Envelope>? envelopes,
    List<CategoryGroup>? categoryGroups,
    List<EnvelopeAllocation>? allocations,
    List<Transaction>? recentTransactions,
  }) {
    return DashboardState(
      status: status ?? this.status,
      error: error == _sentinel ? this.error : error as DashboardError?,
      selectedPeriod: selectedPeriod == _sentinel
          ? this.selectedPeriod
          : selectedPeriod as BudgetPeriod?,
      readyToAssign: readyToAssign ?? this.readyToAssign,
      accounts: accounts ?? this.accounts,
      envelopes: envelopes ?? this.envelopes,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      allocations: allocations ?? this.allocations,
      recentTransactions: recentTransactions ?? this.recentTransactions,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
        status,
        error,
        selectedPeriod,
        readyToAssign,
        accounts,
        envelopes,
        categoryGroups,
        allocations,
        recentTransactions,
      ];
}
