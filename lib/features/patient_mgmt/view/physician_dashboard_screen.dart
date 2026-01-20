import 'package:flutter/material.dart';

class PhysicianDashboardScreen extends StatelessWidget {
  const PhysicianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DocAssist Dashboard')),
      body: const Center(
        child: Text('Welcome, Doctor. Manage your patients here.'),
      ),
    );
  }
}
