import 'package:envelope/l10n/l10n.dart';

/// Returns a localized label for a recurring frequency string.
String localizedFrequency(String frequency, AppLocalizations l10n) {
  return switch (frequency) {
    'daily' => l10n.recurringFrequencyDaily,
    'weekly' => l10n.recurringFrequencyWeekly,
    'bi-weekly' => l10n.recurringFrequencyBiWeekly,
    'monthly' => l10n.recurringFrequencyMonthly,
    'yearly' => l10n.recurringFrequencyYearly,
    'custom' => l10n.recurringFrequencyCustom,
    _ => frequency,
  };
}
