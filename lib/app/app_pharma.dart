import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/pharmacy_dashboard/view/pharma_dashboard_screen.dart';

class MiGenesysPharmaApp extends StatelessWidget {
  const MiGenesysPharmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiGenesys Pharma',
      theme: AppTheme.lightTheme, // Reusing existing theme
      home: const PharmaDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
