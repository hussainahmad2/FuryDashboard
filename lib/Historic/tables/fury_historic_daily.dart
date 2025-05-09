// ignore_for_file: unnecessary_to_list_in_spreads, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class FuryHistoricDaily extends StatefulWidget {
  const FuryHistoricDaily({super.key});

  @override
  State<FuryHistoricDaily> createState() => _FuryHistoricDailyState();
}

class _FuryHistoricDailyState extends State<FuryHistoricDaily> {
  List<Map<String, dynamic>> processedData = [];
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> loadCSV() async {
    try {
      final rawData = await rootBundle.loadString('assets/historic.csv');
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(
        rawData,
        eol: '\n',
      );

      if (csvTable.isEmpty || csvTable.length < 2) {
        throw Exception("CSV file is empty or has no data rows");
      }

      final headers = csvTable.first.map((e) => e.toString()).toList();
      final rows = csvTable.sublist(1);

      // Group data by date
      Map<String, Map<String, dynamic>> dateGroups = {};

      for (var row in rows) {
        if (row.isEmpty) continue;

        final map = <String, dynamic>{};
        for (int i = 0; i < headers.length && i < row.length; i++) {
          map[headers[i]] = row[i] is String ? row[i].trim() : row[i];
        }

        String date = map['Stat Date']?.toString().split(' ')[0] ?? '';
        if (date.isEmpty) continue;

        // Initialize date group if not exists
        if (!dateGroups.containsKey(date)) {
          dateGroups[date] = {
            'Date': date,
            'Team': 0, // Number of team members (HC)
            'Total_Calls': 0,
            'Direct_Calls': 0,
            'verified_calls': 0,
            'PCB': 0,
            'Total_Bills': 0,
            'verified_Bills': 0,
            'Validations': 0,
            'Sales': 0,
            'Plat_Sales': 0,
            'Direct_Sales': 0,
            'Direct_Bills': 0,
            'T_Premium_E': 0,
            'plat_ap': 0,
            'Level_Premium': 0,
            'Level': 0,
            'GI': 0,
            'Graded': 0,
            'Modified': 0,
            'Standard': 0,
            'ROP': 0,
            'count': 0, // Number of records for this date
          };
        }

        // Aggregate data
        var group = dateGroups[date]!;
        group['Team'] = (group['Team'] as int) + 1; // Increment head count

        // Sum all metrics
        group['Total_Calls'] =
            (group['Total_Calls'] as num) + (toNumber(map['Total_Calls']) ?? 0);
        group['Direct_Calls'] =
            (group['Direct_Calls'] as num) +
            (toNumber(map['Direct_Calls']) ?? 0);
        group['verified_calls'] =
            (group['verified_calls'] as num) +
            (toNumber(map['verified_calls']) ?? 0);
        group['PCB'] = (group['PCB'] as num) + (toNumber(map['PCB']) ?? 0);
        group['Total_Bills'] =
            (group['Total_Bills'] as num) + (toNumber(map['Total_Bills']) ?? 0);
        group['verified_Bills'] =
            (group['verified_Bills'] as num) +
            (toNumber(map['verified_Bills']) ?? 0);
        group['Validations'] =
            (group['Validations'] as num) + (toNumber(map['Validations']) ?? 0);
        group['Sales'] =
            (group['Sales'] as num) + (toNumber(map['Sales']) ?? 0);
        group['Plat_Sales'] =
            (group['Plat_Sales'] as num) + (toNumber(map['Plat_Sales']) ?? 0);
        group['Direct_Sales'] =
            (group['Direct_Sales'] as num) +
            (toNumber(map['Direct_Sales']) ?? 0);
        group['Direct_Bills'] =
            (group['Direct_Bills'] as num) +
            (toNumber(map['Direct_Bills']) ?? 0);
        group['T_Premium_E'] =
            (group['T_Premium_E'] as num) + (toNumber(map['T_Premium_E']) ?? 0);
        group['plat_ap'] =
            (group['plat_ap'] as num) + (toNumber(map['plat_ap']) ?? 0);
        group['Level_Premium'] =
            (group['Level_Premium'] as num) +
            (toNumber(map['Level_Premium']) ?? 0);
        group['GI'] = (group['GI'] as num) + (toNumber(map['GI']) ?? 0);
        group['Graded'] =
            (group['Graded'] as num) + (toNumber(map['Graded']) ?? 0);
        group['Modified'] =
            (group['Modified'] as num) + (toNumber(map['Modified']) ?? 0);
        group['Standard'] =
            (group['Standard'] as num) + (toNumber(map['Standard']) ?? 0);
        group['ROP'] = (group['ROP'] as num) + (toNumber(map['ROP']) ?? 0);

        group['count'] = (group['count'] as int) + 1;
      }

      // Calculate derived metrics
      List<Map<String, dynamic>> result = [];

      dateGroups.forEach((date, group) {
        int teamSize = group['Team'] as int;
        if (teamSize == 0) return;

        // Calculate all metrics based on the provided formulas
        num totalCalls = group['Total_Calls'] as num;
        num directCalls = group['Direct_Calls'] as num;
        num verifiedCalls = group['verified_calls'] as num;
        num pcb = group['PCB'] as num;
        num totalBills = group['Total_Bills'] as num;
        num verifiedBills = group['verified_Bills'] as num;
        num validations = group['Validations'] as num;
        num sales = group['Sales'] as num;
        num platSales = group['Plat_Sales'] as num;
        num directSales = group['Direct_Sales'] as num;
        num directBills = group['Direct_Bills'] as num;
        num tPremiumE = group['T_Premium_E'] as num;
        num platAp = group['plat_ap'] as num;
        num levelPremium = group['Level_Premium'] as num;
        num gi = group['GI'] as num;
        num graded = group['Graded'] as num;
        num modified = group['Modified'] as num;
        num standard = group['Standard'] as num;
        num rop = group['ROP'] as num;

        // Calculate all metrics
        group['VD%'] = validations > 0 ? (sales / validations * 100) : 0;
        group['Blended Conv %'] =
            (totalCalls - pcb) > 0
                ? (totalBills / (totalCalls - pcb) * 100)
                : 0;
        group['RC Conv %'] =
            directCalls > 0 ? (directBills / directCalls * 100) : 0;
        group['Blended Sale Conv'] =
            totalBills > 0 ? (sales / totalBills * 100) : 0;
        group['RC / Sale'] = directCalls > 0 ? (directSales / directCalls) : 0;
        group['MP'] = tPremiumE / 12;
        group['AP / Rep'] = tPremiumE / teamSize;
        group['AP / Sale'] = sales > 0 ? (tPremiumE / sales) : 0;
        group['Grad/Mod'] = graded + modified + standard + rop;
        group['Plat Bill %'] =
            verifiedCalls > 0 ? (verifiedBills / verifiedCalls * 100) : 0;
        group['Bill / Rep'] = totalBills / teamSize;
        group['Sale / Rep'] = sales / teamSize;
        group['GI %'] = gi;

        // Add to results
        result.add({
          'Date': date,
          'HC': teamSize,
          'Total Calls': totalCalls,
          'Raw Calls': directCalls,
          'Plat Calls': verifiedCalls,
          'PCB': pcb,
          'Total Bills': totalBills,
          'Plat Bills': verifiedBills,
          'Validations': validations,
          'VD%': group['VD%'],
          'Blended Conv %': group['Blended Conv %'],
          'RC Conv %': group['RC Conv %'],
          'Total Sales': sales,
          'Plat Sales': platSales,
          'Raw Call Sales': directSales,
          'Blended Sale Conv': group['Blended Sale Conv'],
          'RC / Sale': group['RC / Sale'],
          'AP': tPremiumE,
          'MP': group['MP'],
          'AP / Rep': group['AP / Rep'],
          'AP / Sale': group['AP / Sale'],
          'Plat AP': platAp,
          'Level AP': levelPremium,
          'Level': group['Level'],
          'GI': gi,
          'Grad/Mod': group['Grad/Mod'],
          'Plat Bill %': group['Plat Bill %'],
          'Bill / Rep': group['Bill / Rep'],
          'Sale / Rep': group['Sale / Rep'],
          'GI %': group['GI %'],
        });
      });

      // Sort by date ascending (oldest first)
      result.sort((a, b) => a['Date'].compareTo(b['Date']));
      setState(() => processedData = result.take(20).toList());
    } catch (e) {
      debugPrint("Error loading CSV: $e");
      setState(() => processedData = []);
    }
  }

