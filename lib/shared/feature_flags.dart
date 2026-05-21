/// Feature flags for in-progress / hidden features.
///
/// Multi-currency is hidden post-MVP: base currency is set during onboarding
/// only, and transactions/accounts implicitly use it. To restore the picker
/// UI in settings, transaction form, and account form, build with
/// `--dart-define=ENABLE_MULTI_CURRENCY=true`.
const kMultiCurrencyEnabled = bool.fromEnvironment(
  'ENABLE_MULTI_CURRENCY',
);

/// Toggle the sentence-style add-transaction page on/off.
///
/// `true`  → renders the new fill-in-the-blank `SentenceTransactionFormPage`.
/// `false` → renders the original `TransactionFormPage`.
///
/// Build with `--dart-define=USE_SENTENCE_TRANSACTION_FORM=false` to opt out
/// without editing this file.
const kSentenceTransactionForm = bool.fromEnvironment(
  'USE_SENTENCE_TRANSACTION_FORM',
  defaultValue: false,
);

/// Toggle the drag-to-allocate scrubber bar under each budget allocation row.
///
/// Build with `--dart-define=ENABLE_ALLOCATION_SCRUBBER=false` to disable.
const kAllocationScrubberEnabled = bool.fromEnvironment(
  'ENABLE_ALLOCATION_SCRUBBER',
  defaultValue: true,
);
