// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

final Map<int, String> timeSlots = {
  1: "7PM",
  2: "7:00PM-8:00PM",
  3: "8:00PM-9:00PM",
  4: "9:00PM-10:00PM",
  5: "10:00PM-11:00PM",
  6: "11:00PM-12:00PM",
  7: "12:00AM-1:00AM",
  8: "1:00AM-2:00AM",
  9: "2:00AM-3:00AM",
  10: "3:00AM-4:00AM",
  11: "4:00AM-5:00AM",
};

const String teamwiseDataPath = 'assets/comb_df_2025-05-13.json';

Future<List<Map<String, dynamic>>> loadTeamwiseJsonData() async {
  final String response = await rootBundle.loadString(teamwiseDataPath);
  final List<dynamic> jsonData = json.decode(response);
  return List<Map<String, dynamic>>.from(jsonData);
}

String formatAgentName(String name) {
  if (name.isEmpty) return 'Unknown Agent';

  // Convert to lowercase for case-insensitive matching
  final lowerName = name.toLowerCase();

  // List of prefixes to remove
  final prefixes = ['m.', 'muhammad', 'syed', 'syeda'];

  // Split the name into words
  final words = name.split(' ');

  // Find the first word that's not a prefix
  for (var i = 0; i < words.length; i++) {
    final word = words[i].toLowerCase();
    if (!prefixes.contains(word) && word.length > 1) {
      // Return the first non-prefix word
      return words[i];
    }
  }

  // If all words are prefixes, return the last word
  return words.last;
}
