// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AgenciesScreen extends StatelessWidget {
  const AgenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agencies')),
      body: ListView(
        children: [
          _buildAgencyCard('Alpha Agency', 'New York', 4.5),
          _buildAgencyCard('Beta Solutions', 'London', 4.2),
          _buildAgencyCard('Gamma Partners', 'Tokyo', 4.7),
          _buildAgencyCard('Delta Group', 'Sydney', 4.0),
          _buildAgencyCard('Epsilon Inc', 'Berlin', 4.8),
        ],
      ),
    );
  }

  Widget _buildAgencyCard(String name, String location, double rating) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: Text(
                    name[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    Text(
                      rating.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: rating / 5,
              backgroundColor: Colors.grey[800],
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
