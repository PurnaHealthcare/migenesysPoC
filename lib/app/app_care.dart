import 'package:flutter/material.dart';
import 'package:migenesys_poc/core/theme/app_theme.dart';
import 'package:migenesys_poc/features/org_dashboard/view/org_dashboard_screen.dart';

class MiGenesysCareApp extends StatelessWidget {
  const MiGenesysCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiGenesys Care',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OrgDashboardScreen(),
    );
  }
}
