part of 'recurring_bloc.dart';

sealed class RecurringEvent extends Equatable {
  const RecurringEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to recurring rules and bill reminders for the budget.
final class RecurringStarted extends RecurringEvent {
  const RecurringStarted();
}

/// Internal event when the recurring rules stream emits new data.
final class _RecurringRulesUpdated extends RecurringEvent {
  const _RecurringRulesUpdated(this.rules);

  final List<RecurringRule> rules;

  @override
  List<Object?> get props => [rules];
}

/// Internal event when the bill reminders stream emits new data.
final class _BillRemindersUpdated extends RecurringEvent {
  const _BillRemindersUpdated(this.reminders);

  final List<BillReminder> reminders;

  @override
  List<Object?> get props => [reminders];
}

/// Internal event when the recurring rules stream errors.
final class _RecurringStreamError extends RecurringEvent {
  const _RecurringStreamError();
}

/// Internal event when the bill reminders stream errors.
final class _BillReminderStreamError extends RecurringEvent {
  const _BillReminderStreamError();
}

/// Pull latest recurring rules and bill reminders from the API.
final class RecurringRefreshRequested extends RecurringEvent {
  const RecurringRefreshRequested();
}

/// Delete a recurring rule by its ID.
final class RecurringRuleDeleted extends RecurringEvent {
  const RecurringRuleDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Re-create the last deleted recurring rule (undo).
final class RecurringRuleUndoDeleteRequested extends RecurringEvent {
  const RecurringRuleUndoDeleteRequested();
}

/// Manually post a pending recurring rule as a transaction now.
final class RecurringRulePosted extends RecurringEvent {
  const RecurringRulePosted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Toggle pause/resume on a recurring rule.
final class RecurringRulePauseToggled extends RecurringEvent {
  const RecurringRulePauseToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Delete a bill reminder by its ID.
final class BillReminderDeleted extends RecurringEvent {
  const BillReminderDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Re-create the last deleted bill reminder (undo).
final class BillReminderUndoDeleteRequested extends RecurringEvent {
  const BillReminderUndoDeleteRequested();
}
