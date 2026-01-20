import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/patient_view_model.dart';
import '../domain/staff_model.dart';
import 'patient_detail_screen.dart';

class MedicalDashboardScreen extends ConsumerStatefulWidget {
  final StaffModel user;
  const MedicalDashboardScreen({super.key, required this.user});

  @override
  ConsumerState<MedicalDashboardScreen> createState() => _MedicalDashboardScreenState();
}

class _MedicalDashboardScreenState extends ConsumerState<MedicalDashboardScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('Medical Dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(allPatientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. ${widget.user.name.split(' ').last}\'s Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            ),
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile coming soon')),
            ),
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (index) => Navigator.pop(context),
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text('Clinical Portal', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.people_alt),
            label: Text('My Patients'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.assignment),
            label: Text('Tasks & Review'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinical Stats
            Row(
              children: [
                _buildStatCard('Pending Reviews', '5', Colors.orange),
                const SizedBox(width: 10),
                _buildStatCard('Today\'s Appts', '8', Colors.blue),
                const SizedBox(width: 10),
                _buildStatCard('Critical Labs', '2', Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            const Text('My Patients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            patientsAsync.when(
              data: (myPatients) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myPatients.length,
                itemBuilder: (context, index) {
                  final patient = myPatients[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(patient.initials.isNotEmpty ? patient.initials : '?')),
                      title: Text(patient.name),
                      subtitle: Text('Status: ${patient.status} • Condition: ${patient.condition ?? "N/A"}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientDetailScreen(
                              patientId: patient.id,
                              isMedicalProfessional: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clinical notes coming soon')),
        ),
        icon: const Icon(Icons.note_add),
        label: const Text('Clinical Note'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
