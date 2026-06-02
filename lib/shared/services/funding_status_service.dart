import 'package:envelope/goals/widgets/goal_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:goal_repository/goal_repository.dart';

/// Funding state of an envelope or goal under the global allocation model.
///
/// Drives the colored badge on allocation rows and goal tiles.
enum FundingStatus {
  /// No active target — render no badge.
  noTarget,

  /// `spent > allocated` — the envelope is in the red.
  overspent,

  /// `allocated < target` but not yet overspent.
  underfunded,

  /// `allocated >= target` and not overspent.
  fullyFunded,
}

/// Cross-cutting helper that derives funding state from envelope allocations
/// and goal targets. Under the global model "needed" is computed once
/// against the current allocation, not per-period.
class FundingStatusService {
  const FundingStatusService({DateTime Function()? clock}) : _clock = clock;

  final DateTime Function()? _clock;

  /// Cents still needed to hit every active linked goal's monthly
  /// contribution target, net of [allocatedCents].
  int neededThisPeriod({
    required int allocatedCents,
    required List<Goal> linkedGoals,
  }) {
    final target = linkedGoals
        .where((g) => !g.isCompleted)
        .fold<int>(
          0,
          (sum, goal) => sum + monthlyContributionNeeded(goal, clock: _clock),
        );
    if (target <= 0) return 0;
    final shortfall = target - allocatedCents;
    return shortfall > 0 ? shortfall : 0;
  }

  /// Cents needed for [goal] net of any [contributions] already recorded.
  int neededThisPeriodForGoal(
    Goal goal, {
    List<GoalContribution> contributions = const [],
  }) {
    if (goal.isCompleted) return 0;
    final monthly = monthlyContributionNeeded(goal, clock: _clock);
    if (monthly <= 0) return 0;
    final contributed = contributions.fold<int>(
      0,
      (sum, c) => sum + c.amountCents,
    );
    final remaining = monthly - contributed;
    return remaining > 0 ? remaining : 0;
  }

  /// Classifies an envelope's funding state.
  ///
  /// [spent] is the running expense total for this envelope (derived from
  /// transactions); pass 0 when unknown to suppress the overspent path.
  FundingStatus classifyEnvelope({
    required int allocatedCents,
    required List<Goal> linkedGoals,
    EnvelopeAllocation? allocation,
    int spent = 0,
  }) {
    final target = linkedGoals
        .where((g) => !g.isCompleted)
        .fold<int>(
          0,
          (sum, goal) => sum + monthlyContributionNeeded(goal, clock: _clock),
        );
    if (target <= 0) return FundingStatus.noTarget;

    if (spent > allocatedCents) return FundingStatus.overspent;

    return allocatedCents >= target
        ? FundingStatus.fullyFunded
        : FundingStatus.underfunded;
  }

  /// Classifies a goal's funding state.
  FundingStatus classifyGoal(
    Goal goal, {
    List<GoalContribution> contributions = const [],
  }) {
    if (goal.isCompleted) return FundingStatus.noTarget;
    final monthly = monthlyContributionNeeded(goal, clock: _clock);
    if (monthly <= 0) return FundingStatus.noTarget;
    final needed = neededThisPeriodForGoal(goal, contributions: contributions);
    return needed > 0
        ? FundingStatus.underfunded
        : FundingStatus.fullyFunded;
  }
}
