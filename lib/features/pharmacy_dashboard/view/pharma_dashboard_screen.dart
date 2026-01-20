import 'package:flutter/material.dart';

class PharmaDashboardScreen extends StatelessWidget {
  const PharmaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Order Queue'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderCard(
            context,
            patientName: 'John Doe',
            medication: 'Lisinopril 10mg',
            status: 'New Request',
            time: '10 mins ago',
            isUrgent: true,
          ),
          _buildOrderCard(
            context,
            patientName: 'Alice Smith',
            medication: 'Atorvastatin 20mg',
            status: 'Processing',
            time: '1 hour ago',
            isUrgent: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Scan QR Code or Add Manual Order
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, {
    required String patientName,
    required String medication,
    required String status,
    required String time,
    required bool isUrgent,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isUrgent ? Colors.red.shade50 : Colors.blue.shade50,
          child: Icon(
            Icons.medication,
            color: isUrgent ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medication),
            Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                color: status == 'New Request' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isUrgent)
              const Text('URGENT', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        onTap: () {
          // Open Order Details
        },
      ),
    );
  }
}
