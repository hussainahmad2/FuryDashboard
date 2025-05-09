// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TeamwiseSalesTable extends StatelessWidget {
  final List<String> teamNames;
  final List<double> teamSales;

  const TeamwiseSalesTable({
    super.key,
    required this.teamNames,
    required this.teamSales,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: WidgetStateProperty.resolveWith(
          (states) => Colors.blueAccent.withOpacity(0.2),
        ),
        columns: const [
          DataColumn(label: Text('Team Name', style: _headerTextStyle)),
          DataColumn(label: Text('Total Sales', style: _headerTextStyle)),
        ],
        rows: _buildDataRows(),
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    return List.generate(teamNames.length, (index) {
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
          (states) => index % 2 == 0 ? Colors.grey[900] : Colors.grey[800],
        ),
        cells: [
          DataCell(Text(teamNames[index], style: _cellTextStyle)),
          DataCell(
            Text(
              '\$${teamSales[index].toStringAsFixed(2)}',
              style: _cellTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    });
  }

  static const _headerTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const _cellTextStyle = TextStyle(color: Colors.white);
}
