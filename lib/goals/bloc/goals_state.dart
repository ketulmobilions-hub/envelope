part of 'goals_bloc.dart';

enum GoalsStatus { initial, loading, refreshing, loaded, error }

/// Error codes for goal operations, translated in the UI layer.
enum GoalsError { loadFailed, updateFailed, deleteFailed }

final class GoalsState extends Equatable {
  const GoalsState({
    this.status = GoalsStatus.initial,
    this.goals = const [],
    this.computedAmounts = const {},
    this.error,
  });

  final GoalsStatus status;
  final List<Goal> goals;

  /// Derived `currentAmount` for goals linked to an envelope, keyed by goal id.
  /// Unlinked goals are absent — UI must fall back to `goal.currentAmount`.
  final Map<String, int> computedAmounts;

  final GoalsError? error;

  /// Goals grouped by type.
  Map<String, List<Goal>> get goalsByType {
    final grouped = <String, List<Goal>>{};
    for (final goal in goals) {
      grouped.putIfAbsent(goal.type, () => []).add(goal);
    }
    return grouped;
  }

  /// Non-completed goals, sorted by [Goal.sortOrder] (id tiebreaker).
  List<Goal> get activeGoals =>
      goals.where((g) => !g.isCompleted).toList()..sort((a, b) {
        final byOrder = a.sortOrder.compareTo(b.sortOrder);
        return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
      });

  /// Completed goals.
  List<Goal> get completedGoals => goals.where((g) => g.isCompleted).toList();

  /// Effective current amount for a goal: derived if available, else stored.
  int effectiveAmount(Goal goal) =>
      computedAmounts[goal.id] ?? goal.currentAmount;

  GoalsState copyWith({
    GoalsStatus? status,
    List<Goal>? goals,
    Map<String, int>? computedAmounts,
    Object? error = _sentinel,
  }) {
    return GoalsState(
      status: status ?? this.status,
      goals: goals ?? this.goals,
      computedAmounts: computedAmounts ?? this.computedAmounts,
      error: error == _sentinel ? this.error : error as GoalsError?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [status, goals, computedAmounts, error];
}
