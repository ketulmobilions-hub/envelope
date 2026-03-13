part of 'envelopes_bloc.dart';

sealed class EnvelopesEvent extends Equatable {
  const EnvelopesEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to category groups and envelopes for the given budget.
final class EnvelopesStarted extends EnvelopesEvent {
  const EnvelopesStarted();
}

/// Internal event when the category groups stream emits new data.
/// [generation] matches the value in [EnvelopesBloc._generation] at subscribe
/// time so stale events from a prior subscription are discarded.
final class _CategoryGroupsUpdated extends EnvelopesEvent {
  const _CategoryGroupsUpdated(this.categoryGroups, this.generation);

  final List<CategoryGroup> categoryGroups;
  final int generation;

  @override
  List<Object?> get props => [categoryGroups, generation];
}

/// Internal event when the envelopes stream emits new data.
final class _EnvelopesUpdated extends EnvelopesEvent {
  const _EnvelopesUpdated(this.envelopes, this.generation);

  final List<Envelope> envelopes;
  final int generation;

  @override
  List<Object?> get props => [envelopes, generation];
}

/// Internal event when either stream errors.
final class _EnvelopesStreamError extends EnvelopesEvent {
  const _EnvelopesStreamError();
}

/// Pull latest data from the API.
final class EnvelopesRefreshRequested extends EnvelopesEvent {
  const EnvelopesRefreshRequested();
}

/// Archive or unarchive a category group.
final class CategoryGroupArchiveToggled extends EnvelopesEvent {
  const CategoryGroupArchiveToggled(this.categoryGroup);

  final CategoryGroup categoryGroup;

  @override
  List<Object?> get props => [categoryGroup];
}

/// Delete a category group permanently.
final class CategoryGroupDeleted extends EnvelopesEvent {
  const CategoryGroupDeleted(this.categoryGroupId);

  final String categoryGroupId;

  @override
  List<Object?> get props => [categoryGroupId];
}

/// Archive or unarchive an envelope.
final class EnvelopeArchiveToggled extends EnvelopesEvent {
  const EnvelopeArchiveToggled(this.envelope);

  final Envelope envelope;

  @override
  List<Object?> get props => [envelope];
}

/// Delete an envelope permanently.
final class EnvelopeDeleted extends EnvelopesEvent {
  const EnvelopeDeleted(this.envelopeId);

  final String envelopeId;

  @override
  List<Object?> get props => [envelopeId];
}

/// Reorder category groups with the given ordered list of IDs.
final class CategoryGroupsReordered extends EnvelopesEvent {
  const CategoryGroupsReordered(this.orderedIds);

  final List<String> orderedIds;

  @override
  List<Object?> get props => [orderedIds];
}

/// Reorder envelopes within a group with the given ordered list of IDs.
final class EnvelopesReordered extends EnvelopesEvent {
  const EnvelopesReordered(this.orderedIds);

  final List<String> orderedIds;

  @override
  List<Object?> get props => [orderedIds];
}
