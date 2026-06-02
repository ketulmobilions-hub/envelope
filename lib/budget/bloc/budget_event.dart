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

/// Internal event when the allocations stream emits.
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

/// Internal event when transactions stream emits — triggers spent recompute.
final class _TransactionsChanged extends BudgetEvent {
  const _TransactionsChanged(this.generation);

  final int generation;

  @override
  List<Object?> get props => [generation];
}

/// Internal event when the per-envelope spent map emits.
final class _SpentByEnvelopeUpdated extends BudgetEvent {
  const _SpentByEnvelopeUpdated(this.spentByEnvelope, this.generation);

  final Map<String, int> spentByEnvelope;
  final int generation;

  @override
  List<Object?> get props => [spentByEnvelope, generation];
}

/// Internal event when the templates stream emits.
final class _TemplatesUpdated extends BudgetEvent {
  const _TemplatesUpdated(this.templates, this.generation);

  final List<AllocationTemplate> templates;
  final int generation;

  @override
  List<Object?> get props => [templates, generation];
}

/// Internal event when the goals stream emits.
final class _GoalsUpdated extends BudgetEvent {
  const _GoalsUpdated(this.goals, this.generation);

  final List<Goal> goals;
  final int generation;

  @override
  List<Object?> get props => [goals, generation];
}

/// Internal event when the Ready-to-Assign stream emits.
final class _ReadyToAssignUpdated extends BudgetEvent {
  const _ReadyToAssignUpdated(this.readyToAssign, this.generation);

  final int readyToAssign;
  final int generation;

  @override
  List<Object?> get props => [readyToAssign, generation];
}

/// Internal event when any stream errors.
final class _BudgetStreamError extends BudgetEvent {
  const _BudgetStreamError();
}

/// Pull latest data from the API.
final class BudgetRefreshRequested extends BudgetEvent {
  const BudgetRefreshRequested();
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

/// Apply an allocation template to the budget.
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
