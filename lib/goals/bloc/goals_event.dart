part of 'goals_bloc.dart';

sealed class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to goals for the given budget.
final class GoalsStarted extends GoalsEvent {
  const GoalsStarted();
}

/// Internal event when the goals stream emits new data.
final class _GoalsUpdated extends GoalsEvent {
  const _GoalsUpdated(this.goals);

  final List<Goal> goals;

  @override
  List<Object?> get props => [goals];
}

/// Internal event when the goals stream errors.
final class _GoalsStreamError extends GoalsEvent {
  const _GoalsStreamError();
}

/// Internal event triggered by envelope/transaction streams when state
/// affecting linked-goal progress changes.
final class _GoalsRecomputeRequested extends GoalsEvent {
  const _GoalsRecomputeRequested();
}

/// Pull latest goals from the API.
final class GoalsRefreshRequested extends GoalsEvent {
  const GoalsRefreshRequested();
}

/// Delete a goal permanently.
final class GoalDeleted extends GoalsEvent {
  const GoalDeleted(this.goalId);

  final String goalId;

  @override
  List<Object?> get props => [goalId];
}

/// Complete or uncomplete a goal.
final class GoalCompleteToggled extends GoalsEvent {
  const GoalCompleteToggled(this.goal);

  final Goal goal;

  @override
  List<Object?> get props => [goal];
}
