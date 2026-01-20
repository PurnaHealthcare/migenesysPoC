import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/org_dashboard/view/care_login_screen.dart';

class MiGenesysCareApp extends StatelessWidget {
  const MiGenesysCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiGenesys Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // Enterprise Blue
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF0D47A1),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const CareLoginScreen(),
    );
  }
}
