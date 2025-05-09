import 'package:flutter/material.dart';

class AffiliatesScreen extends StatelessWidget {
  const AffiliatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.purple[900]!],
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Affiliate Network',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Invite friends and earn rewards',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAffiliateCard('Invite', Icons.person_add, Colors.blue),
                _buildAffiliateCard(
                  'Earnings',
                  Icons.attach_money,
                  Colors.green,
                ),
                _buildAffiliateCard('Stats', Icons.bar_chart, Colors.orange),
                _buildAffiliateCard(
                  'Resources',
                  Icons.description,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffiliateCard(String title, IconData icon, Color color) {
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
