// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'tables/fury_historic_daily.dart';
import 'tables/fury_historic_weekly.dart';
import 'tables/fury_historic_monthly.dart';
import 'widgets/section_header.dart';

class DataHome extends StatelessWidget {
  const DataHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image without blur
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader('Daily Historic Data'),
                const FuryHistoricDaily(),
                const SizedBox(height: 24),
                const ColorfulSeparator(),
                const SectionHeader('Weekly Historic Data'),
                const FuryHistoricWeekly(),
                const SizedBox(height: 24),
                const ColorfulSeparator(),
                const SectionHeader('Monthly Historic Data'),
                const FuryHistoricMonthly(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColorfulSeparator extends StatelessWidget {
  const ColorfulSeparator({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 3,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C3483), Color(0xFF2B3A67), Color(0xFFE67E22)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
