import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Fury/fury_main_home.dart';
import 'utils/safe_area_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable all orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI properties for better immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fury App',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        // Add proper text scaling to prevent text overflow
        textTheme: Typography.whiteMountainView.apply(
          fontSizeFactor: 1.0,
          fontSizeDelta: 0.0,
        ),
      ),
      builder: (context, child) {
        // Add this to prevent text scaling issues
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: SafeAreaWrapper(child: child!),
        );
      },
      home: const FuryHome(),
    );
  }
}
