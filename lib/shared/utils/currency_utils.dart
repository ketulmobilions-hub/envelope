import 'package:envelope/auth/auth.dart';
import 'package:envelope/onboarding/data/currencies.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Returns the currency symbol for the current user's base currency.
String currencySymbol(BuildContext context) {
  final code =
      context.watch<AuthBloc>().state.user?.baseCurrency ?? 'USD';
  return supportedCurrencies
      .firstWhere(
        (c) => c.code == code,
        orElse: () => supportedCurrencies.first,
      )
      .symbol;
}
