// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import './tables/fury_historic_daily.dart';
import './tables/fury_historic_monthly.dart';
import './tables/fury_historic_weekly.dart';
import 'dart:ui';

class HistoricHome extends StatefulWidget {
  const HistoricHome({super.key});

  @override
  State<HistoricHome> createState() => _HistoricHomeState();
}

class _HistoricHomeState extends State<HistoricHome> {
  final ScrollController _mainScrollController = ScrollController();
  final Map<String, ScrollController> _sectionScrollControllers = {
    'daily': ScrollController(),
    'weekly': ScrollController(),
    'monthly': ScrollController(),
  };

  @override
  void dispose() {
    _mainScrollController.dispose();
    for (var controller in _sectionScrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Stylish separator line widget
  Widget separatorLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      height: 4,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purpleAccent, Colors.blueAccent],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String sectionKey) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/back.jpg'),
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blurred background image
          Positioned.fill(
            child: Image.asset(
              'assets/back.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),
          ),
          // Main content
          CustomScrollView(
            controller: _mainScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSectionHeader('Daily Historic Data', 'daily'),
                      const FuryHistoricDaily(),
                      separatorLine(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSectionHeader('Weekly Historic Data', 'weekly'),
                      const FuryHistoricWeekly(),
                      separatorLine(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSectionHeader('Monthly Historic Data', 'monthly'),
                      const FuryHistoricMonthly(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mainScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
