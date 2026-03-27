import 'package:envelope/reports/widgets/report_helpers.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:report_repository/report_repository.dart';

/// Grouped bar chart (income/expense) with a line overlay (net savings).
class TrendBarChart extends StatelessWidget {
  const TrendBarChart({required this.dataPoints, super.key});

  final List<TrendDataPoint> dataPoints;

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final maxY = dataPoints.fold<double>(0, (max, p) {
      final m = [p.income, p.spending].reduce((a, b) => a > b ? a : b);
      return m / 100 > max ? m / 100 : max;
    });

    return SizedBox(
      height: 280,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY * 1.2,
          barGroups: _buildGroups(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= dataPoints.length) {
                    return const SizedBox.shrink();
                  }
                  final date = dataPoints[idx].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      monthAbbreviations[date.month - 1],
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          gridData: FlGridData(
            horizontalInterval: maxY > 0 ? maxY / 4 : 1,
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildGroups() {
    return List.generate(dataPoints.length, (i) {
      final point = dataPoints[i];
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: point.income / 100,
            color: AppColors.income,
            width: 12,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: point.spending / 100,
            color: AppColors.expense,
            width: 12,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }
}
