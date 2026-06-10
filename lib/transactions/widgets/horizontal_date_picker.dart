import 'package:envelope/shared/services/app_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// A horizontal scrollable date picker showing a range of dates.
///
/// Tapping the chevrons at either end opens a full calendar modal for dates
/// outside the horizontal range.
class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.pastDays = 15,
    this.futureDays = 15,
    this.modalPastYears = 10,
    this.modalFutureYears = 10,
    super.key,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int pastDays;
  final int futureDays;
  final int modalPastYears;
  final int modalFutureYears;

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late final ScrollController _scrollController;

  // Width of each date item: 36px circle + 2*8px horizontal padding = 52px.
  static const double _itemWidth = 52;

  @override
  void initState() {
    super.initState();
    final initialOffset = widget.pastDays * _itemWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openModalPicker(BuildContext context) async {
    final today = context.read<AppClock>().now();
    final firstDate = DateTime(today.year - widget.modalPastYears);
    final lastDate = DateTime(today.year + widget.modalFutureYears, 12, 31);
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      widget.onDateSelected(DateTime(picked.year, picked.month, picked.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = context.read<AppClock>().now();
    final startDate = today.subtract(Duration(days: widget.pastDays));
    final dayCount = widget.pastDays + widget.futureDays + 1;

    final selectedOnly = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );
    final rangeStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final rangeEnd = rangeStart.add(Duration(days: dayCount - 1));
    final isOutsideRange =
        selectedOnly.isBefore(rangeStart) || selectedOnly.isAfter(rangeEnd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            DateFormat.yMMMEd().format(selectedOnly),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isOutsideRange
                  ? colorScheme.primary
                  : colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 72,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Pick earlier date',
                onPressed: () => _openModalPicker(context),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: dayCount,
                  itemBuilder: (context, index) {
                    final date = startDate.add(Duration(days: index));
                    final dateOnly = DateTime(date.year, date.month, date.day);
                    final isSelected = dateOnly == selectedOnly;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () => widget.onDateSelected(dateOnly),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E().format(date).toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: isSelected
                                    ? colorScheme.onSurface
                                    : colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.onSurface
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? colorScheme.surface
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Pick later date',
                onPressed: () => _openModalPicker(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