  num? toNumber(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value.replaceAll(',', '').replaceAll('%', '').trim());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (processedData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // Background
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
                const SizedBox(height: 8),
                // Table
                Expanded(
                  child: Scrollbar(
                    controller: _verticalScrollController,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fixed Date Column
                          SizedBox(
                            width: 80,
                            child: Column(
                              children: [
                                _buildTableHeader("Date"),
                                ...processedData
                                    .map(
                                      (row) => _buildTableCell(
                                        row['Date']?.toString() ?? '-',
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),

                          // Scrollable Data Columns
                          Expanded(
                            child: Scrollbar(
                              controller: _horizontalScrollController,
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header Row
                                    Row(
                                      children: [
                                        _buildTableHeader("HC", width: 50),
                                        _buildTableHeader(
                                          "Total\nCalls",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Raw\nCalls",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Plat\nCalls",
                                          width: 70,
                                        ),
                                        _buildTableHeader("PCB", width: 50),
                                        _buildTableHeader(
                                          "Total\nBills",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Plat\nBills",
                                          width: 70,
                                        ),
                                        _buildTableHeader("Valid", width: 50),
                                        _buildTableHeader("VD%", width: 50),
                                        _buildTableHeader(
                                          "Blend\nConv%",
                                          width: 80,
                                        ),
                                        _buildTableHeader(
                                          "RC\nConv%",
                                          width: 80,
                                        ),
                                        _buildTableHeader(
                                          "Total\nSales",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Plat\nSales",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Raw Call\nSales",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Blend\nSale%",
                                          width: 80,
                                        ),
                                        _buildTableHeader(
                                          "RC/\nSale",
                                          width: 75,
                                        ),
                                        _buildTableHeader("AP", width: 70),
                                        _buildTableHeader("MP", width: 70),
                                        _buildTableHeader("AP/Rep", width: 75),
                                        _buildTableHeader("AP/Sale", width: 75),
                                        _buildTableHeader(
                                          "Plat\nAP",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Level\nAP",
                                          width: 70,
                                        ),
                                        _buildTableHeader("Level", width: 50),
                                        _buildTableHeader("GI", width: 50),
                                        _buildTableHeader(
                                          "Grad/\nMod",
                                          width: 70,
                                        ),
                                        _buildTableHeader(
                                          "Plat\nBill%",
                                          width: 80,
                                        ),
                                        _buildTableHeader(
                                          "Bill/\nRep",
                                          width: 75,
                                        ),
                                        _buildTableHeader(
                                          "Sale/\nRep",
                                          width: 75,
                                        ),
                                        _buildTableHeader("GI%", width: 50),
                                      ],
                                    ),

                                    // Data Rows
                                    ...processedData
                                        .map(
                                          (row) => Row(
                                            children: [
                                              _buildTableCell(
                                                row['HC']?.toString() ?? '-',
                                                width: 50,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Total Calls'],
                                                ),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['Raw Calls']),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Plat Calls'],
                                                ),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['PCB']),
                                                width: 50,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Total Bills'],
                                                ),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Plat Bills'],
                                                ),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Validations'],
                                                ),
                                                width: 50,
                                              ),
                                              _buildTableCell(
                                                _formatPercentage(row['VD%']),
                                                width: 50,
                                                isPercentage: true,
                                              ),
                                              _buildTableCell(
                                                _formatPercentage(
                                                  row['Blended Conv %'],
                                                ),
                                                width: 80,
                                                isPercentage: true,
                                              ),
                                              _buildTableCell(
                                                _formatPercentage(
                                                  row['RC Conv %'],
                                                ),
                                                width: 80,
                                                isPercentage: true,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Total Sales'],
                                                ),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Plat Sales'],
                                                ),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Raw Call Sales'],
                                                ),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatPercentage(
                                                  row['Blended Sale Conv'],
                                                ),
                                                width: 80,
                                                isPercentage: true,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['RC / Sale']),
                                                width: 75,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['AP']),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['MP']),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['AP / Rep']),
                                                width: 75,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['AP / Sale']),
                                                width: 75,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['Plat AP']),
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(row['Level AP']),
                                                width: 70,
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
                                                width: 70,
                                              ),
                                              _buildTableCell(
                                                _formatPercentage(
                                                  row['Plat Bill %'],
                                                ),
                                                width: 80,
                                                isPercentage: true,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Bill / Rep'],
                                                ),
                                                width: 75,
                                              ),
                                              _buildTableCell(
                                                _formatNumber(
                                                  row['Sale / Rep'],
                                                ),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        style: TextStyle(
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
        border: Border(
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
