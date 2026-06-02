import 'package:envelope/reports/widgets/report_helpers.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:report_repository/report_repository.dart';

/// Line chart with 3 lines: assets, liabilities, net worth.
///
/// Features gradient fill under the net worth line, touch tooltips showing
/// all three values, compact Y-axis labels, and subtle grid lines.
class NetWorthLineChart extends StatefulWidget {
  const NetWorthLineChart({required this.snapshots, super.key});

  final List<NetWorthSnapshot> snapshots;

  @override
  State<NetWorthLineChart> createState() => _NetWorthLineChartState();
}

class _NetWorthLineChartState extends State<NetWorthLineChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.snapshots.isEmpty) return const SizedBox.shrink();

    final symbol = currencySymbol(context);
    final sorted = [...widget.snapshots]
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
    final minY = allValues.reduce((a, b) => a < b ? a : b);
    final maxY = allValues.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY == 0 ? 1.0 : maxY - minY;
    final paddedMin = minY - range * 0.15;
    final paddedMax = maxY + range * 0.15;

    // Aim for ~4 horizontal grid lines.
    final yInterval = _niceInterval((paddedMax - paddedMin) / 4);

    return SizedBox(
      height: 300,
      child: LineChart(
        duration: const Duration(milliseconds: 300),
        LineChartData(
          minY: paddedMin,
          maxY: paddedMax,
          clipData: const FlClipData.all(),

          // ── Touch ────────────────────────────────────────────────────────
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchCallback: (event, response) {
              setState(() {
                _touchedIndex = response?.lineBarSpots?.firstOrNull?.spotIndex;
              });
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 10,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipColor: (_) =>
                  AppColors.charcoal.withValues(alpha: 0.85),
              getTooltipItems: (spots) {
                // spots order matches lineBarsData order:
                // 0 = net worth, 1 = assets, 2 = liabilities
                final idx = spots.first.spotIndex;
                if (idx < 0 || idx >= sorted.length) return [];
                final snap = sorted[idx];
                final date = snap.date;
                final dateLabel =
                    '${monthAbbreviations[date.month - 1]} ${date.year}';

                return [
                  LineTooltipItem(
                    '$dateLabel\n',
                    const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Net worth  ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      TextSpan(
                        text: _formatCurrency(spots[0].y, symbol),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  LineTooltipItem(
                    '',
                    const TextStyle(),
                    children: [
                      TextSpan(
                        text: 'Assets  ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      TextSpan(
                        text: _formatCurrency(spots[1].y, symbol),
                        style: TextStyle(
                          color: AppColors.income,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  LineTooltipItem(
                    '',
                    const TextStyle(),
                    children: [
                      TextSpan(
                        text: 'Liabilities  ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      TextSpan(
                        text: _formatCurrency(spots[2].y, symbol),
                        style: TextStyle(
                          color: AppColors.expense,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ];
              },
            ),
          ),

          // ── Grid ─────────────────────────────────────────────────────────
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: Color(0x18000000),
              strokeWidth: 1,
            ),
          ),

          // ── Axes ─────────────────────────────────────────────────────────
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
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
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${monthAbbreviations[date.month - 1]} '
                      '\'${(date.year % 100).toString().padLeft(2, '0')}',
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
                reservedSize: 60,
                interval: yInterval,
                getTitlesWidget: (value, meta) => Text(
                  _compactCurrency(value, symbol),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ),
          ),

          borderData: FlBorderData(show: false),

          // ── Lines ────────────────────────────────────────────────────────
          lineBarsData: [
            // Net worth — thicker, gradient fill
            _buildLine(
              spots: netWorthSpots,
              color: AppColors.primary,
              barWidth: 3,
              fillColor: AppColors.primary,
              touchedIndex: _touchedIndex,
            ),
            // Assets
            _buildLine(
              spots: assetSpots,
              color: AppColors.income,
              barWidth: 2,
              touchedIndex: _touchedIndex,
            ),
            // Liabilities
            _buildLine(
              spots: liabilitySpots,
              color: AppColors.expense,
              barWidth: 2,
              touchedIndex: _touchedIndex,
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildLine({
    required List<FlSpot> spots,
    required Color color,
    required double barWidth,
    Color? fillColor,
    int? touchedIndex,
  }) {
    return LineChartBarData(
      spots: spots,
      color: color,
      barWidth: barWidth,
      isCurved: true,
      curveSmoothness: 0.35,
      preventCurveOverShooting: true,
      dotData: FlDotData(
        show: touchedIndex != null || spots.length <= 8,
        getDotPainter: (spot, percent, bar, index) {
          final isTouched = index == touchedIndex;
          return FlDotCirclePainter(
            radius: isTouched ? 6 : 3,
            color: isTouched ? Colors.white : color,
            strokeWidth: isTouched ? 2.5 : 0,
            strokeColor: isTouched ? color : Colors.transparent,
          );
        },
      ),
      belowBarData: fillColor == null
          ? BarAreaData(show: false)
          : BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  fillColor.withValues(alpha: 0.25),
                  fillColor.withValues(alpha: 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
    );
  }
}

/// Formats a value as compact currency (e.g. ₹1.2K, $1.5M) using [symbol].
String _formatCurrency(double value, String symbol) {
  final prefix = value < 0 ? '-$symbol' : symbol;
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(abs / 1000000).toStringAsFixed(1)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(abs / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${abs.toStringAsFixed(0)}';
}

/// Compact currency without sign for axis labels.
String _compactCurrency(double value, String symbol) =>
    _formatCurrency(value, symbol);

/// Returns a "nice" interval for grid lines — rounded to a power of 10.
double _niceInterval(double raw) {
  if (raw <= 0) return 1;
  final magnitude = (raw).abs();
  if (magnitude >= 1000000) return (raw / 1000000).ceilToDouble() * 1000000;
  if (magnitude >= 100000) return (raw / 100000).ceilToDouble() * 100000;
  if (magnitude >= 10000) return (raw / 10000).ceilToDouble() * 10000;
  if (magnitude >= 1000) return (raw / 1000).ceilToDouble() * 1000;
  if (magnitude >= 100) return (raw / 100).ceilToDouble() * 100;
  if (magnitude >= 10) return (raw / 10).ceilToDouble() * 10;
  return raw.ceilToDouble().clamp(1, double.infinity);
}
