import 'package:flutter/material.dart';

class PharmaDashboardScreen extends StatelessWidget {
  const PharmaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MiGenesys Pharma'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_pharmacy, size: 64, color: Colors.teal),
            SizedBox(height: 16),
            Text(
              'Pharmacy Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Order Queue and Inventory Management coming soon.'),
          ],
        ),
      ),
    );
  }
}
