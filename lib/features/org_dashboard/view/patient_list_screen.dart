import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/org_dashboard/view/patient_detail_screen.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';

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
            child: ListView.builder(
              itemCount: MockData.patients.length,
              itemBuilder: (context, index) {
                final patient = MockData.patients[index];
                final initials = patient['name'].split(' ').take(2).map((e) => e[0]).join();
                return ListTile(
                  leading: CircleAvatar(child: Text(initials)),
                  title: Text(patient['name']),
                  subtitle: Text('ID: ${patient['id']} • ${patient['status']}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailScreen(isMedicalProfessional: _simulateMedicalRole),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
