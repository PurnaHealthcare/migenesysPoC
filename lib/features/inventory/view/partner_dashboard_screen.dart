import 'package:flutter/material.dart';

class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MiGenesys Partner Portal')),
      body: const Center(
        child: Text('Inventory & Orders Management'),
      ),
    );
  }
}
