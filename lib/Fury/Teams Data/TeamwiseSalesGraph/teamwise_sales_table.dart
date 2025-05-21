// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../utils/responsive_utils.dart';
import '../../../utils/orientation_aware_widget.dart';

class TeamwiseSalesTable extends StatefulWidget {
  final List<Map<String, dynamic>> teamData;
  final String teamName;

  const TeamwiseSalesTable({
    super.key,
    required this.teamData,
    required this.teamName,
  });

  @override
  State<TeamwiseSalesTable> createState() => _TeamwiseSalesTableState();
}

class _TeamwiseSalesTableState extends State<TeamwiseSalesTable> {
  static const double cellWidth = 90.0;
  static const double cellHeight = 42.0;

  @override
  Widget build(BuildContext context) {
    return OrientationAwareWidget(
      builder: (context, isPortrait, isSmallScreen) {
        final fontSize = ResponsiveUtils.getFontSize(context, base: 13.0);
        final headerFontSize = ResponsiveUtils.getFontSize(context, base: 13.0);

        return Container(
          height: 400,
          decoration: const BoxDecoration(color: Colors.black87),
          child: Column(
            children: [
              // Table Content
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed Name Column
                    SizedBox(
                      width: 120,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: cellHeight,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.pinkAccent,
                                    width: 2,
                                  ),
                                  right: BorderSide(color: Colors.white24),
                                ),
                              ),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerFontSize,
                                ),
                              ),
                            ),
                            ...widget.teamData.map((member) {
                              final isSummary = (member['AGENT NAME DIALER'] ??
                                      '')
                                  .toString()
                                  .toLowerCase()
                                  .contains('summary');
                              return Container(
                                height: cellHeight,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.white24),
                                    right: BorderSide(color: Colors.white24),
                                  ),
                                ),
                                child: Text(
                                  member['AGENT NAME DIALER'] ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSize,
                                    fontWeight:
                                        isSummary
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    // Scrollable Data Columns
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Headers
                              Container(
                                height: cellHeight,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.pinkAccent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _buildHeader(
                                      'Calls',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'DT',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'PCB',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'Plat',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'Bills',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'Sales',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'AP',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'Validations',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'HC',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'Conversion',
                                      fontSize: headerFontSize,
                                    ),
                                    _buildHeader(
                                      'Sales Per HC',
                                      fontSize: headerFontSize,
                                    ),
                                  ],
                                ),
                              ),
                              // Data Rows
                              ...widget.teamData.map((member) {
                                final isSummary =
                                    (member['AGENT NAME DIALER'] ?? '')
                                        .toString()
                                        .toLowerCase()
                                        .contains('summary');
                                return Container(
                                  height: cellHeight,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.white24),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildCell(
                                        formatNumber(member['TOTAL CALLS']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['DT']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['PCB']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['PLAT']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['TOTAL BILLS']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['TOTAL SALES']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['AP']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        member['Validations']?.toString() ??
                                            '-',
                                        fontSize: fontSize,
                                        bold: isSummary,
                                        textColor: _getValidationColor(
                                          member['Validations'],
                                        ),
                                      ),
                                      _buildCell(
                                        formatNumber(member['HC']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['Conversion']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                      _buildCell(
                                        formatNumber(member['SALE PER HC']),
                                        fontSize: fontSize,
                                        bold: isSummary,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String text, {double fontSize = 13.0}) {
    return Container(
      width: cellWidth,
      height: cellHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white24)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCell(
    String text, {
    bool bold = false,
    double fontSize = 13.0,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: cellWidth,
      height: cellHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white24)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getValidationColor(dynamic value) {
    if (value == 'Valid') return Colors.green;
    if (value == 'Invalid') return Colors.red;
    return Colors.orange;
  }

  String formatNumber(dynamic value) {
    if (value == null) return '-';
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(2);
    final parsed = double.tryParse(value.toString());
    if (parsed == null) return value.toString();
    if (parsed % 1 == 0) return parsed.toInt().toString();
    return parsed.toStringAsFixed(2);
  }
}
