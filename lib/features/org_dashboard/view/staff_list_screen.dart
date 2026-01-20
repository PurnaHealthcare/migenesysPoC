import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';
import 'add_staff_screen.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  // Mock Data
  final List<StaffModel> _staff = [
    StaffModel(id: '1', name: 'Dr. Smith', email: 'smith@clinic.com', role: 'Physician', isMedicalProfessional: true),
    StaffModel(id: '2', name: 'Jane Admin', email: 'jane@clinic.com', role: 'Clerk', isMedicalProfessional: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _staff.length,
        itemBuilder: (context, index) {
          final staff = _staff[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: staff.isMedicalProfessional ? Colors.blue.shade100 : Colors.grey.shade200,
              child: Icon(
                staff.isMedicalProfessional ? Icons.medical_services : Icons.admin_panel_settings,
                color: staff.isMedicalProfessional ? Colors.blue : Colors.grey[700],
              ),
            ),
            title: Text(staff.name),
            subtitle: Text(staff.email),
            trailing: Chip(
              label: Text(staff.isMedicalProfessional ? 'Medical' : 'Admin'),
              backgroundColor: staff.isMedicalProfessional ? Colors.blue.shade50 : Colors.grey.shade50,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStaffScreen()),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
