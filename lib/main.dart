import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const DapurDewataApp());
}

class DapurDewataApp extends StatelessWidget {
  const DapurDewataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dapur Dewata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC0392B),
          brightness: Brightness.light,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}