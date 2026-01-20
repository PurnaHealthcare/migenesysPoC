import 'package:flutter/material.dart';

class OrgDashboardScreen extends StatelessWidget {
  const OrgDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MiGenesys Care Admin')),
      body: const Center(
        child: Text('Organization Overview & Analytics'),
      ),
    );
  }
}
