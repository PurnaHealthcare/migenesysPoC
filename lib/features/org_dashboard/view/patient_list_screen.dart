import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/org_dashboard/view/patient_detail_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  // Toggle for testing RBAC
  bool _simulateMedicalRole = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // RBAC Simulation Toggle (For Testing)
          Container(
            color: Colors.amber.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Role Simulation:', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Text('Admin'),
                    Switch(
                      value: _simulateMedicalRole,
                      onChanged: (val) => setState(() => _simulateMedicalRole = val),
                    ),
                    const Text('Medical'),
                  ],
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Name, Email, or Phone',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (value) {
                // Mock search logic
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const CircleAvatar(child: Text('JD')),
                  title: const Text('John Doe'),
                  subtitle: const Text('ID: PAT-001 • In Waiting Room'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailScreen(isMedicalProfessional: _simulateMedicalRole),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(child: Text('AS')),
                  title: const Text('Alice Smith'),
                  subtitle: const Text('ID: PAT-002 • Completed'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailScreen(isMedicalProfessional: _simulateMedicalRole),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
