// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../utils/responsive_utils.dart';
import '../../../utils/orientation_aware_widget.dart';

class TeamwiseSalesTable extends StatelessWidget {
  final List<Map<String, dynamic>> teamData;
  final String teamName;

  const TeamwiseSalesTable({
    super.key,
    required this.teamData,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationAwareWidget(
      builder: (context, isPortrait, isSmallScreen) {
        final horizontalController = ScrollController();
        final verticalController = ScrollController();

        final nameColumnWidth = isSmallScreen ? 100.0 : 150.0;
        final tableHeight = ResponsiveUtils.getResponsiveHeight(
          context,
          portrait: 300,
          landscape: 240,
        );
        final fontSize = ResponsiveUtils.getFontSize(context, base: 15.0);
        final headerFontSize = ResponsiveUtils.getFontSize(context, base: 16.0);
        final rowHeight = isSmallScreen ? 40.0 : 56.0;
        final columnSpacing = isSmallScreen ? 8.0 : 20.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: tableHeight,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Synchronize vertical scrolling between fixed column and scrollable columns
                  if (scrollInfo.depth == 0 &&
                      scrollInfo is ScrollUpdateNotification &&
                      scrollInfo.metrics.axis == Axis.vertical) {
                    verticalController.jumpTo(scrollInfo.metrics.pixels);
                  }
                  return false;
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed Name column
                    SizedBox(
                      width: nameColumnWidth,
                      child: SingleChildScrollView(
                        controller: verticalController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              height: rowHeight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              alignment: Alignment.centerLeft,
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
                            // Data rows
                            ...teamData.map((member) {
                              final isSummary = (member['AGENT NAME DIALER'] ??
                                      '')
                                  .toString()
                                  .toLowerCase()
                                  .contains('summary');
                              return Container(
                                height: rowHeight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                alignment: Alignment.centerLeft,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
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
                            }),
                          ],
                        ),
                      ),
                    ),
                    // Scrollable columns
                    Expanded(
                      child: SingleChildScrollView(
                        controller: horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: DataTable(
                            columnSpacing: columnSpacing,
                            headingRowHeight: rowHeight,
                            dataRowMinHeight: rowHeight,
                            dataRowMaxHeight: rowHeight,
                            headingRowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.black,
                            ),
                            dataRowColor: WidgetStateColor.resolveWith(
                              (states) => Colors.transparent,
                            ),
                            border: TableBorder.all(color: Colors.white24),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Calls',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'DT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'PCB',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Plat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Bills',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Sales',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'AP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Validations',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'HC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Conversion',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Sales Per HC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                            rows:
                                teamData.map((member) {
                                  final isSummary =
                                      (member['AGENT NAME DIALER'] ?? '')
                                          .toString()
                                          .toLowerCase()
                                          .contains('summary');
                                  return DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                      Color?
                                    >((states) => null),
                                    cells: [
                                      DataCell(
                                        Text(
                                          formatNumber(member['TOTAL CALLS']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['DT']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['PCB']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['PLAT']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['TOTAL BILLS']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['TOTAL SALES']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['AP']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          member['Validations']?.toString() ??
                                              '-',
                                          style: TextStyle(
                                            color:
                                                member['Validations'] == 'Valid'
                                                    ? Colors.green
                                                    : member['Validations'] ==
                                                        'Invalid'
                                                    ? Colors.red
                                                    : Colors.orange,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['HC']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['Conversion']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatNumber(member['SALE PER HC']),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight:
                                                isSummary
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper function to format numbers to two decimal places
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
