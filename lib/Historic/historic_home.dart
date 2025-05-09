// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import './tables/fury_historic_daily.dart';
import './tables/fury_historic_monthly.dart';
import './tables/fury_historic_weekly.dart';
import './tables/teamwise_daily_historic_section.dart';

class HistoricHome extends StatelessWidget {
  const HistoricHome({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
            opacity: 0.45,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Daily Table Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
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
                    child: const Center(
                      child: Text(
                        'Daily Historic Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const FuryHistoricDaily(),
                  separatorLine(), // Separator below Daily section
                ],
              ),
            ),

            // Weekly Table Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
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
                    child: const Center(
                      child: Text(
                        'Weekly Historic Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const FuryHistoricWeekly(),
                  separatorLine(), // Separator below Weekly section
                ],
              ),
            ),

            // Monthly Table Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
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
                    child: const Center(
                      child: Text(
                        'Monthly Historic Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const FuryHistoricMonthly(),
                  separatorLine(), // if you want a separator
                ],
              ),
            ),

            // Teamwise Daily Historic Data Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Colors.purpleAccent, Colors.blueAccent],
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
                    child: const Center(
                      child: Text(
                        'Teamwise Daily Historic Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const TeamwiseDailyHistoricSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
