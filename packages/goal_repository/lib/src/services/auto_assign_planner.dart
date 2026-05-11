import 'package:goal_repository/src/models/goal.dart';

/// One planned allocation produced by [AutoAssignPlanner.plan].
///
/// For goals linked to an envelope, the funds should be applied to that
/// envelope's current-period allocation. For unlinked goals, the funds
/// should be recorded as a contribution.
class AutoAssignAction {
  const AutoAssignAction._({
    required this.goal,
    required this.addCents,
    this.envelopeId,
  });

  /// Create a top-up against a linked envelope's allocation.
  factory AutoAssignAction.envelope({
    required Goal goal,
    required String envelopeId,
    required int addCents,
  }) => AutoAssignAction._(
    goal: goal,
    addCents: addCents,
    envelopeId: envelopeId,
  );

  /// Create a contribution against an unlinked goal.
  factory AutoAssignAction.contribution({
    required Goal goal,
    required int addCents,
  }) => AutoAssignAction._(goal: goal, addCents: addCents);

  final Goal goal;
  final int addCents;

  /// The envelope to top up; null when the action represents a contribution
  /// against an unlinked goal.
  final String? envelopeId;

  bool get isContribution => envelopeId == null;

  AutoAssignAction copyWith({int? addCents}) => AutoAssignAction._(
    goal: goal,
    envelopeId: envelopeId,
    addCents: addCents ?? this.addCents,
  );
}

/// Plans how a Ready-to-Assign pool should be distributed across goals.
///
/// Pure function: callers feed it the goals, the per-goal needed amounts,
/// and the RTA pool, and get back a deterministic list of actions to apply.
class AutoAssignPlanner {
  const AutoAssignPlanner();

  /// Returns the list of actions that, if applied in order, allocates as
  /// much of [rtaCents] as possible toward the [goalsByPriority] in their
  /// given order without exceeding each goal's [neededByGoalId] amount.
  ///
  /// Completed goals and goals with zero need are skipped silently.
  List<AutoAssignAction> plan({
    required List<Goal> goalsByPriority,
    required Map<String, int> neededByGoalId,
    required int rtaCents,
  }) {
    if (rtaCents <= 0) return const [];

    var remaining = rtaCents;
    final actions = <AutoAssignAction>[];

    for (final goal in goalsByPriority) {
      if (remaining <= 0) break;
      if (goal.isCompleted) continue;

      final needed = neededByGoalId[goal.id] ?? 0;
      if (needed <= 0) continue;

      final addCents = needed < remaining ? needed : remaining;
      remaining -= addCents;

      final envelopeId = goal.envelopeId;
      actions.add(
        envelopeId != null
            ? AutoAssignAction.envelope(
                goal: goal,
                envelopeId: envelopeId,
                addCents: addCents,
              )
            : AutoAssignAction.contribution(goal: goal, addCents: addCents),
      );
    }

    return actions;
  }
}
