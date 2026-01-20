import 'package:flutter/material.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import '../domain/staff_model.dart';
import 'patient_detail_screen.dart';

class MedicalDashboardScreen extends StatefulWidget {
  final StaffModel user;
  const MedicalDashboardScreen({super.key, required this.user});

  @override
  State<MedicalDashboardScreen> createState() => _MedicalDashboardScreenState();
}

class _MedicalDashboardScreenState extends State<MedicalDashboardScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('Medical Dashboard');
  }

  @override
  Widget build(BuildContext context) {
    // Filter patients assigned to this provider or all patients if none strictly assigned (for demo)
    // In a real app, this would query backend for 'assignedTo: userId'
    // For Mock: We show all patients but highlight those 'Assigned to Me'
    final myPatients = MockData.patients; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. ${widget.user.name.split(' ').last}\'s Dashboard'),
        backgroundColor: Colors.teal, // Clinical feel
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (index) {},
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myPatients.length,
              itemBuilder: (context, index) {
                final patient = myPatients[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(patient['name'][0])),
                    title: Text(patient['name']),
                    subtitle: Text('Status: ${patient['status']} • Condition: ${patient['condition']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientDetailScreen(
                            patientId: patient['id'],
                            isMedicalProfessional: true, // Always true for this screen
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.5)),
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
