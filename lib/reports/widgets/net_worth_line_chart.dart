import 'package:envelope/reports/widgets/report_helpers.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:report_repository/report_repository.dart';

/// Line chart with 3 lines: assets, liabilities, net worth.
class NetWorthLineChart extends StatelessWidget {
  const NetWorthLineChart({required this.snapshots, super.key});

  final List<NetWorthSnapshot> snapshots;

  @override
  Widget build(BuildContext context) {
    if (snapshots.isEmpty) return const SizedBox.shrink();

    final sorted = [...snapshots]
      ..sort((a, b) => a.date.compareTo(b.date));

    final assetSpots = <FlSpot>[];
    final liabilitySpots = <FlSpot>[];
    final netWorthSpots = <FlSpot>[];

    for (var i = 0; i < sorted.length; i++) {
      final s = sorted[i];
      assetSpots.add(FlSpot(i.toDouble(), s.assets / 100));
      liabilitySpots.add(FlSpot(i.toDouble(), s.liabilities / 100));
      netWorthSpots.add(FlSpot(i.toDouble(), s.netWorth / 100));
    }

    final allValues = [
      ...assetSpots.map((s) => s.y),
      ...liabilitySpots.map((s) => s.y),
      ...netWorthSpots.map((s) => s.y),
    ];
    final minY = allValues.isEmpty
        ? 0.0
        : allValues.reduce((a, b) => a < b ? a : b);
    final maxY = allValues.isEmpty
        ? 1.0
        : allValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;

    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minY: minY - range * 0.1,
          maxY: maxY + range * 0.1,
          lineBarsData: [
            _line(assetSpots, AppColors.income),
            _line(liabilitySpots, AppColors.expense),
            _line(netWorthSpots, AppColors.primary),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: sorted.length > 6
                    ? (sorted.length / 6).ceilToDouble()
                    : 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= sorted.length) {
                    return const SizedBox.shrink();
                  }
                  final date = sorted[idx].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${monthAbbreviations[date.month - 1]}'
                      ' ${date.year % 100}',
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
                reservedSize: 55,
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
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      color: color,
      barWidth: 2.5,
      isCurved: true,
      preventCurveOverShooting: true,
      dotData: FlDotData(
        show: spots.length <= 12,
      ),
    );
  }
}
