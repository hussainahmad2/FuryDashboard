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
  Map<String, List<Map<String, dynamic>>> teamwiseDailyData = {};
  // Daily historic table controllers
  final ScrollController _dailyHorizontalScrollController = ScrollController();
  final ScrollController _dailyVerticalScrollController = ScrollController();
  // Teamwise table controllers
  final ScrollController _teamwiseHorizontalScrollController =
      ScrollController();
  final ScrollController _teamwiseVerticalScrollController = ScrollController();
  bool showTeamwiseTable = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  @override
  void dispose() {
    _dailyHorizontalScrollController.dispose();
    _dailyVerticalScrollController.dispose();
    _teamwiseHorizontalScrollController.dispose();
    _teamwiseVerticalScrollController.dispose();
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

      // Process daily historic data
      Map<String, Map<String, dynamic>> dateGroups = {};
      // Group by team for teamwise data
      Map<String, List<Map<String, dynamic>>> grouped = {};

      for (var row in rows) {
        if (row.isEmpty) continue;

        final map = <String, dynamic>{};
        for (int i = 0; i < headers.length && i < row.length; i++) {
          map[headers[i]] = row[i] is String ? row[i].trim() : row[i];
        }

        // Process for daily historic
        String date = map['Stat Date']?.toString().split(' ')[0] ?? '';
        if (date.isNotEmpty) {
          if (!dateGroups.containsKey(date)) {
            dateGroups[date] = {
              'Date': date,
              'Team': 0,
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
              'count': 0,
            };
          }
          var group = dateGroups[date]!;
          group['Team'] = (group['Team'] as int) + 1;
          group['Total_Calls'] =
              (group['Total_Calls'] as num) +
              (toNumber(map['Total_Calls']) ?? 0);
          group['Direct_Calls'] =
              (group['Direct_Calls'] as num) +
              (toNumber(map['Direct_Calls']) ?? 0);
          group['verified_calls'] =
              (group['verified_calls'] as num) +
              (toNumber(map['verified_calls']) ?? 0);
          group['PCB'] = (group['PCB'] as num) + (toNumber(map['PCB']) ?? 0);
          group['Total_Bills'] =
              (group['Total_Bills'] as num) +
              (toNumber(map['Total_Bills']) ?? 0);
          group['verified_Bills'] =
              (group['verified_Bills'] as num) +
              (toNumber(map['verified_Bills']) ?? 0);
          group['Validations'] =
              (group['Validations'] as num) +
              (toNumber(map['Validations']) ?? 0);
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
              (group['T_Premium_E'] as num) +
              (toNumber(map['T_Premium_E']) ?? 0);
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

        // Process for teamwise data
        final team =
            map['Team']?.toString() ?? map['TEAM']?.toString() ?? 'Unknown';
        grouped.putIfAbsent(team, () => []).add(map);
      }

      // Process daily historic data
      List<Map<String, dynamic>> result = [];
      dateGroups.forEach((date, group) {
        int teamSize = group['Team'] as int;
        if (teamSize == 0) return;

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

      // Sort each team's data by date descending and take 8 entries
      grouped.forEach((team, data) {
        data.sort(
          (a, b) => (b['Stat Date'] ?? '').compareTo(a['Stat Date'] ?? ''),
        );
        grouped[team] = data.take(8).toList();
      });

      setState(() {
        processedData = result.take(20).toList();
        teamwiseDailyData = grouped;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading CSV: $e");
      setState(() {
        processedData = [];
        isLoading = false;
      });
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
      height: 600,
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

          // Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Table Selection Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showTeamwiseTable = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              showTeamwiseTable ? Colors.grey : Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Summary',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showTeamwiseTable = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              showTeamwiseTable ? Colors.blue : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Teamwise Table',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Table
                Expanded(
                  child:
                      showTeamwiseTable
                          ? _buildTeamwiseTable()
                          : _buildDailyTable(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.85)),
          child: Scrollbar(
            controller: _dailyVerticalScrollController,
            child: SingleChildScrollView(
              controller: _dailyVerticalScrollController,
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
                      controller: _dailyHorizontalScrollController,
                      child: SingleChildScrollView(
                        controller: _dailyHorizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildTableHeader("HC", width: 50),
                                _buildTableHeader("Total\nCalls", width: 70),
                                _buildTableHeader("Raw\nCalls", width: 70),
                                _buildTableHeader("Plat\nCalls", width: 70),
                                _buildTableHeader("PCB", width: 50),
                                _buildTableHeader("Total\nBills", width: 70),
                                _buildTableHeader("Plat\nBills", width: 70),
                                _buildTableHeader("Valid", width: 50),
                                _buildTableHeader("VD%", width: 50),
                                _buildTableHeader("Blend\nConv%", width: 80),
                                _buildTableHeader("RC\nConv%", width: 80),
                                _buildTableHeader("Total\nSales", width: 70),
                                _buildTableHeader("Plat\nSales", width: 70),
                                _buildTableHeader("Raw Call\nSales", width: 70),
                                _buildTableHeader("Blend\nSale%", width: 80),
                                _buildTableHeader("RC/\nSale", width: 75),
                                _buildTableHeader("AP", width: 70),
                                _buildTableHeader("MP", width: 70),
                                _buildTableHeader("AP/Rep", width: 75),
                                _buildTableHeader("AP/Sale", width: 75),
                                _buildTableHeader("Plat\nAP", width: 70),
                                _buildTableHeader("Level\nAP", width: 70),
                                _buildTableHeader("Level", width: 50),
                                _buildTableHeader("GI", width: 50),
                                _buildTableHeader("Grad/\nMod", width: 70),
                                _buildTableHeader("Plat\nBill%", width: 80),
                                _buildTableHeader("Bill/\nRep", width: 75),
                                _buildTableHeader("Sale/\nRep", width: 75),
                                _buildTableHeader("GI%", width: 50),
                              ],
                            ),
                            ...processedData
                                .map(
                                  (row) => Row(
                                    children: [
                                      _buildTableCell(
                                        row['HC']?.toString() ?? '-',
                                        width: 50,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Total Calls']),
                                        width: 70,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Raw Calls']),
                                        width: 70,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Plat Calls']),
                                        width: 70,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['PCB']),
                                        width: 50,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Total Bills']),
                                        width: 70,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Plat Bills']),
                                        width: 70,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Valid']),
                                        width: 50,
                                      ),
                                      _buildTableCell(
                                        _formatPercentage(row['VD %']),
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
                                        _formatPercentage(row['RC Conv %']),
                                        width: 80,
                                        isPercentage: true,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Total Sales']),
                                        width: 70,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Plat Sales']),
                                        width: 70,
                                      ),
                                      _buildTableCell(
                                        _formatNumber(row['Raw Call Sales']),
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
                                        _formatPercentage(row['Plat Bill %']),
                                        width: 80,
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
          ),
        );
      },
    );
  }

  Widget _buildTeamwiseTable() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _teamwiseVerticalScrollController,
      itemCount: teamwiseDailyData.length,
      itemBuilder: (context, index) {
        final team = teamwiseDailyData.keys.elementAt(index);
        final data = teamwiseDailyData[team]!;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      _buildTableHeader("Date", width: 100),
                      _buildTableHeader("Total\nCalls", width: 70),
                      _buildTableHeader("Raw\nCalls", width: 70),
                      _buildTableHeader("Plat\nCalls", width: 70),
                      _buildTableHeader("PCB", width: 50),
                      _buildTableHeader("Total\nBills", width: 70),
                      _buildTableHeader("Plat\nBills", width: 70),
                      _buildTableHeader("Valid", width: 50),
                      _buildTableHeader("VD%", width: 50),
                      _buildTableHeader("Blend\nConv%", width: 80),
                      _buildTableHeader("RC\nConv%", width: 80),
                      _buildTableHeader("Total\nSales", width: 70),
                      _buildTableHeader("Plat\nSales", width: 70),
                      _buildTableHeader("Raw Call\nSales", width: 70),
                      _buildTableHeader("Blend\nSale%", width: 80),
                      _buildTableHeader("RC/\nSale", width: 75),
                      _buildTableHeader("AP", width: 70),
                      _buildTableHeader("MP", width: 70),
                      _buildTableHeader("AP/Rep", width: 75),
                      _buildTableHeader("AP/Sale", width: 75),
                      _buildTableHeader("Plat\nAP", width: 70),
                      _buildTableHeader("Level\nAP", width: 70),
                      _buildTableHeader("Level", width: 50),
                      _buildTableHeader("GI", width: 50),
                      _buildTableHeader("Grad/\nMod", width: 70),
                      _buildTableHeader("Plat\nBill%", width: 80),
                      _buildTableHeader("Bill/\nRep", width: 75),
                      _buildTableHeader("Sale/\nRep", width: 75),
                      _buildTableHeader("GI%", width: 50),
                    ],
                  ),
                  // Data Rows
                  ...data.map((row) {
                    final totalCalls = toNumber(row['Total_Calls']) ?? 0;
                    final directCalls = toNumber(row['Direct_Calls']) ?? 0;
                    final verifiedCalls = toNumber(row['verified_calls']) ?? 0;
                    final pcb = toNumber(row['PCB']) ?? 0;
                    final totalBills = toNumber(row['Total_Bills']) ?? 0;
                    final verifiedBills = toNumber(row['verified_Bills']) ?? 0;
                    final validations = toNumber(row['Validations']) ?? 0;
                    final sales = toNumber(row['Sales']) ?? 0;
                    final platSales = toNumber(row['Plat_Sales']) ?? 0;
                    final directSales = toNumber(row['Direct_Sales']) ?? 0;
                    final tPremiumE = toNumber(row['T_Premium_E']) ?? 0;
                    final platAp = toNumber(row['plat_ap']) ?? 0;
                    final levelPremium = toNumber(row['Level_Premium']) ?? 0;
                    final gi = toNumber(row['GI']) ?? 0;
                    final graded = toNumber(row['Graded']) ?? 0;
                    final modified = toNumber(row['Modified']) ?? 0;
                    final standard = toNumber(row['Standard']) ?? 0;
                    final rop = toNumber(row['ROP']) ?? 0;

                    final vdPercent =
                        validations > 0 ? (sales / validations * 100) : 0;
                    final blendedConvPercent =
                        (totalCalls - pcb) > 0
                            ? (totalBills / (totalCalls - pcb) * 100)
                            : 0;
                    final rcConvPercent =
                        directCalls > 0 ? (directSales / directCalls * 100) : 0;
                    final blendedSaleConv =
                        totalBills > 0 ? (sales / totalBills * 100) : 0;
                    final rcPerSale =
                        directCalls > 0 ? (directSales / directCalls) : 0;
                    final mp = tPremiumE / 12;
                    final apPerRep = tPremiumE;
                    final apPerSale = sales > 0 ? (tPremiumE / sales) : 0;
                    final gradMod = graded + modified + standard + rop;
                    final platBillPercent =
                        verifiedCalls > 0
                            ? (verifiedBills / verifiedCalls * 100)
                            : 0;
                    final billPerRep = totalBills;
                    final salePerRep = sales;
                    final giPercent = gi;

                    return Row(
                      children: [
                        _buildTableCell(
                          row['Stat Date']?.toString().split(' ')[0] ?? '-',
                          width: 100,
                        ),
                        _buildTableCell(_formatNumber(totalCalls), width: 70),
                        _buildTableCell(_formatNumber(directCalls), width: 70),
                        _buildTableCell(
                          _formatNumber(verifiedCalls),
                          width: 70,
                        ),
                        _buildTableCell(_formatNumber(pcb), width: 50),
                        _buildTableCell(_formatNumber(totalBills), width: 70),
                        _buildTableCell(
                          _formatNumber(verifiedBills),
                          width: 70,
                        ),
                        _buildTableCell(_formatNumber(validations), width: 50),
                        _buildTableCell(
                          _formatPercentage(vdPercent),
                          width: 50,
                          isPercentage: true,
                        ),
                        _buildTableCell(
                          _formatPercentage(blendedConvPercent),
                          width: 80,
                          isPercentage: true,
                        ),
                        _buildTableCell(
                          _formatPercentage(rcConvPercent),
                          width: 80,
                          isPercentage: true,
                        ),
                        _buildTableCell(_formatNumber(sales), width: 70),
                        _buildTableCell(_formatNumber(platSales), width: 70),
                        _buildTableCell(_formatNumber(directSales), width: 70),
                        _buildTableCell(
                          _formatPercentage(blendedSaleConv),
                          width: 80,
                          isPercentage: true,
                        ),
                        _buildTableCell(_formatNumber(rcPerSale), width: 75),
                        _buildTableCell(_formatNumber(tPremiumE), width: 70),
                        _buildTableCell(_formatNumber(mp), width: 70),
                        _buildTableCell(_formatNumber(apPerRep), width: 75),
                        _buildTableCell(_formatNumber(apPerSale), width: 75),
                        _buildTableCell(_formatNumber(platAp), width: 70),
                        _buildTableCell(_formatNumber(levelPremium), width: 70),
                        _buildTableCell(_formatNumber(row['Level']), width: 50),
                        _buildTableCell(_formatNumber(gi), width: 50),
                        _buildTableCell(_formatNumber(gradMod), width: 70),
                        _buildTableCell(
                          _formatPercentage(platBillPercent),
                          width: 80,
                          isPercentage: true,
                        ),
                        _buildTableCell(_formatNumber(billPerRep), width: 75),
                        _buildTableCell(_formatNumber(salePerRep), width: 75),
                        _buildTableCell(
                          _formatPercentage(giPercent),
                          width: 50,
                          isPercentage: true,
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
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
