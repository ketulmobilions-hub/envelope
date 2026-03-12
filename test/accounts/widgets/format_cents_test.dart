import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCents', () {
    test('formats positive amounts', () {
      expect(formatCents(1500), equals(r'$15.00'));
      expect(formatCents(100), equals(r'$1.00'));
      expect(formatCents(1), equals(r'$0.01'));
      expect(formatCents(0), equals(r'$0.00'));
    });

    test('formats negative amounts', () {
      expect(formatCents(-250), equals(r'-$2.50'));
      expect(formatCents(-1), equals(r'-$0.01'));
    });

    test('pads cents correctly', () {
      expect(formatCents(5), equals(r'$0.05'));
      expect(formatCents(10), equals(r'$0.10'));
    });
  });

  group('parseCents', () {
    test('parses valid decimal strings', () {
      expect(parseCents('15.50'), equals(1550));
      expect(parseCents('0.01'), equals(1));
      expect(parseCents('100'), equals(10000));
    });

    test('parses negative values', () {
      expect(parseCents('-2.50'), equals(-250));
    });

    test('returns null for empty string', () {
      expect(parseCents(''), isNull);
      expect(parseCents('  '), isNull);
    });

    test('returns null for invalid input', () {
      expect(parseCents('abc'), isNull);
      expect(parseCents('12.34.56'), isNull);
    });
  });
}
