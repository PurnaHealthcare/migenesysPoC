import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/staff_view_model.dart';
import 'add_staff_screen.dart';

class StaffListScreen extends ConsumerStatefulWidget {
  final String orgId;
  const StaffListScreen({super.key, required this.orgId});

  @override
  ConsumerState<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends ConsumerState<StaffListScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('Staff Management');
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(staffListProvider(widget.orgId));

    return Scaffold(
      body: staffAsync.when(
        data: (staff) => ListView.builder(
          itemCount: staff.length,
          itemBuilder: (context, index) {
            final member = staff[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: member.isMedicalProfessional ? Colors.blue.shade100 : Colors.grey.shade200,
                child: Icon(
                  member.isMedicalProfessional ? Icons.medical_services : Icons.admin_panel_settings,
                  color: member.isMedicalProfessional ? Colors.blue : Colors.grey[700],
                ),
              ),
              title: Text(member.name),
              subtitle: Text(member.email),
              trailing: Chip(
                label: Text(member.isMedicalProfessional ? 'Medical' : 'Admin'),
                backgroundColor: member.isMedicalProfessional ? Colors.blue.shade50 : Colors.grey.shade50,
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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
