// ignore_for_file: unnecessary_to_list_in_spreads, deprecated_member_use

import 'package:flutter/material.dart';

class TeamWiseFundingTable extends StatelessWidget {
  const TeamWiseFundingTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Heading image
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/funding/f1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Scrollable Table
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTeamColumn(), // Static left column
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _buildDataTable(), // Scrollable table
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const double cellWidth = 90;
  static const double cellHeight = 42;

  Widget _buildTeamColumn() {
    List<String> teams = ['Berlin', 'Tokyo', 'Zulu', 'Excalibur'];

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.pinkAccent, width: 2)),
          ),
          child: _tableHeader("Team"),
        ),
        ...teams.map((team) => _tableCell(team)).toList(),
        _tableCell("Grand\nSummary", bold: true, height: cellHeight),
      ],
    );
  }

  Widget _buildDataTable() {
    List<String> headers = [
      'Funded',
      'Pending',
      'DNF',
      'CB',
      'Total',
      'Avg MP',
      'Funded %',
      'Pending %',
      'DNF %',
      'CB %',
    ];

    List<List<String>> rows = [
      ['1039', '280', '236', '417', '1972', '\$79', '61%', '14%', '14%', '25%'],
      ['311', '76', '88', '139', '614', '\$78', '58%', '12%', '16%', '26%'],
      ['319', '101', '74', '136', '630', '\$74', '60%', '16%', '14%', '26%'],
      ['196', '90', '51', '83', '420', '\$78', '59%', '21%', '12%', '25%'],
    ];

    List<String> totals = [
      '1865',
      '547',
      '449',
      '775',
      '3636',
      '\$78',
      '60%',
      '15%',
      '15%',
      '25%',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.pinkAccent,
                width: 2,
              ), // Yellow line
            ),
          ),
          child: Row(children: headers.map((h) => _tableHeader(h)).toList()),
        ),
        ...rows.map((row) {
          return Row(
            children:
                row.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final val = entry.value;
                  return _tableCell(
                    val,
                    bg: _getCellColor(idx),
                    textColor: _getTextColor(idx),
                  );
                }).toList(),
          );
        }).toList(),
        Row(
          children:
              totals.asMap().entries.map((entry) {
                final idx = entry.key;
                final val = entry.value;
                return _tableCell(
                  val,
                  bold: true,
                  bg: _getCellColor(idx),
                  textColor: _getTextColor(idx),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _tableHeader(String text) {
    return Container(
      width: cellWidth,
      height: cellHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.black87,
        border: Border(
          bottom: BorderSide(color: Colors.white30),
          right: BorderSide(color: Colors.white30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableCell(
    String text, {
    bool bold = false,
    double height = cellHeight,
    Color? bg,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: cellWidth,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg ?? Colors.black.withOpacity(0.6),
        border: const Border(
          bottom: BorderSide(color: Colors.white24),
          right: BorderSide(color: Colors.white24),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color? _getCellColor(int index) {
    if (index == 0) return Colors.green.withOpacity(0.2);
    if (index == 6) return Colors.redAccent;
    return null;
  }

  Color _getTextColor(int index) {
    if (index == 2 || index == 9) return Colors.redAccent;
    return Colors.white;
  }
}
