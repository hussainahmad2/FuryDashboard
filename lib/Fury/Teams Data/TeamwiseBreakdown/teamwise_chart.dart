// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'teamwise_utils.dart';
import '../../../utils/responsive_utils.dart';
import '../../../utils/orientation_aware_widget.dart';

class TeamwiseChart extends StatelessWidget {
  final List<Map<String, dynamic>> teamData;
  final String teamName;
  final Map<String, Map<String, dynamic>?> selectedMember;
  final Function(Map<String, dynamic>) onMemberSelected;
  final Function() onCloseDetails;

  const TeamwiseChart({
    super.key,
    required this.teamData,
    required this.teamName,
    required this.selectedMember,
    required this.onMemberSelected,
    required this.onCloseDetails,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationAwareWidget(
      builder: (context, isPortrait, isSmallScreen) {
        final maxSales =
            teamData
                .fold(
                  0,
                  (max, e) =>
                      (e['TOTAL SALES'] ?? 0) > max
                          ? (e['TOTAL SALES'] ?? 0)
                          : max,
                )
                .toDouble();
        final chartMaxY = maxSales > 0 ? _getNiceMaxY(maxSales) : 1.0;
        final yAxisInterval = _calculateYAxisInterval(chartMaxY);
        final chartHeight = ResponsiveUtils.getResponsiveHeight(
          context,
          portrait: 320,
          landscape: 240,
        );

        final size = MediaQuery.of(context).size;

        final List<double> yLabels = [];
        for (double y = 0; y <= chartMaxY; y += yAxisInterval) {
          double rounded = double.parse(y.toStringAsFixed(2));
          if (!yLabels.contains(rounded)) {
            yLabels.add(rounded);
          }
        }

        final bool allZero = teamData.every(
          (e) => (e['TOTAL SALES'] ?? 0) == 0,
        );

        if (allZero) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const Text(
              'No sales data available',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        }

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(isSmallScreen ? 12 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Team Member Sales',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: chartHeight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: max(
                          MediaQuery.of(context).size.width - 40,
                          teamData.length * (isSmallScreen ? 80 : 100),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final barWidth = (constraints.maxWidth /
                                    (teamData.length * 2))
                                .clamp(
                                  isSmallScreen ? 12.0 : 16.0,
                                  isSmallScreen ? 24.0 : 32.0,
                                );
                            return BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: chartMaxY,
                                minY: 0,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipRoundedRadius: 8,
                                    getTooltipItem: (
                                      group,
                                      groupIndex,
                                      rod,
                                      rodIndex,
                                    ) {
                                      return BarTooltipItem(
                                        rod.toY.toStringAsFixed(2),
                                        const TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                  ),
                                  touchCallback: (event, response) {
                                    if (response?.spot != null &&
                                        event is FlTapUpEvent) {
                                      onMemberSelected(
                                        teamData[response!
                                            .spot!
                                            .touchedBarGroupIndex],
                                      );
                                    }
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  leftTitles: AxisTitles(
                                    axisNameWidget: Padding(
                                      padding: EdgeInsets.only(
                                        right: isSmallScreen ? 12.0 : 18.0,
                                      ),
                                      child: const Text(
                                        'Sales',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: isSmallScreen ? 36 : 44,
                                      getTitlesWidget: (value, meta) {
                                        double rounded = double.parse(
                                          value.toStringAsFixed(2),
                                        );
                                        if (yLabels.contains(rounded)) {
                                          return Text(
                                            rounded.toInt().toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: isSmallScreen ? 10 : 12,
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: Padding(
                                      padding: EdgeInsets.only(
                                        top: isSmallScreen ? 24.0 : 32.0,
                                      ),
                                      child: const Text(
                                        'Agent',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: isSmallScreen ? 50 : 70,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index >= 0 &&
                                            index < teamData.length) {
                                          final name =
                                              teamData[index]['AGENT NAME DIALER'] ??
                                              '';
                                          return Transform.rotate(
                                            angle: -0.785,
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              width: isSmallScreen ? 50 : 70,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: isSmallScreen ? 12 : 18,
                                                ),
                                                child: Text(
                                                  formatAgentName(
                                                    name.toString(),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        isSmallScreen ? 9 : 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval: yAxisInterval,
                                  verticalInterval: 1,
                                  getDrawingHorizontalLine:
                                      (value) => FlLine(
                                        color: Colors.white.withOpacity(0.15),
                                        strokeWidth: 1,
                                      ),
                                  getDrawingVerticalLine:
                                      (value) => FlLine(
                                        color: Colors.white.withOpacity(0.10),
                                        strokeWidth: 1,
                                      ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: const Border(
                                    left: BorderSide(
                                      color: Colors.white24,
                                      width: 2,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.white24,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                barGroups:
                                    teamData.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final member = entry.value;
                                      final sales =
                                          (member['TOTAL SALES'] ?? 0)
                                              .toDouble();
                                      return BarChartGroupData(
                                        x: index,
                                        barsSpace: 8,
                                        barRods: [
                                          BarChartRodData(
                                            toY: sales,
                                            width: barWidth,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blueAccent.shade700,
                                                Colors.lightBlueAccent.shade200,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.white24,
                                              width: 1,
                                            ),
                                            backDrawRodData:
                                                BackgroundBarChartRodData(
                                                  show: true,
                                                  toY: chartMaxY,
                                                  color: Colors.white10,
                                                ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                extraLinesData: ExtraLinesData(
                                  horizontalLines: [
                                    HorizontalLine(
                                      y: maxSales,
                                      color: Colors.greenAccent.withOpacity(
                                        0.3,
                                      ),
                                      strokeWidth: 2,
                                      dashArray: [8, 4],
                                      label: HorizontalLineLabel(
                                        show: true,
                                        alignment: Alignment.topRight,
                                        style: const TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 11,
                                        ),
                                        labelResolver: (_) => 'Max',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              swapAnimationDuration: const Duration(
                                milliseconds: 500,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 10),
                  Text(
                    'Tap any bar to view details',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (selectedMember[teamName] != null)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: _buildMemberDetailsPopup(
                      selectedMember[teamName]!,
                      isSmallScreen,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  double _calculateYAxisInterval(double maxValue) {
    if (maxValue <= 0) return 1;
    final rawInterval = maxValue / 4;
    final magnitude = rawInterval > 0 ? (log(rawInterval) / ln10).floor() : 0;
    final step = pow(10, magnitude).toDouble();
    final normalizedInterval = rawInterval / step;
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
    return niceInterval;
  }

  double _getNiceMaxY(double maxValue) {
    if (maxValue <= 5) return 5;
    final magnitude = pow(10, (log(maxValue) / ln10).floor());
    final normalized = maxValue / magnitude;
    double niceMax;
    if (normalized <= 1) {
      niceMax = (1 * magnitude).toDouble();
    } else if (normalized <= 2) {
      niceMax = (2 * magnitude).toDouble();
    } else if (normalized <= 5) {
      niceMax = (5 * magnitude).toDouble();
    } else {
      niceMax = (10 * magnitude).toDouble();
    }
    return niceMax;
  }

  Widget _buildMemberDetailsPopup(
    Map<String, dynamic> member,
    bool isSmallScreen,
  ) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900.withOpacity(0.98),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: isSmallScreen ? 280 : 320,
          maxHeight: isSmallScreen ? 400 : 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blueAccent.shade100,
                  size: isSmallScreen ? 24 : 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    member['AGENT NAME DIALER'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: onCloseDetails,
                  tooltip: 'Close',
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 24, thickness: 1),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      Icons.attach_money,
                      'Sales',
                      '${member['TOTAL SALES'] ?? 0}',
                      isSmallScreen,
                    ),
                    _buildDetailRow(
                      Icons.phone,
                      'Calls',
                      '${member['TOTAL CALLS'] ?? 0}',
                      isSmallScreen,
                    ),
                    _buildDetailRow(
                      Icons.receipt,
                      'Bills',
                      '${member['TOTAL BILLS'] ?? 0}',
                      isSmallScreen,
                    ),
                    _buildDetailRow(
                      Icons.monetization_on,
                      'AP',
                      '${member['AP'] ?? 0}',
                      isSmallScreen,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.amber,
                          size: isSmallScreen ? 16 : 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'This agent is a valuable team member!',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: isSmallScreen ? 12 : 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: isSmallScreen ? 18 : 20),
          SizedBox(width: isSmallScreen ? 8 : 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
