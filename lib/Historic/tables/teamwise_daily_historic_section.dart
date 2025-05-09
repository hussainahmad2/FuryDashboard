import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

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

    // Sort each team's data by date descending and take 8 entries
    grouped.forEach((team, data) {
      data.sort(
        (a, b) => (b['Stat Date'] ?? '').compareTo(a['Stat Date'] ?? ''),
      );
      grouped[team] = data.take(8).toList();
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
