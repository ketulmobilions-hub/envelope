/// Result of a debt-payoff projection.
///
/// All monetary values are in cents.
class DebtPayoffSchedule {
  const DebtPayoffSchedule({
    required this.monthsToPayoff,
    required this.totalInterestCents,
    required this.payoffDate,
    this.infinite = false,
  });

  /// Constant returned for [DebtPayoffSchedule.infinite] schedules to signal
  /// that the user's monthly payment never makes a dent in the balance.
  const DebtPayoffSchedule.infinite()
    : monthsToPayoff = -1,
      totalInterestCents = 0,
      payoffDate = null,
      infinite = true;

  final int monthsToPayoff;
  final int totalInterestCents;
  final DateTime? payoffDate;

  /// True when the projected payment does not cover the monthly interest
  /// charge — the balance grows indefinitely.
  final bool infinite;
}

/// Computes a fixed-payment debt-payoff schedule using standard monthly
/// amortization on [balanceCents] at [aprBps] APR with [monthlyPaymentCents]
/// applied each month.
///
/// Returns [DebtPayoffSchedule.infinite] when [monthlyPaymentCents] is less
/// than or equal to the first month's interest charge. The simulation is
/// capped at 600 months (50 years) as a defensive guard against pathological
/// inputs.
class DebtPayoffCalculator {
  const DebtPayoffCalculator({DateTime Function()? clock}) : _clock = clock;

  final DateTime Function()? _clock;

  static const int _maxMonths = 600;

  DebtPayoffSchedule compute({
    required int balanceCents,
    required int aprBps,
    required int monthlyPaymentCents,
  }) {
    if (balanceCents <= 0 || monthlyPaymentCents <= 0) {
      return DebtPayoffSchedule(
        monthsToPayoff: 0,
        totalInterestCents: 0,
        payoffDate: (_clock ?? DateTime.now)(),
      );
    }

    final monthlyRate = aprBps / 10000 / 12;

    // First-month interest gate: if the payment cannot exceed the interest
    // charge on the current balance, the loan never pays down.
    final firstInterest = balanceCents * monthlyRate;
    if (monthlyPaymentCents <= firstInterest) {
      return const DebtPayoffSchedule.infinite();
    }

    var remaining = balanceCents.toDouble();
    var totalInterest = 0.0;
    var months = 0;

    while (remaining > 0 && months < _maxMonths) {
      final interest = remaining * monthlyRate;
      final principal = monthlyPaymentCents - interest;
      remaining -= principal;
      totalInterest += interest;
      months += 1;
      if (remaining <= 0) break;
    }

    if (remaining > 0) {
      // Capped without reaching zero — treat as infinite.
      return const DebtPayoffSchedule.infinite();
    }

    final now = (_clock ?? DateTime.now)();
    return DebtPayoffSchedule(
      monthsToPayoff: months,
      totalInterestCents: totalInterest.round(),
      payoffDate: _addMonths(now, months),
    );
  }

  /// Adds [months] to [from] without month-overflow surprises (e.g. Jan 31
  /// + 1 month should land on Feb 28/29, not Mar 3). Days are clamped to
  /// the last valid day of the target month.
  static DateTime _addMonths(DateTime from, int months) {
    final targetMonthIndex = from.month - 1 + months;
    final year = from.year + targetMonthIndex ~/ 12;
    final month = targetMonthIndex % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = from.day > lastDay ? lastDay : from.day;
    return DateTime(year, month, day);
  }
}
