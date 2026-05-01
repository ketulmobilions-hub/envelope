import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/data/currencies.dart';
import 'package:flutter/material.dart';

/// Reusable bottom-sheet picker for choosing one of [supportedCurrencies].
///
/// Renders a search field plus a scrollable list. The currently-selected
/// [initialCode] is shown with a check mark. Tapping a row pops the sheet
/// and returns the chosen ISO 4217 code via [Navigator.pop].
///
/// Usage:
/// ```dart
/// final code = await showModalBottomSheet<String>(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => CurrencyPickerSheet(
///     initialCode: account.currency,
///     title: 'Account currency',
///   ),
/// );
/// ```
///
/// Optional [warning] renders below the title — useful for the settings
/// flow that warns existing transactions are not auto-converted.
class CurrencyPickerSheet extends StatefulWidget {
  const CurrencyPickerSheet({
    required this.initialCode,
    this.title,
    this.warning,
    super.key,
  });

  final String initialCode;
  final String? title;
  final String? warning;

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.title!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (widget.warning != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.warning!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.onboardingCurrencySearch,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            if (_filteredCurrencies.isEmpty)
              const Expanded(
                child: Center(child: Text('No currencies found')),
              )
            else
              Flexible(
                child: ListView.builder(
                  itemCount: _filteredCurrencies.length,
                  itemBuilder: (_, index) {
                    final currency = _filteredCurrencies[index];
                    final isSelected = currency.code == widget.initialCode;
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        '${currency.symbol} ${currency.code}'
                        ' - ${currency.name}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () => Navigator.pop(context, currency.code),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
