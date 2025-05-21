// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class SafeAreaWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets additionalPadding;

  const SafeAreaWrapper({
    Key? key,
    required this.child,
    this.additionalPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the safe area insets
    final mediaQuery = MediaQuery.of(context);
    final safePadding = mediaQuery.padding;

    // Add custom padding to handle any device-specific issues
    return Padding(
      padding: EdgeInsets.only(
        top: safePadding.top + additionalPadding.top,
        bottom: safePadding.bottom + additionalPadding.bottom,
        left: safePadding.left + additionalPadding.left,
        right: safePadding.right + additionalPadding.right,
      ),
      child: child,
    );
  }
}
