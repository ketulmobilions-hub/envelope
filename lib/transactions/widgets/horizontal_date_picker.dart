import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A horizontal scrollable date picker showing a range of dates.
class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.pastDays = 30,
    this.futureDays = 7,
    super.key,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int pastDays;
  final int futureDays;

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late final ScrollController _scrollController;

  // Width of each date item: 36px circle + 2*4px horizontal padding = 44px.
  static const double _itemWidth = 44;

  @override
  void initState() {
    super.initState();
    // Scroll to show today centred in the list.
    final initialOffset = widget.pastDays * _itemWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: widget.pastDays));
    final dayCount = widget.pastDays + widget.futureDays + 1;

    return SizedBox(
      height: 72,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: dayCount,
        itemBuilder: (context, index) {
          final date = startDate.add(Duration(days: index));
          final dateOnly = DateTime(date.year, date.month, date.day);
          final selectedOnly = DateTime(
            widget.selectedDate.year,
            widget.selectedDate.month,
            widget.selectedDate.day,
          );
          final isSelected = dateOnly == selectedOnly;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
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
    );
  }
}
