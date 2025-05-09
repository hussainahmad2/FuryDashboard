// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class EasyScreen extends StatelessWidget {
  const EasyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Easy Mode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Simplified interface for quick actions',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildEasyButton(Icons.payment, 'Pay'),
                _buildEasyButton(Icons.history, 'History'),
                _buildEasyButton(Icons.settings, 'Settings'),
                _buildEasyButton(Icons.help, 'Help'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEasyButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
