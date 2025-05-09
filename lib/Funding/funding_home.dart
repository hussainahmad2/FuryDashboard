// funding_screen.dart
import 'package:flutter/material.dart';
import 'funding_tables_only.dart';

class FundingScreen extends StatelessWidget {
  const FundingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: FundingTablesOnly()),
    );
  }
}
