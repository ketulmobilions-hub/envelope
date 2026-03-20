import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:goal_repository/goal_repository.dart';

/// Returns the localized display name for a goal type.
String localizedGoalType(String type, AppLocalizations l10n) {
  return switch (type) {
    'savings_target' => l10n.goalsTypeSavingsTarget,
    'monthly_contribution' => l10n.goalsTypeMonthlyContribution,
    'debt_payoff' => l10n.goalsTypeDebtPayoff,
    _ => type,
  };
}

/// Returns the icon for the given goal type.
IconData iconForGoalType(String type) {
  return switch (type) {
    'savings_target' => Icons.savings_outlined,
    'monthly_contribution' => Icons.calendar_month_outlined,
    'debt_payoff' => Icons.credit_score_outlined,
    _ => Icons.flag_outlined,
  };
}

/// Returns progress ratio 0.0–1.0 for a goal.
double goalProgress(Goal goal) {
  final target = goal.targetAmount;
  if (target == null || target <= 0) return 0;
  return (goal.currentAmount / target).clamp(0.0, 1.0);
}

/// Returns the monthly contribution needed (in cents) to reach target by date.
int monthlyContributionNeeded(Goal goal) {
  final target = goal.targetAmount;
  if (target == null || target <= 0) return 0;

  final remaining = target - goal.currentAmount;
  if (remaining <= 0) return 0;

  final targetDate = goal.targetDate;
  if (targetDate == null) return remaining;

  final now = DateTime.now();
  final months =
      (targetDate.year - now.year) * 12 + targetDate.month - now.month;
  if (months <= 0) return remaining;

  return (remaining / months).ceil();
}
