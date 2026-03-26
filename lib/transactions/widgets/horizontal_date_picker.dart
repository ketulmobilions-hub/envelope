import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A horizontal scrollable date picker showing a week of dates.
class HorizontalDatePicker extends StatelessWidget {
  const HorizontalDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.dayCount = 14,
    super.key,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final int dayCount;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    // Start from 7 days before today.
    final startDate = today.subtract(const Duration(days: 7));

    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: dayCount,
        itemBuilder: (context, index) {
          final date = startDate.add(Duration(days: index));
          final dateOnly = DateTime(date.year, date.month, date.day);
          final selectedOnly = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );
          final isSelected = dateOnly == selectedOnly;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onDateSelected(dateOnly),
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
                          ? AppColors.charcoal
                          : AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.charcoal
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.onPrimary
                            : AppColors.charcoal,
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
