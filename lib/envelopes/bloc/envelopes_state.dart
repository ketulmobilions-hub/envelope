part of 'envelopes_bloc.dart';

enum EnvelopesStatus { initial, loading, loaded, error }

/// Error codes for envelope operations, translated in the UI layer.
enum EnvelopesError { loadFailed, updateFailed, deleteFailed, reorderFailed }

final class EnvelopesState extends Equatable {
  const EnvelopesState({
    this.status = EnvelopesStatus.initial,
    this.categoryGroups = const [],
    this.envelopes = const [],
    this.error,
  });

  final EnvelopesStatus status;
  final List<CategoryGroup> categoryGroups;
  final List<Envelope> envelopes;
  final EnvelopesError? error;

  /// Active (non-archived) category groups paired with their active envelopes,
  /// both sorted by sortOrder.
  List<(CategoryGroup, List<Envelope>)> get activeGroupsWithEnvelopes {
    final activeGroups = categoryGroups
        .where((g) => !g.isArchived)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return activeGroups.map((group) {
      final groupEnvelopes = envelopes
          .where((e) => e.categoryGroupId == group.id && !e.isArchived)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return (group, groupEnvelopes);
    }).toList();
  }

  /// Archived category groups.
  List<CategoryGroup> get archivedGroups =>
      categoryGroups.where((g) => g.isArchived).toList();

  /// All archived envelopes.
  List<Envelope> get archivedEnvelopes =>
      envelopes.where((e) => e.isArchived).toList();

  EnvelopesState copyWith({
    EnvelopesStatus? status,
    List<CategoryGroup>? categoryGroups,
    List<Envelope>? envelopes,
    Object? error = _sentinel,
  }) {
    return EnvelopesState(
      status: status ?? this.status,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      envelopes: envelopes ?? this.envelopes,
      error: error == _sentinel ? this.error : error as EnvelopesError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, categoryGroups, envelopes, error];
}
