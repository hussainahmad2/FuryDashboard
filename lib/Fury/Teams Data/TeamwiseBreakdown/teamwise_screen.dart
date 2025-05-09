// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'teamwise_chart.dart';
import 'teamwise_table.dart';
import 'teamwise_hourly_table.dart';
import 'teamwise_utils.dart';

class TeamwiseScreen extends StatefulWidget {
  const TeamwiseScreen({super.key});

  @override
  _TeamwiseScreenState createState() => _TeamwiseScreenState();
}

class _TeamwiseScreenState extends State<TeamwiseScreen> {
  List<Map<String, dynamic>> data = [];
  List<String> teams = [];
  Map<String, String> displayMode = {};
  Map<String, Map<String, dynamic>?> selectedMember = {};

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final jsonData = await loadTeamwiseJsonData();

    setState(() {
      data = jsonData;
      teams = data.map((e) => e['TEAM'] as String).toSet().toList();
      displayMode = {for (var team in teams) team: 'graph'};
      selectedMember = {for (var team in teams) team: null};
    });
  }

  List<Map<String, dynamic>> getTeamData(String teamName) {
    var teamData = data.where((e) => e['TEAM'] == teamName).toList();

    // Create a map to store aggregated data by agent name
    final Map<String, Map<String, dynamic>> agentData = {};

    // Aggregate data for each agent
    for (var entry in teamData) {
      final agentName =
          entry['AGENT NAME DIALER']?.toString() ?? 'Unknown Agent';
      if (!agentData.containsKey(agentName)) {
        agentData[agentName] = Map<String, dynamic>.from(entry);
      } else {
        // Aggregate numeric values
        final currentData = agentData[agentName]!;
        for (var key in entry.keys) {
          if (entry[key] is num) {
            currentData[key] =
                (currentData[key] as num? ?? 0) + (entry[key] as num? ?? 0);
          }
        }
      }
    }

    // Convert back to list and sort
    var processedData = agentData.values.toList();
    if (displayMode[teamName] == 'graph') {
      processedData.sort(
        (a, b) => (b['TOTAL SALES'] ?? 0).compareTo(a['TOTAL SALES'] ?? 0),
      );
    }

    return processedData;
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < teams.length; i++) ...[
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(color: Colors.white24, width: 1.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            teams[i],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.bar_chart, size: 22),
                                color:
                                    (displayMode[teams[i]] ?? 'graph') ==
                                            'graph'
                                        ? Colors.blue
                                        : Colors.white70,
                                onPressed: () {
                                  setState(() {
                                    displayMode[teams[i]] = 'graph';
                                    selectedMember[teams[i]] = null;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.table_chart, size: 22),
                                color:
                                    (displayMode[teams[i]] ?? 'graph') ==
                                            'table'
                                        ? Colors.blue
                                        : Colors.white70,
                                onPressed: () {
                                  setState(() {
                                    displayMode[teams[i]] = 'table';
                                    selectedMember[teams[i]] = null;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.access_time, size: 22),
                                color:
                                    (displayMode[teams[i]] ?? 'graph') ==
                                            'hourly'
                                        ? Colors.blue
                                        : Colors.white70,
                                onPressed: () {
                                  setState(() {
                                    displayMode[teams[i]] = 'hourly';
                                    selectedMember[teams[i]] = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      (() {
                        final teamData = getTeamData(teams[i]);
                        final currentMode = displayMode[teams[i]] ?? 'graph';
                        if (currentMode == 'graph') {
                          return TeamwiseChart(
                            teamData: teamData,
                            teamName: teams[i],
                            selectedMember: selectedMember,
                            onMemberSelected: (member) {
                              setState(() {
                                selectedMember[teams[i]] = member;
                              });
                            },
                            onCloseDetails: () {
                              setState(() {
                                selectedMember[teams[i]] = null;
                              });
                            },
                          );
                        } else if (currentMode == 'table') {
                          return TeamwiseTable(
                            teamData: teamData,
                            teamName: teams[i],
                          );
                        } else {
                          return TeamwiseHourlyTable(
                            teamData: teamData,
                            teamName: teams[i],
                          );
                        }
                      })(),
                    ],
                  ),
                ),
                if (i < teams.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(
                      color: Colors.pinkAccent,
                      thickness: 2,
                      height: 32,
                    ),
                  ),
              ],
            ],
          ),
        );
  }
}
