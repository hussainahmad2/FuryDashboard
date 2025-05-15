import 'package:flutter/material.dart';

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
