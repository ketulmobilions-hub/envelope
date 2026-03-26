part of 'activity_log_bloc.dart';

sealed class ActivityLogEvent extends Equatable {
  const ActivityLogEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to activity log entries.
final class ActivityLogStarted extends ActivityLogEvent {
  const ActivityLogStarted();
}

/// Pull-to-refresh activity log.
final class ActivityLogRefreshRequested extends ActivityLogEvent {
  const ActivityLogRefreshRequested();
}

/// Apply local filters to the activity log.
final class ActivityLogFilterChanged extends ActivityLogEvent {
  const ActivityLogFilterChanged({this.userId, this.action});

  final String? userId;
  final String? action;

  @override
  List<Object?> get props => [userId, action];
}

/// Internal event when the activity log stream emits new data.
final class _ActivityLogUpdated extends ActivityLogEvent {
  const _ActivityLogUpdated(this.entries);

  final List<ActivityLogEntry> entries;

  @override
  List<Object?> get props => [entries];
}

/// Internal event when the activity log stream errors.
final class _ActivityLogStreamError extends ActivityLogEvent {
  const _ActivityLogStreamError();
}
