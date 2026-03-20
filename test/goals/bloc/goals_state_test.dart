import 'package:envelope/goals/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';

void main() {
  final now = DateTime(2024);
  final testGoals = [
    Goal(
      id: 'goal-1',
      budgetId: 'budget-1',
      name: 'Emergency Fund',
      type: 'savings_target',
      targetAmount: 100000,
      currentAmount: 50000,
      createdAt: now,
      updatedAt: now,
    ),
    Goal(
      id: 'goal-2',
      budgetId: 'budget-1',
      name: 'Monthly Savings',
      type: 'monthly_contribution',
      monthlyContribution: 20000,
      currentAmount: 60000,
      createdAt: now,
      updatedAt: now,
    ),
    Goal(
      id: 'goal-3',
      budgetId: 'budget-1',
      name: 'Pay Off Card',
      type: 'debt_payoff',
      targetAmount: 200000,
      currentAmount: 200000,
      isCompleted: true,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  group('GoalsState', () {
    test('goalsByType groups goals by type', () {
      final state = GoalsState(goals: testGoals);
      final grouped = state.goalsByType;

      expect(grouped.keys.length, equals(3));
      expect(grouped['savings_target']!.length, equals(1));
      expect(grouped['monthly_contribution']!.length, equals(1));
      expect(grouped['debt_payoff']!.length, equals(1));
    });

    test('activeGoals returns only non-completed goals', () {
      final state = GoalsState(goals: testGoals);
      final active = state.activeGoals;

      expect(active.length, equals(2));
      expect(active.every((g) => !g.isCompleted), isTrue);
    });

    test('completedGoals returns only completed goals', () {
      final state = GoalsState(goals: testGoals);
      final completed = state.completedGoals;

      expect(completed.length, equals(1));
      expect(completed.first.id, equals('goal-3'));
    });

    test('copyWith preserves error when sentinel used', () {
      const state = GoalsState(error: GoalsError.loadFailed);
      final copied = state.copyWith(status: GoalsStatus.loaded);

      expect(copied.error, equals(GoalsError.loadFailed));
    });

    test('copyWith clears error when null passed explicitly', () {
      const state = GoalsState(error: GoalsError.loadFailed);
      final copied = state.copyWith(error: null);

      expect(copied.error, isNull);
    });
  });
}
