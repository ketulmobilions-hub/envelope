/// Maximum allowed dollar amount for balance input.
const double maxDollarAmount = 999999999.99;

/// Maximum allowed cents amount (maxDollarAmount * 100).
const int maxCentsAmount = 99999999999;

/// Formats an integer amount in cents to a currency string.
///
/// Example: `1500` → `$15.00`, `-250` → `-$2.50`.
String formatCents(int cents, {String symbol = r'$'}) {
  final negative = cents < 0;
  final absCents = cents.abs();
  final dollars = absCents ~/ 100;
  final remainder = (absCents % 100).toString().padLeft(2, '0');
  final formatted = '$symbol$dollars.$remainder';
  return negative ? '-$formatted' : formatted;
}

/// Parses a decimal string to cents. Returns `null` on invalid input.
///
/// Example: `'15.50'` → `1550`, `'-2.50'` → `-250`.
int? parseCents(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  final value = double.tryParse(trimmed);
  if (value == null) return null;
  if (value.abs() > maxDollarAmount) return null;
  return (value * 100).round();
}
