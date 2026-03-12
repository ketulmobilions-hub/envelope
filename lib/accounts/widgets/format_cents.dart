/// Formats an integer amount in cents to a currency string.
///
/// Example: `1500` → `$15.00`, `-250` → `-$2.50`.
String formatCents(int cents) {
  final negative = cents < 0;
  final absCents = cents.abs();
  final dollars = absCents ~/ 100;
  final remainder = (absCents % 100).toString().padLeft(2, '0');
  final formatted = '\$$dollars.$remainder';
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
  return (value * 100).round();
}
