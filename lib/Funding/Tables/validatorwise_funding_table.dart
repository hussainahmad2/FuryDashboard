// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';

class ValidatorsFundingTable extends StatelessWidget {
  const ValidatorsFundingTable({super.key});

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
                      image: AssetImage("assets/funding/f2.jpg"),
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
                        _buildValidatorColumn(),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _buildDataTable(),
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

  Widget _buildValidatorColumn() {
    List<String> validators = ['Alice', 'Bob', 'Charlie', 'Diana'];

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.orange, width: 2)),
          ),
          child: _tableHeader("Validator"),
        ),
        ...validators.map((v) => _tableCell(v)).toList(),
        _tableCell("Grand\nSummary", bold: true),
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
      ['900', '180', '200', '400', '1680', '\$75', '60%', '12%', '13%', '25%'],
      ['350', '60', '90', '130', '630', '\$78', '56%', '11%', '14%', '26%'],
      ['320', '120', '80', '110', '630', '\$73', '51%', '19%', '13%', '27%'],
      ['220', '100', '60', '90', '470', '\$76', '57%', '17%', '11%', '25%'],
    ];

    List<String> totals = [
      '1790',
      '460',
      '430',
      '730',
      '3410',
      '\$76',
      '56%',
      '15%',
      '13%',
      '26%',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.orange, width: 2)),
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
