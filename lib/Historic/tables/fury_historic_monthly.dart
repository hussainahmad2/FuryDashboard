// ignore_for_file: unnecessary_to_list_in_spreads, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class FuryHistoricMonthly extends StatefulWidget {
  const FuryHistoricMonthly({super.key});

  @override
  State<FuryHistoricMonthly> createState() => _FuryHistoricMonthlyState();
}

class _FuryHistoricMonthlyState extends State<FuryHistoricMonthly> {
  List<Map<String, dynamic>> monthlyData = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAndProcessCSV();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DateTime _parseDate(String dateString) {
    try {
      dateString = dateString.split(' ')[0];
      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      }
      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      }
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('Error parsing date "$dateString": $e');
      return DateTime.now();
    }
  }

  int _countUniqueTeamMembers(List<Map<String, dynamic>> dailyData) {
    Set<String> uniqueMembers = {};
    for (var day in dailyData) {
      final name = day['Closer_Name']?.toString();
      if (name != null && name.isNotEmpty) {
        uniqueMembers.add(name);
      }
    }
    return uniqueMembers.length;
  }

  Future<void> loadAndProcessCSV() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final rawData = await rootBundle.loadString('assets/historic.csv');
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(
        rawData,
        eol: '\n',
      );

      if (csvTable.isEmpty || csvTable.length < 2) {
        throw Exception('CSV file is empty or has no data rows');
      }

      final headers = csvTable.first.map((e) => e.toString()).toList();
      final rows = csvTable.sublist(1).where((row) => row.isNotEmpty).toList();

      Map<String, List<Map<String, dynamic>>> monthlyGroups = {};

      for (var row in rows) {
        try {
          final map = <String, dynamic>{};
          for (int i = 0; i < headers.length && i < row.length; i++) {
            map[headers[i]] = row[i] is String ? row[i].trim() : row[i];
          }

          if (!map.containsKey('Stat Date')) continue;

          DateTime date = _parseDate(map['Stat Date'].toString());
          String monthKey = DateFormat('MMM yyyy').format(date);

          monthlyGroups.putIfAbsent(monthKey, () => []).add(map);
        } catch (e) {
          debugPrint('Error processing row: $e');
        }
      }

      List<Map<String, dynamic>> result = [];
      monthlyGroups.forEach((monthKey, dailyData) {
        try {
          // Calculate unique team members (HC) for the whole month
          int hc = _countUniqueTeamMembers(dailyData);

          // Calculate all sums
          num totalCalls = _sum(dailyData, 'Total_Calls');
          num directCalls = _sum(dailyData, 'Direct_Calls');
          num verifiedCalls = _sum(dailyData, 'verified_calls');
          num pcb = _sum(dailyData, 'PCB');
          num totalBills = _sum(dailyData, 'Total_Bills');
          num verifiedBills = _sum(dailyData, 'verified_Bills');
          num validations = _sum(dailyData, 'Validations');
          num sales = _sum(dailyData, 'Sales');
          num platSales = _sum(dailyData, 'Plat_Sales');
          num directSales = _sum(dailyData, 'Direct_Sales');
          num directBills = _sum(dailyData, 'Direct_Bills');
          num tPremiumE = _sum(dailyData, 'T_Premium_E');
          num platAp = _sum(dailyData, 'plat_ap');
          num levelPremium = _sum(dailyData, 'Level_Premium');
          num gi = _sum(dailyData, 'GI');
          num graded = _sum(dailyData, 'Graded');
          num modified = _sum(dailyData, 'Modified');
          num standard = _sum(dailyData, 'Standard');
          num rop = _sum(dailyData, 'ROP');

          // Calculate all metrics
          result.add({
            'Month': monthKey,
            'HC': hc, // Using unique team member count
            'Total Calls': totalCalls,
            'Raw Calls': directCalls,
            'Plat Calls': verifiedCalls,
            'PCB': pcb,
            'Total Bills': totalBills,
            'Plat Bills': verifiedBills,
            'Validations': validations,
            'VD%': validations > 0 ? (sales / validations * 100) : 0,
            'Blended Conv %':
                (totalCalls - pcb) > 0
                    ? (totalBills / (totalCalls - pcb) * 100)
                    : 0,
            'RC Conv %':
                directCalls > 0 ? (directBills / directCalls * 100) : 0,
            'Total Sales': sales,
            'Plat Sales': platSales,
            'Raw Call Sales': directSales,
            'Blended Sale Conv':
                totalBills > 0 ? (sales / totalBills * 100) : 0,
            'RC / Sale': directCalls > 0 ? (directSales / directCalls) : 0,
            'AP': tPremiumE,
            'MP': tPremiumE / 12,
            'AP / Rep': hc > 0 ? tPremiumE / hc : 0,
            'AP / Sale': sales > 0 ? tPremiumE / sales : 0,
            'Plat AP': platAp,
            'Level AP': levelPremium,
            'Level': _average(dailyData, 'Level'),
            'GI': gi,
            'Grad/Mod': graded + modified + standard + rop,
            'Plat Bill %':
                verifiedCalls > 0 ? (verifiedBills / verifiedCalls * 100) : 0,
            'Bill / Rep': hc > 0 ? totalBills / hc : 0,
            'Sale / Rep': hc > 0 ? sales / hc : 0,
            'GI %': gi,
          });
        } catch (e) {
          debugPrint('Error calculating monthly aggregates for $monthKey: $e');
        }
      });

      // Sort by month (newest first)
      result.sort((a, b) {
        try {
          DateTime dateA = DateFormat('MMM yyyy').parse(a['Month']);
          DateTime dateB = DateFormat('MMM yyyy').parse(b['Month']);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

      setState(() {
        monthlyData = result;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading CSV: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        errorMessage = 'Failed to load data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  num _sum(List<Map<String, dynamic>> data, String key) {
    return data.fold(
      0.0,
      (sum, item) => sum + (num.tryParse(item[key]?.toString() ?? '0') ?? 0),
    );
  }

  double _average(List<Map<String, dynamic>> data, String key) {
    if (data.isEmpty) return 0;
    return _sum(data, key) / data.length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
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
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 8),
                Expanded(
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildMonthlyTable(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTable() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed Month Column
        Container(
          width: 90,
          decoration: BoxDecoration(
            color: Colors.black87,
            border: Border(right: BorderSide(color: Colors.white30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTableHeader("Month", width: 90),
              ...monthlyData
                  .map(
                    (row) => _buildTableCell(
                      row['Month']?.toString() ?? '-',
                      width: 90,
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        // Scrollable Data Columns
        Expanded(
          child: Column(
            children: [
              // Fixed Header Row
              Container(
                color: Colors.black87,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildTableHeader("HC", width: 50),
                      _buildTableHeader("Total\nCalls", width: 75),
                      _buildTableHeader("Raw\nCalls", width: 75),
                      _buildTableHeader("Plat\nCalls", width: 75),
                      _buildTableHeader("PCB", width: 50),
                      _buildTableHeader("Total\nBills", width: 75),
                      _buildTableHeader("Plat\nBills", width: 75),
                      _buildTableHeader("Valid", width: 50),
                      _buildTableHeader("VD%", width: 50),
                      _buildTableHeader("Blend\nConv%", width: 85),
                      _buildTableHeader("RC\nConv%", width: 85),
                      _buildTableHeader("Total\nSales", width: 75),
                      _buildTableHeader("Plat\nSales", width: 75),
                      _buildTableHeader("Raw Call\nSales", width: 75),
                      _buildTableHeader("Blend\nSale%", width: 85),
                      _buildTableHeader("RC/\nSale", width: 80),
                      _buildTableHeader("AP", width: 75),
                      _buildTableHeader("MP", width: 75),
                      _buildTableHeader("AP/Rep", width: 80),
                      _buildTableHeader("AP/Sale", width: 80),
                      _buildTableHeader("Plat\nAP", width: 75),
                      _buildTableHeader("Level\nAP", width: 75),
                      _buildTableHeader("Level", width: 50),
                      _buildTableHeader("GI", width: 50),
                      _buildTableHeader("Grad/\nMod", width: 75),
                      _buildTableHeader("Plat\nBill%", width: 85),
                      _buildTableHeader("Bill/\nRep", width: 75),
                      _buildTableHeader("Sale/\nRep", width: 75),
                      _buildTableHeader("GI%", width: 50),
                    ],
                  ),
                ),
              ),
              // Scrollable Data
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Data Rows
                        ...monthlyData
                            .map(
                              (row) => Row(
                                children: [
                                  _buildTableCell(
                                    row['HC']?.toString() ?? '-',
                                    width: 50,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Total Calls']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Raw Calls']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Plat Calls']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['PCB']),
                                    width: 50,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Total Bills']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Plat Bills']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Validations']),
                                    width: 50,
                                  ),
                                  _buildTableCell(
                                    _formatPercentage(row['VD%']),
                                    width: 50,
                                    isPercentage: true,
                                  ),
                                  _buildTableCell(
                                    _formatPercentage(row['Blended Conv %']),
                                    width: 85,
                                    isPercentage: true,
                                  ),
                                  _buildTableCell(
                                    _formatPercentage(row['RC Conv %']),
                                    width: 85,
                                    isPercentage: true,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Total Sales']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Plat Sales']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Raw Call Sales']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatPercentage(row['Blended Sale Conv']),
                                    width: 85,
                                    isPercentage: true,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['RC / Sale']),
                                    width: 80,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['AP']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['MP']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['AP / Rep']),
                                    width: 80,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['AP / Sale']),
                                    width: 80,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Plat AP']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Level AP']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Level']),
                                    width: 50,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['GI']),
                                    width: 50,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Grad/Mod']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatPercentage(row['Plat Bill %']),
                                    width: 85,
                                    isPercentage: true,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Bill / Rep']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatNumber(row['Sale / Rep']),
                                    width: 75,
                                  ),
                                  _buildTableCell(
                                    _formatPercentage(row['GI %']),
                                    width: 50,
                                    isPercentage: true,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text, {double width = 80}) {
    return Container(
      width: width,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
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
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    double width = 80,
    bool isPercentage = false,
  }) {
    return Container(
      width: width,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: const Border(
          bottom: BorderSide(color: Colors.white24),
          right: BorderSide(color: Colors.white24),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPercentage ? Colors.redAccent : Colors.white,
          fontWeight: isPercentage ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '-';
    if (value is num) {
      return value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    }
    return value.toString();
  }

  String _formatPercentage(dynamic value) {
    if (value == null) return '-';
    if (value is num) {
      return '${value.toStringAsFixed(1)}%';
    }
    return value.toString();
  }
}
