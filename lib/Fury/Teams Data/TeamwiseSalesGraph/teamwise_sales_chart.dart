// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class TeamwiseSalesChart extends StatelessWidget {
  final List<String> teamNames;
  final List<double> teamSales;
  final Function(int) onTeamSelected;

  const TeamwiseSalesChart({
    super.key,
    required this.teamNames,
    required this.teamSales,
    required this.onTeamSelected,
  });

  @override
  Widget build(BuildContext context) {
    final maxSales =
        teamSales.isNotEmpty ? teamSales.reduce((a, b) => a > b ? a : b) : 0.0;
    final yAxisInterval = _calculateYAxisInterval(maxSales);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic width and bar width
        final minBarWidth = 36.0;
        final minBarSpace = 16.0;
        final totalBars = teamNames.length;
        final availableWidth = constraints.maxWidth;
        final barWidth =
            totalBars > 0
                ? (availableWidth - (minBarSpace * (totalBars + 1))) / totalBars
                : minBarWidth;
        final finalBarWidth = barWidth.clamp(minBarWidth, 80.0);
        final barSpace = ((availableWidth - (finalBarWidth * totalBars)) /
                (totalBars + 1))
            .clamp(minBarSpace, 60.0);

        return SizedBox(
          height: 480,
          width: availableWidth,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (maxSales * 1.15).ceilToDouble(), // Add 15% padding at top
              minY: 0,
              barTouchData: BarTouchData(
                enabled: true,
                touchCallback: (event, response) {
                  if (response?.spot != null && event is FlTapUpEvent) {
                    onTeamSelected(response!.spot!.touchedBarGroupIndex);
                  }
                },
                touchTooltipData: BarTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipMargin: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '\$${rod.toY.toStringAsFixed(2)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: _buildTitlesData(yAxisInterval),
              gridData: _buildGridData(yAxisInterval),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
                  left: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              barGroups: _buildBarGroups(maxSales, finalBarWidth, barSpace),
            ),
          ),
        );
      },
    );
  }

  double _calculateYAxisInterval(double maxValue) {
    if (maxValue <= 0) return 1;

    // Calculate the raw interval
    final rawInterval = maxValue / 4; // Use 4 intervals for cleaner numbers

    // Find the magnitude of the number
    final magnitude = (log(rawInterval) / ln10).floor();
    final step = pow(10, magnitude).toDouble();

    // Normalize the interval to a number between 1 and 10
    final normalizedInterval = rawInterval / step;

    // Choose a nice round number for the interval
    double niceInterval;
    if (normalizedInterval < 1.5) {
      niceInterval = 1 * step;
    } else if (normalizedInterval < 3) {
      niceInterval = 2 * step;
    } else if (normalizedInterval < 7.5) {
      niceInterval = 5 * step;
    } else {
      niceInterval = 10 * step;
    }

    // Calculate the exact number of steps needed
    final numSteps = (maxValue / niceInterval).ceil();

    // Return the exact interval that will divide the max value evenly
    return maxValue / numSteps;
  }

  FlTitlesData _buildTitlesData(double yAxisInterval) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= teamNames.length) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                teamNames[index],
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
          reservedSize: 80,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: yAxisInterval,
          getTitlesWidget: (value, meta) {
            // Round to 2 decimal places to avoid floating point precision issues
            final roundedValue = (value * 100).round() / 100;
            // Format the value to avoid decimal places if it's a whole number
            final formattedValue =
                roundedValue % 1 == 0
                    ? roundedValue.toInt().toString()
                    : roundedValue.toStringAsFixed(1);
            return Text(
              '\$$formattedValue',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlGridData _buildGridData(double yAxisInterval) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: yAxisInterval,
      getDrawingHorizontalLine:
          (value) => FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    double maxSales,
    double barWidth,
    double barSpace,
  ) {
    return List.generate(teamNames.length, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: barSpace,
        barRods: [
          BarChartRodData(
            toY: teamSales[index],
            width: barWidth,
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.8),
                Colors.lightBlueAccent.withOpacity(0.8),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxSales,
              color: Colors.grey.withOpacity(0.1),
            ),
            rodStackItems: [
              BarChartRodStackItem(0, teamSales[index], Colors.transparent),
            ],
          ),
        ],
      );
    });
  }
}
