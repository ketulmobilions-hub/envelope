import 'package:goal_repository/goal_repository.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime(2026, 5, 1);
  final calculator = DebtPayoffCalculator(clock: () => now);

  group('DebtPayoffCalculator.compute', () {
    test('zero balance returns 0 months / 0 interest immediately', () {
      final schedule = calculator.compute(
        balanceCents: 0,
        aprBps: 1799,
        monthlyPaymentCents: 20000,
      );
      expect(schedule.monthsToPayoff, 0);
      expect(schedule.totalInterestCents, 0);
      expect(schedule.infinite, false);
    });

    test('zero APR pays down linearly', () {
      // $1200 balance at 0% APR with $100/mo = 12 months, $0 interest.
      final schedule = calculator.compute(
        balanceCents: 120000,
        aprBps: 0,
        monthlyPaymentCents: 10000,
      );
      expect(schedule.monthsToPayoff, 12);
      expect(schedule.totalInterestCents, 0);
      expect(schedule.infinite, false);
    });

    test('returns realistic months for typical credit-card terms', () {
      // $5000 @ 18.0% APR with $150/mo: standard amortization → ~47 months.
      final schedule = calculator.compute(
        balanceCents: 500000,
        aprBps: 1800,
        monthlyPaymentCents: 15000,
      );
      expect(schedule.monthsToPayoff, inInclusiveRange(46, 48));
      expect(schedule.totalInterestCents, greaterThan(0));
      expect(schedule.infinite, false);
    });

    test('payment <= first-month interest is flagged infinite', () {
      // $10,000 @ 24% APR → $200/mo interest. A $200/mo payment never wins.
      final schedule = calculator.compute(
        balanceCents: 1000000,
        aprBps: 2400,
        monthlyPaymentCents: 20000,
      );
      expect(schedule.infinite, true);
      expect(schedule.payoffDate, isNull);
    });

    test('payment just above interest produces a long but finite schedule', () {
      final schedule = calculator.compute(
        balanceCents: 1000000,
        aprBps: 2400,
        monthlyPaymentCents: 20100,
      );
      expect(schedule.infinite, false);
      expect(schedule.monthsToPayoff, greaterThan(120));
    });

    test('payoffDate is monthsToPayoff months from the injected clock', () {
      final schedule = calculator.compute(
        balanceCents: 120000,
        aprBps: 0,
        monthlyPaymentCents: 10000,
      );
      // 12 months from 2026-05-01 → 2027-05-01.
      expect(schedule.payoffDate, DateTime(2027, 5, 1));
    });

    test('payoffDate clamps overflowing days to end of month', () {
      // Clock = 2026-01-31. +1 month must land on Feb 28, not Mar 3.
      final calc = DebtPayoffCalculator(clock: () => DateTime(2026, 1, 31));
      final schedule = calc.compute(
        balanceCents: 10000,
        aprBps: 0,
        monthlyPaymentCents: 10000,
      );
      expect(schedule.monthsToPayoff, 1);
      expect(schedule.payoffDate, DateTime(2026, 2, 28));
    });

    test('single-month payoff when payment >= balance', () {
      final schedule = calculator.compute(
        balanceCents: 5000,
        aprBps: 0,
        monthlyPaymentCents: 10000,
      );
      expect(schedule.monthsToPayoff, 1);
      expect(schedule.totalInterestCents, 0);
    });

    test('returns infinite when amortization would exceed the 600-month cap', () {
      // Payment marginally over interest → schedule longer than 600 months.
      // At $1M @ 24% APR, first-month interest is $20,000. A $20,001/mo
      // payment chips $1 of principal initially — easily blows the cap.
      final schedule = calculator.compute(
        balanceCents: 100000000,
        aprBps: 2400,
        monthlyPaymentCents: 2000001,
      );
      expect(schedule.infinite, true);
    });

    test('negative or zero monthly payment short-circuits to 0 months', () {
      final schedule = calculator.compute(
        balanceCents: 500000,
        aprBps: 1800,
        monthlyPaymentCents: 0,
      );
      expect(schedule.monthsToPayoff, 0);
      expect(schedule.totalInterestCents, 0);
      expect(schedule.infinite, false);
    });
  });
}
