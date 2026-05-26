import 'package:envelope_repository/envelope_repository.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Computes a goal's effective `currentAmount` from envelope state.
///
/// Cross-period: `envelopeAllocations` should contain every allocation row
/// for the linked envelope across all budget periods. This avoids fragile
/// current-period detection — `savings_target` sums `allocated - spent` over
/// all periods, which is mathematically equivalent to `calculateRollover` of
/// the latest period.
///
/// For unlinked goals (`envelopeId == null`), returns the stored
/// `goal.currentAmount` so manual contributions still apply.
class GoalProgressCalculator {
  const GoalProgressCalculator._();

  /// [accountBalance] is the linked account's balance in the budget's base
  /// currency. Required for account-linked goals; ignored otherwise.
  static int compute({
    required Goal goal,
    Iterable<EnvelopeAllocation> envelopeAllocations = const [],
    Iterable<Transaction> envelopeTransactions = const [],
    int? accountBalance,
  }) {
    // Account-linked goals track the linked account's balance directly.
    // Checked first so a goal that somehow has both links prefers the account.
    // Falls back to the stored amount if the balance is unavailable.
    if (goal.accountId != null) {
      return accountBalance ?? goal.currentAmount;
    }
    if (goal.envelopeId == null) return goal.currentAmount;
    switch (goal.type) {
      case 'savings_target':
        return envelopeAllocations.fold<int>(
          0,
          (sum, a) => sum + a.allocatedAmount - a.spentAmount,
        );
      case 'monthly_contribution':
        if (envelopeAllocations.isEmpty) return 0;
        final sorted = envelopeAllocations.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return sorted.first.allocatedAmount;
      case 'debt_payoff':
        return envelopeTransactions
            .where((t) => t.type == 'expense')
            .fold<int>(0, (sum, t) => sum + t.amount);
      default:
        return goal.currentAmount;
    }
  }
}
