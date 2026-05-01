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
    required String periodId,
    int allocated = 0,
    int spent = 0,
    int rollover = 0,
    DateTime? createdAt,
  }) {
    return EnvelopeAllocation(
      id: 'alloc-$periodId',
      envelopeId: 'env-1',
      budgetPeriodId: periodId,
      createdAt: createdAt ?? now,
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
        envelopeAllocations: [allocation(periodId: 'p1', allocated: 999)],
        envelopeTransactions: [tx(amount: 500, type: 'expense')],
      );
      expect(result, 12345);
    });

    test('savings_target sums allocated - spent across all periods', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(),
        envelopeAllocations: [
          allocation(periodId: 'p1', allocated: 100, spent: 30),
          allocation(periodId: 'p2', allocated: 0, spent: 0, rollover: 70),
          allocation(periodId: 'p3', allocated: 50, spent: 10),
        ],
        envelopeTransactions: const [],
      );
      // (100-30) + (0-0) + (50-10) = 70 + 0 + 40 = 110
      expect(result, 110);
    });

    test('savings_target with single allocation matches calculateRollover', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(),
        envelopeAllocations: [
          allocation(periodId: 'p1', allocated: 100, spent: 30),
        ],
        envelopeTransactions: const [],
      );
      // 100 - 30 = 70 (matches calculateRollover with rollover=0)
      expect(result, 70);
    });

    test('savings_target with no allocations → 0', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(),
        envelopeAllocations: const [],
        envelopeTransactions: const [],
      );
      expect(result, 0);
    });

    test('monthly_contribution → latest allocation by createdAt', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'monthly_contribution'),
        envelopeAllocations: [
          allocation(
            periodId: 'p1',
            allocated: 100,
            createdAt: DateTime(2024, 1),
          ),
          allocation(
            periodId: 'p2',
            allocated: 200,
            createdAt: DateTime(2024, 3),
          ),
          allocation(
            periodId: 'p3',
            allocated: 150,
            createdAt: DateTime(2024, 2),
          ),
        ],
        envelopeTransactions: const [],
      );
      expect(result, 200);
    });

    test('monthly_contribution with empty allocations → 0', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'monthly_contribution'),
        envelopeAllocations: const [],
        envelopeTransactions: const [],
      );
      expect(result, 0);
    });

    test('debt_payoff → sums only expense transactions', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'debt_payoff'),
        envelopeAllocations: [
          allocation(periodId: 'p1', allocated: 999),
        ],
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
        envelopeAllocations: const [],
        envelopeTransactions: const [],
      );
      expect(result, 0);
    });

    test('unknown type falls back to stored currentAmount', () {
      final result = GoalProgressCalculator.compute(
        goal: goal(type: 'unknown', currentAmount: 999),
        envelopeAllocations: [allocation(periodId: 'p1', allocated: 100)],
        envelopeTransactions: const [],
      );
      expect(result, 999);
    });
  });
}
