// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/orientation_aware_widget.dart';

class StatCards extends StatefulWidget {
  const StatCards({super.key});

  @override
  State<StatCards> createState() => _StatCardsState();
}

class _StatCardsState extends State<StatCards> {
  List<Map<String, dynamic>> jsonData = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/comb_df_2025-05-13.json',
      );
      final data = await json.decode(response) as List;
      if (mounted) {
        setState(() {
          jsonData = data.cast<Map<String, dynamic>>();
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      debugPrint('Error loading JSON: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage =
              null; // Don't show error message, just use default values
          jsonData = []; // Clear data to trigger empty state
        });
      }
    }
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      // Remove any non-numeric characters except decimal point
      final cleanString = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return int.tryParse(cleanString) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }

  List<dynamic> getCardData() {
    if (isLoading) {
      return [
        ['Direct Tranfers', '...', Colors.red, 'Loading data...'],
        ['Plat', '...', Colors.blue, 'Loading data...'],
        ['Sales', '...', Colors.green, 'Loading data...'],
        ['Conversion', '...', Colors.amber, 'Loading data...'],
      ];
    }

    // Initialize default values
    int totalTrxSum = 0;
    int verifiedCallsSum = 0;
    int directCallsSum = 0;
    int totalSalesSum = 0;
    int validationsSum = 0;

    try {
      if (jsonData.isNotEmpty) {
        for (var item in jsonData) {
          totalTrxSum += _parseInt(item['TOTAL TRX']);
          verifiedCallsSum += _parseInt(item['VERIFIED CALLS']);
          directCallsSum += _parseInt(item['DIRECT CALLS']);
          totalSalesSum += _parseInt(item['TOTAL SALES']);
          validationsSum += _parseInt(item['Validations']);
        }
      }

      String conversionPercentage =
          validationsSum == 0
              ? '0%'
              : '${(totalSalesSum / validationsSum * 100).toStringAsFixed(1)}%';

      String conversionPercent =
          totalTrxSum == 0
              ? '0%'
              : '${(totalSalesSum / totalTrxSum * 100).toStringAsFixed(1)}%';

      return [
        [
          'Direct Tranfers',
          directCallsSum.toString(),
          Colors.red,
          'Total number of direct transfers processed',
        ],
        [
          'Plat',
          verifiedCallsSum.toString(),
          Colors.blue,
          'Total number of verified platform transactions',
        ],
        [
          'Sales',
          conversionPercent,
          Colors.green,
          'Sales conversion rate based on total transactions',
        ],
        [
          'Conversion',
          conversionPercentage,
          Colors.amber,
          'Overall conversion rate based on validations',
        ],
      ];
    } catch (e) {
      debugPrint('Error processing data: $e');
      return [
        ['Direct Tranfers', '0', Colors.red, 'No data available'],
        ['Plat', '0', Colors.blue, 'No data available'],
        ['Sales', '0%', Colors.green, 'No data available'],
        ['Conversion', '0%', Colors.amber, 'No data available'],
      ];
    }
  }

  void _showStatDetails(
    BuildContext context,
    String title,
    String value,
    Color color,
    String description,
  ) {
    final isSmallScreen = ResponsiveUtils.isSmallScreen(context);
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: isSmallScreen ? size.width * 0.9 : 400,
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.5), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value,
                        style: TextStyle(
                          color: color,
                          fontSize: isSmallScreen ? 28 : 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ... existing imports and class definition ...

  @override
  Widget build(BuildContext context) {
    return OrientationAwareWidget(
      builder: (context, isPortrait, isSmallScreen) {
        final cardData = getCardData();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ), // Keeps grid compact
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2, // Keeps cards square-ish
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children:
                  cardData.map((data) {
                    final title = data[0] as String;
                    final value = data[1] as String;
                    final color = data[2] as Color;
                    final description = data[3] as String;
                    return GestureDetector(
                      onTap:
                          () => _showStatDetails(
                            context,
                            title,
                            value,
                            color,
                            description,
                          ),
                      child: _buildCard(title, value, color),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(String title, String value, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.18), const Color(0xFF23272F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
