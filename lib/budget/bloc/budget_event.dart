part of 'budget_bloc.dart';

sealed class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to all budget data streams.
final class BudgetStarted extends BudgetEvent {
  const BudgetStarted();
}

/// Internal event when the budget row stream emits. Used to refresh derived
/// values (RTA) when `openingBalance` / `openingDate` changes — e.g. after
/// [BudgetRepository.autoCreatePreviousPeriod] shifts the seed-cash anchor.
final class _BudgetUpdated extends BudgetEvent {
  const _BudgetUpdated(this.budget, this.generation);

  final Budget budget;
  final int generation;

  @override
  List<Object?> get props => [budget, generation];
}

/// Internal event when the budget periods stream emits.
final class _PeriodsUpdated extends BudgetEvent {
  const _PeriodsUpdated(this.periods, this.generation);

  final List<BudgetPeriod> periods;
  final int generation;

  @override
  List<Object?> get props => [periods, generation];
}

/// Internal event when the allocations stream emits for the selected period.
final class _AllocationsUpdated extends BudgetEvent {
  const _AllocationsUpdated(this.allocations, this.generation);

  final List<EnvelopeAllocation> allocations;
  final int generation;

  @override
  List<Object?> get props => [allocations, generation];
}

/// Internal event when the category groups stream emits.
final class _CategoryGroupsUpdated extends BudgetEvent {
  const _CategoryGroupsUpdated(this.categoryGroups, this.generation);

  final List<CategoryGroup> categoryGroups;
  final int generation;

  @override
  List<Object?> get props => [categoryGroups, generation];
}

/// Internal event when the envelopes stream emits.
final class _EnvelopesUpdated extends BudgetEvent {
  const _EnvelopesUpdated(this.envelopes, this.generation);

  final List<Envelope> envelopes;
  final int generation;

  @override
  List<Object?> get props => [envelopes, generation];
}

/// Internal event when the transactions stream emits. Triggers a recompute of
/// the derived CC Payment envelope availability, which depends on credit-card
/// charge/payment history rather than stored allocations.
final class _TransactionsChanged extends BudgetEvent {
  const _TransactionsChanged(this.generation);

  final int generation;

  @override
  List<Object?> get props => [generation];
}

/// Internal event when the templates stream emits.
final class _TemplatesUpdated extends BudgetEvent {
  const _TemplatesUpdated(this.templates, this.generation);

  final List<AllocationTemplate> templates;
  final int generation;

  @override
  List<Object?> get props => [templates, generation];
}

/// Internal event when the goals stream emits. Drives the "needed this month"
/// chip on envelope rows by exposing each envelope's linked goals.
final class _GoalsUpdated extends BudgetEvent {
  const _GoalsUpdated(this.goals, this.generation);

  final List<Goal> goals;
  final int generation;

  @override
  List<Object?> get props => [goals, generation];
}

/// Internal event when any stream errors.
final class _BudgetStreamError extends BudgetEvent {
  const _BudgetStreamError();
}

/// Pull latest data from the API.
final class BudgetRefreshRequested extends BudgetEvent {
  const BudgetRefreshRequested();
}

/// Navigate to the previous budget period.
final class BudgetPreviousPeriodRequested extends BudgetEvent {
  const BudgetPreviousPeriodRequested();
}

/// Navigate to the next budget period.
final class BudgetNextPeriodRequested extends BudgetEvent {
  const BudgetNextPeriodRequested();
}

/// User typed a new allocation amount for an envelope (local only, unsaved).
final class AllocationAmountChanged extends BudgetEvent {
  const AllocationAmountChanged({
    required this.envelopeId,
    required this.amount,
  });

  final String envelopeId;
  final int amount;

  @override
  List<Object?> get props => [envelopeId, amount];
}

/// Persist all locally-edited allocation amounts to the server.
final class AllocationsSaveRequested extends BudgetEvent {
  const AllocationsSaveRequested();
}

/// Transfer funds between two envelope allocations.
final class EnvelopeTransferRequested extends BudgetEvent {
  const EnvelopeTransferRequested({
    required this.fromAllocationId,
    required this.toAllocationId,
    required this.amount,
  });

  final String fromAllocationId;
  final String toAllocationId;
  final int amount;

  @override
  List<Object?> get props => [fromAllocationId, toAllocationId, amount];
}

/// Apply an allocation template to the selected period.
final class AllocationTemplateApplied extends BudgetEvent {
  const AllocationTemplateApplied({
    required this.templateId,
    required this.totalAmount,
  });

  final String templateId;
  final int totalAmount;

  @override
  List<Object?> get props => [templateId, totalAmount];
}

/// Create a new allocation template from the given items.
final class AllocationTemplateCreated extends BudgetEvent {
  const AllocationTemplateCreated({
    required this.name,
    required this.items,
  });

  final String name;
  final List<AllocationTemplateItem> items;

  @override
  List<Object?> get props => [name, items];
}

/// Update an existing allocation template.
final class AllocationTemplateUpdated extends BudgetEvent {
  const AllocationTemplateUpdated(this.template);

  final AllocationTemplate template;

  @override
  List<Object?> get props => [template];
}

/// Delete an allocation template.
final class AllocationTemplateDeleted extends BudgetEvent {
  const AllocationTemplateDeleted(this.templateId);

  final String templateId;

  @override
  List<Object?> get props => [templateId];
}

/// Copy allocations from the previous period into the selected period.
final class BudgetDuplicateFromPreviousPeriodRequested extends BudgetEvent {
  const BudgetDuplicateFromPreviousPeriodRequested();
}

/// Restore the pending draft allocation amounts from persistent storage.
final class AllocationDraftRestoreRequested extends BudgetEvent {
  const AllocationDraftRestoreRequested();
}

/// Discard the pending draft without restoring it.
final class AllocationDraftDiscardRequested extends BudgetEvent {
  const AllocationDraftDiscardRequested();
}
