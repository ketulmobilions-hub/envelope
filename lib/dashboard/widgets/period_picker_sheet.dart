import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Shows a bottom sheet that lets the user pick any available budget period.
/// Returns the selected [BudgetPeriod], or null if dismissed.
Future<BudgetPeriod?> showPeriodPickerSheet(
  BuildContext context, {
  required List<BudgetPeriod> periods,
  required BudgetPeriod? selectedPeriod,
}) {
  return showModalBottomSheet<BudgetPeriod>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => _PeriodPickerSheet(
      periods: periods,
      selectedPeriod: selectedPeriod,
    ),
  );
}

class _PeriodPickerSheet extends StatelessWidget {
  const _PeriodPickerSheet({
    required this.periods,
    required this.selectedPeriod,
  });

  final List<BudgetPeriod> periods;
  final BudgetPeriod? selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    // Group by year, descending (most recent first).
    final byYear = <int, List<BudgetPeriod>>{};
    for (final p in periods) {
      byYear.putIfAbsent(p.startDate.year, () => []).add(p);
    }
    final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));

    return DraggableScrollableSheet(
      expand: false,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                l10n.dashboardSelectPeriod,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: years.length,
                itemBuilder: (context, i) {
                  final year = years[i];
                  // Most recent month first within the year.
                  final yearPeriods = byYear[year]!
                    ..sort((a, b) => b.startDate.compareTo(a.startDate));
                  return _YearSection(
                    year: year,
                    periods: yearPeriods,
                    selectedPeriod: selectedPeriod,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _YearSection extends StatelessWidget {
  const _YearSection({
    required this.year,
    required this.periods,
    required this.selectedPeriod,
  });

  final int year;
  final List<BudgetPeriod> periods;
  final BudgetPeriod? selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 10),
          child: Text(
            '$year',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.outline,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: periods.map((p) {
            return _PeriodChip(
              period: p,
              isSelected: p.id == selectedPeriod?.id,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({required this.period, required this.isSelected});

  final BudgetPeriod period;
  final bool isSelected;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String get _label {
    final s = period.startDate;
    final e = period.endDate;
    if (s.year == e.year && s.month == e.month) return _months[s.month - 1];
    return '${_months[s.month - 1]}–${_months[e.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    const chipSize = Size(72, 40);
    const chipPadding = EdgeInsets.symmetric(horizontal: 16);

    if (isSelected) {
      return FilledButton(
        onPressed: () => Navigator.of(context).pop(period),
        style: FilledButton.styleFrom(
          minimumSize: chipSize,
          padding: chipPadding,
        ),
        child: Text(_label),
      );
    }
    return OutlinedButton(
      onPressed: () => Navigator.of(context).pop(period),
      style: OutlinedButton.styleFrom(
        minimumSize: chipSize,
        padding: chipPadding,
      ),
      child: Text(_label),
    );
  }
}
