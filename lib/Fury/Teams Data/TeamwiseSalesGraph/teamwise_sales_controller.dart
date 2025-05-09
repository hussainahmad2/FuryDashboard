import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamwiseSalesController {
  Future<(List<String>, List<double>)> loadChartData() async {
    try {
      final response = await rootBundle.loadString(
        'assets/comb_df_2025-04-18.json',
      );
      final data = json.decode(response) as List<dynamic>;

      final salesMap = <String, double>{};
      for (var item in data.cast<Map<String, dynamic>>()) {
        final teamName = item['TEAM']?.toString() ?? 'Unknown Team';
        final sales =
            (item['TOTAL SALES'] as num?)?.toDouble() ?? 0.0; // Ensure double
        salesMap[teamName] = (salesMap[teamName] ?? 0) + sales;
      }

      final sortedEntries =
          salesMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      return (
        sortedEntries.map((e) => e.key).toList(),
        sortedEntries.map((e) => e.value).toList(), // Already double
      );
    } catch (e) {
      debugPrint('Error loading chart data: $e');
      return (['Error loading data'], [0.0]); // Use double literal
    }
  }
}
