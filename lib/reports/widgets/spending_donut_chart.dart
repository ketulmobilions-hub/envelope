import 'package:envelope/reports/widgets/report_helpers.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:report_repository/report_repository.dart';

/// Donut chart displaying spending by category.
class SpendingDonutChart extends StatefulWidget {
  const SpendingDonutChart({
    required this.categories,
    this.onCategoryTapped,
    super.key,
  });

  final List<SpendingByCategory> categories;
  final ValueChanged<int>? onCategoryTapped;

  @override
  State<SpendingDonutChart> createState() => _SpendingDonutChartState();
}

class _SpendingDonutChartState extends State<SpendingDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    response == null ||
                    response.touchedSection == null) {
                  _touchedIndex = -1;
                  return;
                }
                _touchedIndex =
                    response.touchedSection!.touchedSectionIndex;
              });
              if (_touchedIndex >= 0) {
                widget.onCategoryTapped?.call(_touchedIndex);
              }
            },
          ),
          sections: _buildSections(),
          centerSpaceRadius: 50,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = widget.categories.fold<int>(
      0,
      (sum, c) => sum + c.amount,
    );
    if (total == 0) return [];

    return List.generate(widget.categories.length, (i) {
      final category = widget.categories[i];
      final isTouched = i == _touchedIndex;
      final percentage = category.amount / total * 100;
      final color = reportCategoryColors[i % reportCategoryColors.length];

      return PieChartSectionData(
        value: category.amount.toDouble(),
        color: color,
        radius: isTouched ? 65 : 55,
        title: '${percentage.toStringAsFixed(0)}%',
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimary,
        ),
      );
    });
  }
}
