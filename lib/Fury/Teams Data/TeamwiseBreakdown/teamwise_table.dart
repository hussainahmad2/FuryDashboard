// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TeamwiseTable extends StatelessWidget {
  final List<Map<String, dynamic>> teamData;
  final String teamName;
  static const List<String> juniorTeams = [
    'Vipers',
    'Gunslingers',
    'Omega',
    'The Santiagos',
  ];

  const TeamwiseTable({
    super.key,
    required this.teamData,
    required this.teamName,
  });

  bool get showJuniorMetrics {
    return juniorTeams.any(
      (team) => teamName.toLowerCase().contains(team.toLowerCase()),
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

  @override
  Widget build(BuildContext context) {
    final horizontalController = ScrollController();
    final verticalController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            'Teamwise Breakdown Table',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 400,
          child: SingleChildScrollView(
            controller: verticalController,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      columns: [
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
                            'Sale Per HC',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (showJuniorMetrics) ...[
                          DataColumn(
                            label: Text(
                              'Jr PCB TRX',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jr. LIVE TRX',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jr PCB Trx To ZULU Cam',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jr LIVE Trx To ZULU CAM',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jr PCB Trx To JVoice Cam',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jr LIVE Trx To VOICE CAM',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jr to Sr Sales',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Sr Closed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Trx / Cal',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Sale/ Conv',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ],
                      rows:
                          teamData.map((member) {
                            final isSummary = (member['AGENT NAME DIALER'] ??
                                    '')
                                .toString()
                                .toLowerCase()
                                .contains('summary');
                            // Calculate HC, Conversion, Sale Per HC
                            final hc = teamData.length;
                            final totalSales =
                                double.tryParse(
                                  member['TOTAL SALES']?.toString() ?? '',
                                ) ??
                                0.0;
                            final totalBills =
                                double.tryParse(
                                  member['TOTAL BILLS']?.toString() ?? '',
                                ) ??
                                0.0;
                            final conversion =
                                (totalBills > 0)
                                    ? (totalSales / totalBills) * 100
                                    : 0.0;
                            final salePerHc =
                                (hc > 0) ? (totalSales / hc) : 0.0;
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
                                    formatNumber(member['DIRECT CALLS']),
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
                                    formatNumber(member['PCB CALLS']),
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
                                    formatNumber(member['VERIFIED CALLS']),
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
                                    formatNumber(hc),
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
                                    formatNumber(conversion),
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
                                    formatNumber(salePerHc),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          isSummary
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (showJuniorMetrics) ...[
                                  DataCell(
                                    Text(
                                      '${member['TRX MADE'] ?? 0}',
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
                                      '${member['LIVE TRX MADE'] ?? 0}',
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
                                      '${member['JC TRX TO ZULU CAM'] ?? 0}',
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
                                      '${member['LIVE ZULU CAM TRX'] ?? 0}',
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
                                      '${member['JC TRX TO JVOICE'] ?? 0}',
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
                                      '${member['LIVE VOICE CAM TRX'] ?? 0}',
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
                                      '${member['JR SALES'] ?? 0}',
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
                                      '${member['DIRECT SALES'] ?? 0}',
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
                                      '${((member['TRX MADE'] ?? 0) / (member['TOTAL CALLS'] ?? 1) * 100).toStringAsFixed(2)}%',
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
                                      '${((member['JR SALES'] ?? 0) / (member['TRX MADE'] ?? 1) * 100).toStringAsFixed(2)}%',
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
}
