import 'package:envelope/goals/services/goal_progress_calculator.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

void main() {
  final now = DateTime(2024);

  Goal goal({
    String type = 'savings_target',
    String? envelopeId = 'env-1',
    int currentAmount = 0,
  }) {
    return Goal(
      id: 'goal-1',
      budgetId: 'budget-1',
      type: type,
      name: 'Test',
      envelopeId: envelopeId,
      currentAmount: currentAmount,
      createdAt: now,
      updatedAt: now,
    );
  }

  EnvelopeAllocation allocation({
    int allocated = 0,
    int spent = 0,
    int rollover = 0,
  }) {
    return EnvelopeAllocation(
      id: 'alloc-1',
      envelopeId: 'env-1',
      budgetPeriodId: 'period-1',
      createdAt: now,
      allocatedAmount: allocated,
      spentAmount: spent,
      rolloverAmount: rollover,
    );
  }

  Transaction tx({
    required int amount,
    required String type,
    String envelopeId = 'env-1',
  }) {
    return Transaction(
      id: 't-${amount}_$type',
      budgetId: 'budget-1',
      accountId: 'acct-1',
      type: type,
      amount: amount,
      currency: 'USD',
      date: now,
      createdBy: 'user',
      createdAt: now,
      updatedAt: now,
      envelopeId: envelopeId,
    );
  }

  group('GoalProgressCalculator', () {
    test('returns stored currentAmount when envelopeId is null', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(envelopeId: null, currentAmount: 12345),
        allocation: allocation(allocated: 999),
        envelopeTransactions: [tx(amount: 500, type: 'expense')],
      );
      expect(result, 12345);
    });

    test('savings_target → calculateRollover', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(),
        allocation: allocation(allocated: 100, spent: 30, rollover: 50),
        envelopeTransactions: const [],
      );
      // 100 - 30 + 50 = 120
      expect(result, 120);
    });

    test('savings_target with null allocation → 0', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(),
        allocation: null,
        envelopeTransactions: const [],
      );
      expect(result, 0);
    });

    test('monthly_contribution → allocatedAmount', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'monthly_contribution'),
        allocation: allocation(allocated: 200, spent: 40, rollover: 80),
        envelopeTransactions: const [],
      );
      expect(result, 200);
    });

    test('monthly_contribution with null allocation → 0', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'monthly_contribution'),
        allocation: null,
        envelopeTransactions: const [],
      );
      expect(result, 0);
    });

    test('debt_payoff → sums only expense transactions', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'debt_payoff'),
        allocation: allocation(allocated: 999),
        envelopeTransactions: [
          tx(amount: 100, type: 'expense'),
          tx(amount: 50, type: 'income'),
          tx(amount: 25, type: 'transfer'),
          tx(amount: 75, type: 'expense'),
        ],
      );
      expect(result, 175);
    });

    test('debt_payoff with no transactions → 0', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'debt_payoff'),
        allocation: null,
        envelopeTransactions: const [],
      );
      expect(result, 0);
    });

    test('unknown type falls back to stored currentAmount', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'unknown', currentAmount: 999),
        allocation: allocation(allocated: 100),
        envelopeTransactions: const [],
      );
      expect(result, 999);
    });
  });
}
