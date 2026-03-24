part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to all dashboard data streams.
final class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

/// Pull latest data from all repositories.
final class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}

/// Internal event when the budget periods stream emits.
final class _PeriodsUpdated extends DashboardEvent {
  const _PeriodsUpdated(this.periods, this.generation);

  final List<BudgetPeriod> periods;
  final int generation;

  @override
  List<Object?> get props => [periods, generation];
}

/// Internal event when the accounts stream emits.
final class _AccountsUpdated extends DashboardEvent {
  const _AccountsUpdated(this.accounts, this.generation);

  final List<Account> accounts;
  final int generation;

  @override
  List<Object?> get props => [accounts, generation];
}

/// Internal event when the envelopes stream emits.
final class _EnvelopesUpdated extends DashboardEvent {
  const _EnvelopesUpdated(this.envelopes, this.generation);

  final List<Envelope> envelopes;
  final int generation;

  @override
  List<Object?> get props => [envelopes, generation];
}

/// Internal event when the category groups stream emits.
final class _CategoryGroupsUpdated extends DashboardEvent {
  const _CategoryGroupsUpdated(this.categoryGroups, this.generation);

  final List<CategoryGroup> categoryGroups;
  final int generation;

  @override
  List<Object?> get props => [categoryGroups, generation];
}

/// Internal event when the allocations stream emits for the selected period.
final class _AllocationsUpdated extends DashboardEvent {
  const _AllocationsUpdated(this.allocations, this.generation);

  final List<EnvelopeAllocation> allocations;
  final int generation;

  @override
  List<Object?> get props => [allocations, generation];
}

/// Internal event when the transactions stream emits.
final class _RecentTransactionsUpdated extends DashboardEvent {
  const _RecentTransactionsUpdated(this.transactions, this.generation);

  final List<Transaction> transactions;
  final int generation;

  @override
  List<Object?> get props => [transactions, generation];
}

/// Quick-allocate an amount to an envelope from the homepage.
final class QuickAllocationRequested extends DashboardEvent {
  const QuickAllocationRequested({
    required this.envelopeId,
    required this.amount,
  });

  final String envelopeId;
  final int amount;

  @override
  List<Object?> get props => [envelopeId, amount];
}

/// Internal event when any stream errors.
final class _DashboardStreamError extends DashboardEvent {
  const _DashboardStreamError();
}
