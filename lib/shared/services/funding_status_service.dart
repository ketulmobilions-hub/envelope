import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/goals/widgets/goal_helpers.dart';
import 'package:goal_repository/goal_repository.dart';

/// Cross-cutting helper that derives funding state for the current period
/// from envelope allocations and goal targets.
///
/// Lives at the app layer to bridge `envelope_repository` and
/// `goal_repository` without introducing a cross-package dependency.
class FundingStatusService {
  const FundingStatusService({DateTime Function()? clock}) : _clock = clock;

  final DateTime Function()? _clock;

  /// Cents still needed this period to hit every active linked goal's monthly
  /// contribution target, net of [allocatedCents].
  ///
  /// Returns 0 when no [linkedGoals] are active or the combined monthly
  /// target is already covered.
  int neededThisPeriod({
    required int allocatedCents,
    required List<Goal> linkedGoals,
  }) {
    final targetForPeriod = linkedGoals
        .where((g) => !g.isCompleted)
        .fold<int>(
          0,
          (sum, goal) => sum + monthlyContributionNeeded(goal, clock: _clock),
        );
    if (targetForPeriod <= 0) return 0;

    final shortfall = targetForPeriod - allocatedCents;
    return shortfall > 0 ? shortfall : 0;
  }

  /// Cents needed this period for [goal], net of any [contributions]
  /// recorded within [period].
  ///
  /// When [period] is null, returns the gross monthly target.
  int neededThisPeriodForGoal(
    Goal goal, {
    List<GoalContribution> contributions = const [],
    BudgetPeriod? period,
  }) {
    if (goal.isCompleted) return 0;
    final monthly = monthlyContributionNeeded(goal, clock: _clock);
    if (monthly <= 0) return 0;
    if (period == null) return monthly;

    final contributed = contributions
        .where(
          (c) =>
              !c.createdAt.isBefore(period.startDate) &&
              c.createdAt.isBefore(period.endDate),
        )
        .fold<int>(0, (sum, c) => sum + c.amountCents);
    final remaining = monthly - contributed;
    return remaining > 0 ? remaining : 0;
  }
}
