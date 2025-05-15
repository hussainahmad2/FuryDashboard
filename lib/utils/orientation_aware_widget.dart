import 'package:flutter/material.dart';
import 'responsive_utils.dart';

class OrientationAwareWidget extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isPortrait,
    bool isSmallScreen,
  )
  builder;

  const OrientationAwareWidget({Key? key, required this.builder})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = ResponsiveUtils.isPortrait(context);
        final isSmallScreen = ResponsiveUtils.isSmallScreen(context);

        return builder(context, isPortrait, isSmallScreen);
      },
    );
  }
}

// Usage example:
// OrientationAwareWidget(
//   builder: (context, isPortrait, isSmallScreen) {
//     return Container(
//       height: isPortrait ? 200 : 150,
//       child: Text('Responsive Content'),
//     );
//   },
// ),
