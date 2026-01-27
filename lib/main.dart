import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/auth/view/role_selection_screen.dart';
import 'package:migenesys_poc/core/theme/app_theme.dart';

// Dev entry point - runs Multi-Role Simulation
void main() {
  runApp(
    const ProviderScope(
      child: MultiRoleApp(),
    ),
  );
}

class MultiRoleApp extends StatelessWidget {
  const MultiRoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiGenesys Simulation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoleSelectionScreen(),
    );
  }
}
