import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF64B5F6), // Soft Blue
        primary: const Color(0xFF64B5F6),
        secondary: const Color(0xFF81C784), // Gentle Green
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
    );
  }
}
