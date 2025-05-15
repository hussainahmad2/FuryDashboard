import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:math';

class TeamwiseDailyHistoricSection extends StatefulWidget {
  const TeamwiseDailyHistoricSection({super.key});

  @override
  State<TeamwiseDailyHistoricSection> createState() =>
      _TeamwiseDailyHistoricSectionState();
}

class _TeamwiseDailyHistoricSectionState
    extends State<TeamwiseDailyHistoricSection> {
  Map<String, List<Map<String, dynamic>>> teamwiseDailyData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final rawData = await rootBundle.loadString('assets/historic.csv');
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(
      rawData,
      eol: '\n',
    );
    if (csvTable.isEmpty || csvTable.length < 2) return;

    final headers = csvTable.first.map((e) => e.toString()).toList();
    final rows = csvTable.sublist(1);

    // Group by team
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var row in rows) {
      if (row.isEmpty) continue;
      final map = <String, dynamic>{};
      for (int i = 0; i < headers.length && i < row.length; i++) {
        map[headers[i]] = row[i] is String ? row[i].trim() : row[i];
      }
      final team =
          map['Team']?.toString() ?? map['TEAM']?.toString() ?? 'Unknown';
      grouped.putIfAbsent(team, () => []).add(map);
    }

    // Build a master list of all unique dates (sorted descending)
    Set<String> allDates = {};
    for (var data in grouped.values) {
      for (var row in data) {
        final date = row['Stat Date']?.toString().split(' ')[0] ?? '';
        if (date.isNotEmpty) allDates.add(date);
      }
    }
    final sortedDates = allDates.toList()..sort((a, b) => b.compareTo(a));
    final topDates = sortedDates.take(8).toList();

    // For each team, build a map of date -> aggregated row
    grouped.forEach((team, data) {
      final Map<String, Map<String, dynamic>> dateMap = {};
      for (var row in data) {
        final date = row['Stat Date']?.toString().split(' ')[0] ?? '';
        if (date.isEmpty) continue;
        if (!dateMap.containsKey(date)) {
          dateMap[date] = Map<String, dynamic>.from(row);
        } else {
          // Aggregate numeric fields
          row.forEach((key, value) {
            if (value is num && dateMap[date]![key] is num) {
              dateMap[date]![key] += value;
            } else if (value is String &&
                num.tryParse(value) != null &&
                num.tryParse(dateMap[date]![key]?.toString() ?? '') != null) {
              dateMap[date]![key] =
                  (num.tryParse(dateMap[date]![key].toString()) ?? 0) +
                  (num.tryParse(value) ?? 0);
            }
          });
        }
      }
      // For each of the top 8 dates, get the row or a blank row
      List<Map<String, dynamic>> rowsForDates = [];
      for (final date in topDates) {
        if (dateMap.containsKey(date)) {
          rowsForDates.add(dateMap[date]!);
        } else {
          // Blank row for missing date
          rowsForDates.add({'Stat Date': date});
        }
      }
      grouped[team] = rowsForDates;
    });

    setState(() {
      teamwiseDailyData = grouped;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          teamwiseDailyData.entries.map((entry) {
            final team = entry.key;
            final data = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16,
                  ),
                  child: Text(
                    team,
                    style: const TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Total Calls')),
                      DataColumn(label: Text('Sales')),
                      DataColumn(label: Text('AP')),
                      // Add more columns as needed
                    ],
                    rows:
                        data.map((row) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(row['Stat Date']?.toString() ?? '-'),
                              ),
                              DataCell(
                                Text(row['Total_Calls']?.toString() ?? '-'),
                              ),
                              DataCell(Text(row['Sales']?.toString() ?? '-')),
                              DataCell(
                                Text(row['T_Premium_E']?.toString() ?? '-'),
                              ),
                              // Add more cells as needed
                            ],
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
    );
  }
}
