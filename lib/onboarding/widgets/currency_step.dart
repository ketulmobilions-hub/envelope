import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:envelope/onboarding/data/currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyStep extends StatefulWidget {
  const CurrencyStep({super.key});

  @override
  State<CurrencyStep> createState() => _CurrencyStepState();
}

class _CurrencyStepState extends State<CurrencyStep> {
  String _searchQuery = '';

  List<CurrencyInfo> get _filteredCurrencies {
    if (_searchQuery.isEmpty) return supportedCurrencies;
    final query = _searchQuery.toLowerCase();
    return supportedCurrencies
        .where(
          (c) =>
              c.code.toLowerCase().contains(query) ||
              c.name.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected =
        context.select<OnboardingCubit, String>(
      (c) => c.state.baseCurrency,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingCurrencyTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(l10n.onboardingCurrencyDescription),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.onboardingCurrencySearch,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) =>
                    setState(() => _searchQuery = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: RadioGroup<String>(
            groupValue: selected,
            onChanged: (value) {
              if (value != null) {
                context
                    .read<OnboardingCubit>()
                    .selectCurrency(value);
              }
            },
            child: ListView.builder(
              itemCount: _filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    '${currency.code} - ${currency.name} (${currency.symbol})',
                    style: const TextStyle(fontSize: 15),
                  ),
                  leading: Radio<String>(value: currency.code),
                  onTap: () => context
                      .read<OnboardingCubit>()
                      .selectCurrency(currency.code),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
