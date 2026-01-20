import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/theme/app_theme.dart';
import 'package:migenesys_poc/features/auth/view/splash_screen.dart';

class MiGenesysLifeApp extends StatelessWidget {
  const MiGenesysLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiGenesys Life', // Distinct title
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // Shared Auth/Splash for now
    );
  }
}
