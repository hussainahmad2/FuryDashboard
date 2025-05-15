// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

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
    final horizontalController = ScrollController();
    final verticalController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 400,
          child: SingleChildScrollView(
            controller: verticalController,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed Name column
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        child: const Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ...teamData.map((member) {
                        final isSummary = (member['AGENT NAME DIALER'] ?? '')
                            .toString()
                            .toLowerCase()
                            .contains('summary');
                        return Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                // Scrollable columns
                Expanded(
                  child: SingleChildScrollView(
                    controller: horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowHeight: 56,
                      dataRowMinHeight: 56,
                      dataRowMaxHeight: 56,
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
                            final isSummary = (member['AGENT NAME DIALER'] ??
                                    '')
                                .toString()
                                .toLowerCase()
                                .contains('summary');
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                (states) => null,
                              ),
                              cells: [
                                DataCell(
                                  Text(
                                    formatNumber(member['TOTAL CALLS']),
                                    style: TextStyle(
                                      color: Colors.white,
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
                                      fontWeight:
                                          isSummary
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    member['Validations']?.toString() ?? '-',
                                    style: TextStyle(
                                      color:
                                          member['Validations'] == 'Valid'
                                              ? Colors.green
                                              : member['Validations'] ==
                                                  'Invalid'
                                              ? Colors.red
                                              : Colors.orange,
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
              ],
            ),
          ),
        ),
      ],
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
