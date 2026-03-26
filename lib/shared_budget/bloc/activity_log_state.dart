part of 'activity_log_bloc.dart';

enum ActivityLogStatus { initial, loading, loaded, error }

enum ActivityLogError { loadFailed }

final class ActivityLogState extends Equatable {
  const ActivityLogState({
    this.status = ActivityLogStatus.initial,
    this.entries = const [],
    this.error,
    this.filterByUserId,
    this.filterByAction,
  });

  final ActivityLogStatus status;
  final List<ActivityLogEntry> entries;
  final ActivityLogError? error;
  final String? filterByUserId;
  final String? filterByAction;

  /// Entries filtered by the current filter settings.
  List<ActivityLogEntry> get filteredEntries {
    var result = entries;
    if (filterByUserId != null) {
      result = result.where((e) => e.userId == filterByUserId).toList();
    }
    if (filterByAction != null) {
      result = result.where((e) => e.action == filterByAction).toList();
    }
    return result;
  }

  /// Unique user IDs across all entries (for filter dropdown).
  List<String> get uniqueUserIds =>
      entries.map((e) => e.userId).toSet().toList()..sort();

  /// Unique action types across all entries (for filter dropdown).
  List<String> get uniqueActions =>
      entries.map((e) => e.action).toSet().toList()..sort();

  ActivityLogState copyWith({
    ActivityLogStatus? status,
    List<ActivityLogEntry>? entries,
    Object? error = _sentinel,
    Object? filterByUserId = _sentinel,
    Object? filterByAction = _sentinel,
  }) {
    return ActivityLogState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      error: error == _sentinel
          ? this.error
          : error as ActivityLogError?,
      filterByUserId: filterByUserId == _sentinel
          ? this.filterByUserId
          : filterByUserId as String?,
      filterByAction: filterByAction == _sentinel
          ? this.filterByAction
          : filterByAction as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props =>
      [status, entries, error, filterByUserId, filterByAction];
}
