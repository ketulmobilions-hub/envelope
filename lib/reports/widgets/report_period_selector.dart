import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date range picker for reports.
class ReportDateRangeSelector extends StatelessWidget {
  const ReportDateRangeSelector({
    required this.startDate,
    required this.endDate,
    required this.onDateRangeSelected,
    super.key,
  });

  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime start, DateTime end) onDateRangeSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formatter = DateFormat.yMMMd();

    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        // Strip time from dates so they don't exceed lastDate.
        final clampedEnd = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
        );
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: today,
          initialDateRange: DateTimeRange(
            start: DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            ),
            end: clampedEnd.isAfter(today) ? today : clampedEnd,
          ),
        );
        if (picked != null) {
          onDateRangeSelected(picked.start, picked.end);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.reportsDateRange,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
        ),
        child: Text(
          '${formatter.format(startDate)} - ${formatter.format(endDate)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// Months slider for trend reports.
class ReportMonthsSelector extends StatelessWidget {
  const ReportMonthsSelector({
    required this.months,
    required this.onMonthsChanged,
    super.key,
  });

  final int months;
  final ValueChanged<int> onMonthsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Text(
          l10n.reportsMonths,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.charcoal,
          ),
        ),
        Expanded(
          child: Slider(
            value: months.toDouble(),
            min: 3,
            max: 24,
            divisions: 7,
            label: '$months',
            onChanged: (value) => onMonthsChanged(value.toInt()),
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$months',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
