import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/provider_map_screen.dart';

class MyProvidersScreen extends StatelessWidget {
  const MyProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Providers')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProviderCard(context, 'Dr. Sarah Smith', 'Cardiologist', '1.2 miles away'),
                _buildProviderCard(context, 'Dr. James Doe', 'General Practitioner', '3.5 miles away'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ProviderMapScreen()));
                },
                icon: const Icon(Icons.map),
                label: const Text('Find a Provider'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64B5F6),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(BuildContext context, String name, String speciality, String distance) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(child: Text(name[4])), // First letter of name
        title: Text(name),
        subtitle: Text('$speciality • $distance'),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: () {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling $name...')));
          },
        ),
      ),
    );
  }
}
