import 'package:flutter/material.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/core/analytics/analytics_event.dart';




class PatientDetailScreen extends StatefulWidget {
  final bool isMedicalProfessional; // Logic to derive view
  const PatientDetailScreen({super.key, required this.isMedicalProfessional});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    
    // Log initial screen view
    AnalyticsService().logScreenView('PatientDetails_AdminTab', role: widget.isMedicalProfessional ? 'Medical' : 'Admin');
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final tabName = _tabController.index == 0 ? 'AdminTab' : 'ClinicalTab';
      AnalyticsService().logScreenView('PatientDetails_$tabName', role: widget.isMedicalProfessional ? 'Medical' : 'Admin');
      
      // Audit Log for Clinical Access
      if (_tabController.index == 1 && widget.isMedicalProfessional) {
        AnalyticsService().logEvent(AnalyticsEvent(
          action: 'ACCESS_PHI',
          category: 'COMPLIANCE',
          role: 'Medical',
          metadata: {'patient_id': 'MOCK_ID'}, // In real app, pass ID
        ));
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Admin / Demographics'),
            Tab(text: 'Clinical'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Admin View (Accessible to All)
          const _AdminTab(),
          
          // Tab 2: Clinical View (Restricted)
          widget.isMedicalProfessional 
              ? const _ClinicalTab() 
              : const _AccessRestrictedView(),
        ],
      ),
    );
  }
}

class _AdminTab extends StatelessWidget {
  const _AdminTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Personal Information', canEdit: true),
        _buildInfoRow('Name', 'John Doe'),
        _buildInfoRow('DOB', '1980-05-15 (45 yrs)'),
        const Divider(),
        _buildSectionHeader('Contact & Insurance', canEdit: true),
        _buildInfoRow('Address', '123 Main St, Springfield'),
        _buildInfoRow('Phone', '(555) 123-4567'),
        _buildInfoRow('Insurance', 'BlueCross BlueShield'),
        _buildInfoRow('Policy #', 'BC-123456789'),
        const Divider(),
        _buildSectionHeader('Visit History', canEdit: false, action: 
          FilledButton.icon(
            onPressed: () {}, 
            icon: const Icon(Icons.calendar_today, size: 16),
            label: const Text('Schedule'),
          )
        ),
        _buildVisitCard('General Checkup', 'Dr. Smith', 'Oct 15, 2025', 'Completed'),
        _buildVisitCard('Follow-up', 'Dr. Smith', 'Nov 20, 2025', 'Scheduled'),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required bool canEdit, Widget? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          if (action != null) action,
          if (canEdit && action == null)
            TextButton.icon(
              onPressed: () {}, // Mock Edit
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit'),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildVisitCard(String title, String provider, String date, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.event_note, color: Colors.blue.shade300),
        title: Text(title),
        subtitle: Text('$provider • $date'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status == 'Completed' ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: status == 'Completed' ? Colors.green[800] : Colors.orange[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ClinicalTab extends StatelessWidget {
  const _ClinicalTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Banner for Medical Professional
        Container(
          color: Colors.green.shade50,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 16),
          child: const Row(
            children: [
              Icon(Icons.verified_user, color: Colors.green),
              SizedBox(width: 8),
              Text('Medical Access Granted', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Text('Current Medications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Card(child: ListTile(title: Text('Lisinopril'), subtitle: Text('10mg daily'), trailing: Icon(Icons.edit))),
        const Card(child: ListTile(title: Text('Atorvastatin'), subtitle: Text('20mg nightly'), trailing: Icon(Icons.edit))),
        const SizedBox(height: 16),
        const Text('Recent Vitals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Card(child: ListTile(title: Text('Blood Pressure'), subtitle: Text('120/80 mmHg'), trailing: Text('Today'))),
      ],
    );
  }
}

class _AccessRestrictedView extends StatelessWidget {
  const _AccessRestrictedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Access Restricted',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Clinical data is only visible to Medical Professionals.\nContact your Administrator if this is an error.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
