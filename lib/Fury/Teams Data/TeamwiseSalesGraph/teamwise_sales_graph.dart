// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'teamwise_sales_table.dart';

class TeamSalesScreen extends StatefulWidget {
  const TeamSalesScreen({super.key});

  @override
  State<TeamSalesScreen> createState() => _TeamSalesScreenState();
}

class _TeamSalesScreenState extends State<TeamSalesScreen> {
  List<_TeamSalesData> teamSales = [];
  bool showGraph = true;
  final Map<String, double> salesMap = {};
  final Map<String, double> billsMap = {};
  final Map<String, Set<String>> agentSetMap = {};
  final Map<String, double> dtMap = {};
  final Map<String, double> pcbMap = {};
  final Map<String, double> platMap = {};
  final Map<String, double> apMap = {};
  final Map<String, dynamic> validationsMap = {};

  @override
  void initState() {
    super.initState();
    loadTeamSales();
  }

  Future<void> loadTeamSales() async {
    final String jsonString = await rootBundle.loadString(
      'assets/comb_df_2025-05-13.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);

    // Sum sales for each team and collect manager, agent count, user groups, and total bills
    final Map<String, String> managerMap = {};
    final Map<String, Set<String>> userGroupMap = {};
    for (final entry in jsonData) {
      final team = entry['TEAM']?.toString() ?? 'Unknown';
      final sales =
          (entry['TOTAL SALES'] is num) ? entry['TOTAL SALES'].toDouble() : 0.0;
      salesMap[team] = (salesMap[team] ?? 0) + sales;
      if (entry['MANAGER'] != null && (managerMap[team]?.isEmpty ?? true)) {
        managerMap[team] = entry['MANAGER'].toString();
      }
      userGroupMap.putIfAbsent(team, () => <String>{});
      if (entry['USER GROUP'] != null) {
        userGroupMap[team]!.add(entry['USER GROUP'].toString());
      }
      agentSetMap.putIfAbsent(team, () => <String>{});
      if (entry['AGENT NAME DIALER'] != null) {
        agentSetMap[team]!.add(entry['AGENT NAME DIALER'].toString());
      }
      final bills =
          (entry['TOTAL BILLS'] is num) ? entry['TOTAL BILLS'].toDouble() : 0.0;
      billsMap[team] = (billsMap[team] ?? 0) + bills;
      final dt =
          (entry['DIRECT CALLS'] is num)
              ? entry['DIRECT CALLS'].toDouble()
              : 0.0;
      dtMap[team] = (dtMap[team] ?? 0) + dt;
      final pcb =
          (entry['PCB SALES'] is num) ? entry['PCB SALES'].toDouble() : 0.0;
      pcbMap[team] = (pcbMap[team] ?? 0) + pcb;
      final plat =
          (entry['VERIFIED CALLS'] is num)
              ? entry['VERIFIED CALLS'].toDouble()
              : 0.0;
      platMap[team] = (platMap[team] ?? 0) + plat;
      double ap = 0.0;
      if (entry['DIRECT AP'] is num) {
        ap = (entry['DIRECT AP'] as num).toDouble();
      } else if (entry['DIRECT AP'] is String) {
        ap = double.tryParse(entry['DIRECT AP']) ?? 0.0;
      }
      apMap[team] = (apMap[team] ?? 0) + ap;
      if (!validationsMap.containsKey(team)) {
        validationsMap[team] = [];
      }
      validationsMap[team].add(entry['Validations']);
    }

    // Assign a color/gradient to each team
    final List<List<Color>> gradients = [
      [Color(0xFF00C6FB), Color(0xFF43E97B)],
      [Color(0xFFFFB75E), Color(0xFFED8F03)],
      [Color(0xFFFA8BFF), Color(0xFF2BD2FF)],
      [Color(0xFFF7971E), Color(0xFFFFD200)],
      [Color(0xFF21D4FD), Color(0xFFB721FF)],
      [Color(0xFF3CA55C), Color(0xFFB5AC49)],
      [Color(0xFF0099F7), Color(0xFFF11712)],
      [Color(0xFF43C6AC), Color(0xFF191654)],
      [Color(0xFF667EEA), Color(0xFF764BA2)],
      [Color(0xFF8BC34A), Color(0xFF00BCD4)],
    ];
    int colorIdx = 0;
    final Map<String, List<Color>> teamGradients = {};
    for (final team in salesMap.keys) {
      teamGradients[team] = gradients[colorIdx % gradients.length];
      colorIdx++;
    }

    setState(() {
      teamSales =
          salesMap.entries
              .map(
                (e) => _TeamSalesData(
                  e.key,
                  e.value,
                  teamGradients[e.key]!,
                  managerMap[e.key] ?? 'N/A',
                  agentSetMap[e.key]?.length ?? 0,
                  userGroupMap[e.key] ?? <String>{},
                ),
              )
              .toList()
            ..sort((a, b) => b.sales.compareTo(a.sales));
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxValue =
        teamSales.isNotEmpty ? teamSales.map((e) => e.sales).reduce(max) : 1.0;
    final barHeight = 22.0;

    // Prepare teamData for the table here so all maps are in scope
    final List<Map<String, dynamic>> teamData =
        teamSales.map((d) {
          final team = d.team;
          final totalSales = salesMap[team] ?? 0.0;
          final totalBills = billsMap[team] ?? 0.0;
          final hc = agentSetMap[team]?.length ?? 0;
          final conversion =
              (totalBills > 0) ? (totalSales / totalBills) * 100 : 0.0;
          final salesPerHc = (hc > 0) ? (totalSales / hc) : 0.0;
          final dt = dtMap[team] ?? 0.0;
          final pcb = pcbMap[team] ?? 0.0;
          final plat = platMap[team] ?? 0.0;
          final ap = apMap[team] ?? 0.0;
          String validations = '-';
          if (validationsMap[team] is List &&
              (validationsMap[team] as List).isNotEmpty) {
            final vals = validationsMap[team] as List;
            final freq = <dynamic, int>{};
            for (var v in vals) {
              if (v == null) continue;
              freq[v] = (freq[v] ?? 0) + 1;
            }
            if (freq.isNotEmpty) {
              validations =
                  freq.entries
                      .reduce((a, b) => a.value >= b.value ? a : b)
                      .key
                      .toString();
            }
          }
          return {
            'AGENT NAME DIALER': team,
            'TOTAL CALLS': d.sales,
            'DT': dt,
            'PCB': pcb,
            'PLAT': plat,
            'AP': ap,
            'Validations': validations,
            'HC': hc,
            'Conversion': conversion,
            'SALE PER HC': salesPerHc,
            'TOTAL SALES': totalSales,
            'TOTAL BILLS': totalBills,
          };
        }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child:
            teamSales.isEmpty
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Toggle Buttons
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          _ToggleButton(
                            text: 'Graph',
                            selected: showGraph,
                            onTap: () => setState(() => showGraph = true),
                          ),
                          const SizedBox(width: 8),
                          _ToggleButton(
                            text: 'Table',
                            selected: !showGraph,
                            onTap: () => setState(() => showGraph = false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      showGraph
                          ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...teamSales.map((d) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.grey[900],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                24.0,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient: LinearGradient(
                                                            colors: d.gradient,
                                                            begin:
                                                                Alignment
                                                                    .centerLeft,
                                                            end:
                                                                Alignment
                                                                    .centerRight,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        d.team,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    'Team Leader:  ${d.manager}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Total Sales:  ${d.sales.toStringAsFixed(0)}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'No. of Agents:  ${d.agentCount}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'User Groups:  ${d.userGroups.isNotEmpty ? d.userGroups.join(", ") : "N/A"}',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Dot and label
                                        Container(
                                          width: 10,
                                          height: 10,
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: d.gradient,
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            d.team,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        // Bar
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              height: barHeight,
                                              width:
                                                  maxValue == 0
                                                      ? 0
                                                      : (d.sales / maxValue) *
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                gradient: LinearGradient(
                                                  colors: d.gradient,
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: d.gradient.first
                                                        .withOpacity(0.13),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Value
                                        SizedBox(
                                          width: 32,
                                          child: Text(
                                            d.sales.toStringAsFixed(0),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          )
                          : TeamwiseSalesTable(
                            teamData: teamData,
                            teamName: '',
                          ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _TeamSalesData {
  final String team;
  final double sales;
  final List<Color> gradient;
  final String manager;
  final int agentCount;
  final Set<String> userGroups;
  _TeamSalesData(
    this.team,
    this.sales,
    this.gradient,
    this.manager,
    this.agentCount,
    this.userGroups,
  );
}
