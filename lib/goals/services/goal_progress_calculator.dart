import 'package:envelope_repository/envelope_repository.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Computes a goal's effective `currentAmount` from envelope state.
///
/// For unlinked goals (`envelopeId == null`), returns the stored
/// `goal.currentAmount` so manual contributions still apply.
class GoalProgressCalculator {
  const GoalProgressCalculator._();

  static int compute({
    required Goal goal,
    required EnvelopeAllocation? allocation,
    required Iterable<Transaction> envelopeTransactions,
  }) {
    if (goal.envelopeId == null) return goal.currentAmount;
    switch (goal.type) {
      case 'monthly_contribution':
        return allocation?.allocatedAmount ?? 0;
      case 'savings_target':
        return allocation == null
            ? 0
            : EnvelopeRepository.calculateRollover(allocation);
      case 'debt_payoff':
        return envelopeTransactions
            .where((t) => t.type == 'expense')
            .fold<int>(0, (sum, t) => sum + t.amount);
      default:
        return goal.currentAmount;
    }
  }
}
