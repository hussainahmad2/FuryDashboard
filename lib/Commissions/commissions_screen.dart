// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CommissionsScreen extends StatelessWidget {
  const CommissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Commissions',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  '\$12,345',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                final amounts = [
                  1250,
                  980,
                  750,
                  620,
                  540,
                  430,
                  380,
                  290,
                  210,
                  150,
                ];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: Text(
                      '\$${amounts[index]}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    'Commission #${10 - index}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${index + 1} day${index == 0 ? '' : 's'} ago',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
