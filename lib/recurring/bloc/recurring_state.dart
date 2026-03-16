part of 'recurring_bloc.dart';

enum RecurringStatus { initial, loading, loaded, error }

/// Error codes for recurring operations, translated in the UI layer.
enum RecurringError {
  loadFailed,
  deleteFailed,
  undoFailed,
  pauseFailed,
}

final class RecurringState extends Equatable {
  const RecurringState({
    this.status = RecurringStatus.initial,
    this.recurringRules = const [],
    this.billReminders = const [],
    this.error,
  });

  final RecurringStatus status;
  final List<RecurringRule> recurringRules;
  final List<BillReminder> billReminders;
  final RecurringError? error;

  /// Active (non-paused) recurring rules.
  List<RecurringRule> get activeRules =>
      recurringRules.where((r) => !r.isPaused).toList();

  /// Paused recurring rules.
  List<RecurringRule> get pausedRules =>
      recurringRules.where((r) => r.isPaused).toList();

  /// Recurring rules sorted by next occurrence (soonest first).
  List<RecurringRule> get upcomingRules {
    final active = activeRules..sort(
        (a, b) => a.nextOccurrence.compareTo(b.nextOccurrence),
      );
    return active;
  }

  /// Bill reminders sorted by due day.
  List<BillReminder> get upcomingBills {
    final sorted = List<BillReminder>.of(billReminders)
      ..sort((a, b) => a.dueDay.compareTo(b.dueDay));
    return sorted;
  }

  RecurringState copyWith({
    RecurringStatus? status,
    List<RecurringRule>? recurringRules,
    List<BillReminder>? billReminders,
    Object? error = _sentinel,
  }) {
    return RecurringState(
      status: status ?? this.status,
      recurringRules: recurringRules ?? this.recurringRules,
      billReminders: billReminders ?? this.billReminders,
      error: error == _sentinel ? this.error : error as RecurringError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, recurringRules, billReminders, error];
}
