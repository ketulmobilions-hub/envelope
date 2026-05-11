/// Feature flags for in-progress / hidden features.
///
/// Multi-currency is hidden post-MVP: base currency is set during onboarding
/// only, and transactions/accounts implicitly use it. To restore the picker
/// UI in settings, transaction form, and account form, build with
/// `--dart-define=ENABLE_MULTI_CURRENCY=true`.
const kMultiCurrencyEnabled = bool.fromEnvironment(
  'ENABLE_MULTI_CURRENCY',
);
