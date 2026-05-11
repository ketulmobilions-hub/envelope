import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/shared/services/funding_status_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';

void main() {
  final now = DateTime(2026, 3, 1);
  DateTime fixedNow() => now;

  final period = BudgetPeriod(
    id: 'period-1',
    budgetId: 'budget-1',
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 4, 1),
    createdAt: now,
  );

  Goal goal({
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
    bool isCompleted = false,
    String? envelopeId,
    String id = 'goal-1',
    String type = 'savings_target',
  }) {
    return Goal(
      id: id,
      budgetId: 'budget-1',
      type: type,
      name: 'Goal',
      createdAt: now,
      updatedAt: now,
      envelopeId: envelopeId,
      targetAmount: targetAmount,
      targetDate: targetDate,
      monthlyContribution: monthlyContribution,
      isCompleted: isCompleted,
    );
  }

  group('FundingStatusService.neededThisPeriod', () {
    final service = FundingStatusService(clock: fixedNow);

    test('returns 0 when no linked goals', () {
      expect(
        service.neededThisPeriod(allocatedCents: 0, linkedGoals: const []),
        0,
      );
    });

    test('returns 0 when only completed goals are linked', () {
      final completed = goal(
        targetAmount: 100000,
        targetDate: DateTime(2026, 12, 1),
        isCompleted: true,
      );
      expect(
        service.neededThisPeriod(
          allocatedCents: 0,
          linkedGoals: [completed],
        ),
        0,
      );
    });

    test('returns shortfall when nothing allocated yet', () {
      // $900 remaining over 9 months = $100/month.
      final g = goal(
        targetAmount: 90000,
        targetDate: DateTime(2026, 12, 1),
      );
      expect(
        service.neededThisPeriod(allocatedCents: 0, linkedGoals: [g]),
        10000,
      );
    });

    test('returns 0 when allocation already meets monthly target', () {
      final g = goal(
        targetAmount: 90000,
        targetDate: DateTime(2026, 12, 1),
      );
      expect(
        service.neededThisPeriod(allocatedCents: 10000, linkedGoals: [g]),
        0,
      );
    });

    test('returns 0 when allocation exceeds monthly target', () {
      final g = goal(
        targetAmount: 90000,
        targetDate: DateTime(2026, 12, 1),
      );
      expect(
        service.neededThisPeriod(allocatedCents: 25000, linkedGoals: [g]),
        0,
      );
    });

    test('sums monthly targets across multiple linked goals', () {
      final g1 = goal(
        id: 'g1',
        targetAmount: 90000, // $100/mo over 9 months
        targetDate: DateTime(2026, 12, 1),
      );
      final g2 = goal(
        id: 'g2',
        type: 'monthly_contribution',
        monthlyContribution: 5000, // recurring $50/mo, no target balance
      );
      expect(
        service.neededThisPeriod(
          allocatedCents: 3000,
          linkedGoals: [g1, g2],
        ),
        // (10000 + 5000) - 3000
        12000,
      );
    });
  });

  group('FundingStatusService.neededThisPeriodForGoal', () {
    final service = FundingStatusService(clock: fixedNow);

    test('returns 0 for completed goals', () {
      final g = goal(
        targetAmount: 50000,
        targetDate: DateTime(2026, 12, 1),
        isCompleted: true,
      );
      expect(service.neededThisPeriodForGoal(g), 0);
    });

    test('returns monthly target when no period supplied', () {
      // $900 / 9 months = $100/mo.
      final g = goal(
        targetAmount: 90000,
        targetDate: DateTime(2026, 12, 1),
      );
      expect(service.neededThisPeriodForGoal(g), 10000);
    });

    test('subtracts contributions within the given period', () {
      final g = goal(
        id: 'goal-x',
        targetAmount: 90000,
        targetDate: DateTime(2026, 12, 1),
      );
      final contributions = [
        GoalContribution(
          id: 'c1',
          goalId: 'goal-x',
          amountCents: 3000,
          createdAt: DateTime(2026, 3, 5),
        ),
        // Outside the period — should be ignored.
        GoalContribution(
          id: 'c2',
          goalId: 'goal-x',
          amountCents: 50000,
          createdAt: DateTime(2026, 2, 15),
        ),
      ];
      expect(
        service.neededThisPeriodForGoal(
          g,
          contributions: contributions,
          period: period,
        ),
        7000,
      );
    });

    test('returns 0 when in-period contributions cover the monthly target', () {
      final g = goal(
        id: 'goal-x',
        targetAmount: 90000,
        targetDate: DateTime(2026, 12, 1),
      );
      final contributions = [
        GoalContribution(
          id: 'c1',
          goalId: 'goal-x',
          amountCents: 15000,
          createdAt: DateTime(2026, 3, 10),
        ),
      ];
      expect(
        service.neededThisPeriodForGoal(
          g,
          contributions: contributions,
          period: period,
        ),
        0,
      );
    });

    test('returns full remaining when target date is in the past', () {
      // Past target date: full remaining balance is "needed now".
      final g = goal(
        targetAmount: 90000,
        targetDate: DateTime(2025, 1, 1),
      );
      expect(service.neededThisPeriodForGoal(g), 90000);
    });
  });
}
