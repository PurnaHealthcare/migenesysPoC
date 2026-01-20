import 'package:flutter/material.dart';
import 'package:migenesys_poc/core/theme/app_theme.dart';
import 'package:migenesys_poc/features/patient_mgmt/view/physician_dashboard_screen.dart';

class DocAssistApp extends StatelessWidget {
  const DocAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocAssist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const PhysicianDashboardScreen(),
    );
  }
}
