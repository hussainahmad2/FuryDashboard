import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Get screen orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Check if device is a small screen
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Get appropriate font size based on screen size
  static double getFontSize(
    BuildContext context, {
    required double base,
    double scaleFactor = 1.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return base * 0.8 * scaleFactor;
    if (width < 600) return base * 0.9 * scaleFactor;
    if (width < 900) return base * scaleFactor;
    return base * 1.1 * scaleFactor;
  }

  // Get screen-size appropriate padding
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    double small = 8.0,
    double medium = 16.0,
    double large = 24.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return EdgeInsets.all(small);
    if (width < 600) return EdgeInsets.all(medium);
    return EdgeInsets.all(large);
  }

  // Get appropriate widget size based on screen orientation and size
  static double getResponsiveHeight(
    BuildContext context, {
    required double portrait,
    required double landscape,
  }) {
    return isPortrait(context) ? portrait : landscape;
  }

  // Get appropriate grid column count based on screen width
  static int getResponsiveGridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    if (isPortrait) {
      if (width < 400) return 1;
      if (width < 700) return 2;
      return 3;
    } else {
      if (width < 600) return 2;
      if (width < 900) return 3;
      return 4;
    }
  }
}
