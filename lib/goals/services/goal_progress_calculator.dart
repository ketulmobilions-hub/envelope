import 'package:envelope_repository/envelope_repository.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Computes a goal's effective `currentAmount` from envelope state.
///
/// Under the global model, "spent" is derived from transactions instead of a
/// stored aggregate. Callers pass [envelopeTransactions] so per-envelope
/// expense totals can be summed where needed (e.g. debt_payoff).
class GoalProgressCalculator {
  const GoalProgressCalculator._();

  /// [accountBalance] is the linked account's balance in the budget's base
  /// currency. Required for account-linked goals; ignored otherwise.
  static int compute({
    required Goal goal,
    EnvelopeAllocation? envelopeAllocation,
    Iterable<Transaction> envelopeTransactions = const [],
    int? accountBalance,
  }) {
    // Account-linked goals track the linked account's balance directly.
    if (goal.accountId != null) {
      return accountBalance ?? goal.currentAmount;
    }
    if (goal.envelopeId == null) return goal.currentAmount;
    switch (goal.type) {
      case 'savings_target':
        final allocated = envelopeAllocation?.allocatedAmount ?? 0;
        final spent = envelopeTransactions
            .where((t) => t.type == 'expense')
            .fold<int>(0, (sum, t) => sum + t.baseCurrencyAmount);
        return allocated - spent;
      case 'monthly_contribution':
        return envelopeAllocation?.allocatedAmount ?? 0;
      case 'debt_payoff':
        return envelopeTransactions
            .where((t) => t.type == 'expense')
            .fold<int>(0, (sum, t) => sum + t.amount);
      default:
        return goal.currentAmount;
    }
  }
}
