// funding_tables_only.dart or inside same file if preferred
import 'package:flutter/material.dart';
import 'Tables/agentwise_funding_table.dart';
import 'Tables/carrierwise_funding_table.dart';
import 'Tables/teamwise_funding_table.dart';
import 'Tables/validatorwise_funding_table.dart';

class FundingTablesOnly extends StatelessWidget {
  const FundingTablesOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/back.jpg"),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            TeamWiseFundingTable(),
            SizedBox(height: 50),
            ValidatorsFundingTable(),
            SizedBox(height: 50),
            CarrierwiseFundingTable(),
            SizedBox(height: 50),
            AgentwiseFundingTable(),
          ],
        ),
      ),
    );
  }
}
