import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/org_dashboard/view/patient_detail_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/patient_view_model.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  bool _simulateMedicalRole = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(searchPatientsProvider(_searchQuery));

    return Scaffold(
      body: Column(
        children: [
          // RBAC Simulation Toggle (Only in Debug Mode)
          if (kDebugMode)
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
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: patientsAsync.when(
              data: (patients) => ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(patient.initials.isNotEmpty ? patient.initials : '?')),
                    title: Text(patient.name),
                    subtitle: Text('ID: ${patient.id} • ${patient.status}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientDetailScreen(
                            patientId: patient.id,
                            isMedicalProfessional: _simulateMedicalRole,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
