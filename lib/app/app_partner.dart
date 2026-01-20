import 'package:flutter/material.dart';
import 'package:migenesys_poc/core/theme/app_theme.dart';
import 'package:migenesys_poc/features/inventory/view/partner_dashboard_screen.dart';

class MiGenesysPartnerApp extends StatelessWidget {
  const MiGenesysPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiGenesys Partner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const PartnerDashboardScreen(),
    );
  }
}
