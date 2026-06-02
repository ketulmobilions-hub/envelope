import 'package:envelope/auth/auth.dart';
import 'package:envelope/onboarding/data/currencies.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Returns the currency symbol for the current user's base currency.
String currencySymbol(BuildContext context) {
  final code = context.watch<AuthBloc>().state.user?.baseCurrency ?? 'USD';
  return currencySymbolFromCode(code);
}

/// Returns the currency symbol for an arbitrary ISO 4217 [code].
///
/// Falls back to the first supported currency's symbol (USD `$`) when [code]
/// is not in the supported list. Use this for displaying foreign-currency
/// transaction or account amounts where the currency is per-row, not the
/// budget base currency.
String currencySymbolFromCode(String code) {
  return supportedCurrencies
      .firstWhere(
        (c) => c.code == code,
        orElse: () => supportedCurrencies.first,
      )
      .symbol;
}
