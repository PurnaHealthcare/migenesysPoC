import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/view/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MiGenesysApp(),
    ),
  );
}

class MiGenesysApp extends StatelessWidget {
  const MiGenesysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiGenesys',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF64B5F6), // Soft Blue
          primary: const Color(0xFF64B5F6),
          secondary: const Color(0xFF81C784), // Gentle Green
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
