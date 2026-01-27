import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/patient_view_model.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/dashboard_view_model.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/service_view_model.dart';
import 'package:migenesys_poc/features/org_dashboard/view/patient_detail_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/availability_model.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/patient_model.dart';

class PhysicianDashboardScreen extends ConsumerStatefulWidget {
  const PhysicianDashboardScreen({super.key});

  @override
  ConsumerState<PhysicianDashboardScreen> createState() => _PhysicianDashboardScreenState();
}

class _PhysicianDashboardScreenState extends ConsumerState<PhysicianDashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('DocAssist Physician Dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(allPatientsProvider);
    final kpisAsync = ref.watch(dashboardKpisProvider);

    // Default doctor for this demo (Sarah Connor, org1)
    const doctor = StaffModel(
      id: 's1',
      name: 'Sarah Connor',
      email: 's.connor@migenesys.com',
      role: 'Physician',
      isMedicalProfessional: true,
      orgId: 'org1',
      specialty: 'General Practice',
    );

    // Fetch availability for this doctor
    final availabilityAsync = ref.watch(serviceAvailabilityProvider(doctor.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('DocAssist Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => _showAlertsMenu(context, ref),
            icon: const Icon(Icons.warning_amber),
            color: Colors.amberAccent,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text('SC', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allPatientsProvider);
          ref.invalidate(dashboardKpisProvider);
          ref.invalidate(serviceAvailabilityProvider(doctor.id));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Dr. ${doctor.name.split(' ').last}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
              ),
              const SizedBox(height: 8),
              const Text('Here is what\'s happening with your practice today.'),
              const SizedBox(height: 24),

              // Staff Communication
              _buildCommunicationSection(),

              const SizedBox(height: 24),

              // KPI Section
              kpisAsync.when(
                data: (kpis) => SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kpis.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final kpi = kpis[index];
                      return _buildKpiCard(context, kpi.title, kpi.value, kpi.change);
                    },
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading stats: $e'),
              ),

              const SizedBox(height: 32),

              // Calendar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Schedule',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _showSurgeryBlockingDialog(context),
                    icon: const Icon(Icons.cut, size: 16),
                    label: const Text('Block Surgery'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildHorizontalCalendar(),
              const SizedBox(height: 24),

              // Clinic Visits Today Section
              const Text(
                'Clinic Visits Today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Combine patients and availability
              patientsAsync.when(
                data: (patients) {
                  return availabilityAsync.when(
                    data: (slots) {
                      final todayPatients = patients.where((p) => p.nextVisit == 'Today').toList();
                      return _buildVisitsTimeline(todayPatients, slots);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error loading schedule: $e'),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading patients: $e'),
              ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Patients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Patient List Section
              patientsAsync.when(
                data: (patients) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return _buildPatientCard(patient);
                  },
                ),
                loading: () => const SizedBox.shrink(), // Shown above already
                error: (e, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // 2 weeks
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(date, _selectedDate);
          final dayName = _getDayName(date.weekday);
          final dayNum = date.day.toString();

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.indigo : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.indigo : Colors.grey.shade200,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayNum,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisitsTimeline(List<PatientModel> patients, List<AvailabilityModel> slots) {
    if (patients.isEmpty && slots.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No visits or slots scheduled for today.'),
        ),
      );
    }

    return Column(
      children: [
        ...patients.map((p) => _buildTimelineItem(
              context,
              '09:00 AM', // Mock time for demo
              p.name,
              p.status,
              isAppointment: true,
              patient: p,
            )),
        ...slots.where((s) => !s.isBooked).map((s) => _buildTimelineItem(
              context,
              _formatTime(s.startTime),
              'Open Slot',
              'Available',
              isAppointment: false,
            )),
      ],
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String time,
    String title,
    String subtitle, {
    required bool isAppointment,
    PatientModel? patient,
  }) {
    return GestureDetector(
      onTap: !isAppointment ? () => _showSlotActionDialog(context) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: isAppointment ? Colors.indigo : Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 60,
                color: Colors.grey.shade200,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAppointment ? Colors.indigo.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAppointment ? Colors.indigo.shade900 : Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isAppointment ? Colors.indigo.shade700 : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isAppointment && patient != null)
                    IconButton(
                      onPressed: () {
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
                      icon: const Icon(Icons.arrow_forward_ios, size: 14),
                      color: Colors.indigo,
                    )
                  else if (!isAppointment)
                    const Icon(Icons.touch_app, size: 16, color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(PatientModel patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: Text(
            patient.initials,
            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('ID: ${patient.id} • ${patient.condition ?? "N/A"}'),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(patient.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                patient.status,
                style: TextStyle(
                  fontSize: 10,
                  color: _getStatusColor(patient.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
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
  }

  Widget _buildKpiCard(BuildContext context, String title, String value, String change) {
    final isPositive = change.startsWith('+');
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                change,
                style: TextStyle(
                  fontSize: 10,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAlertsMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.amber),
                SizedBox(width: 8),
                Text('Critical Medication Alerts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('The following patients have identified genetic risks or lab contraindications for their current medications.'),
            const SizedBox(height: 24),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.red, child: Text('JK', style: TextStyle(color: Colors.white))),
              title: const Text('James T. Kirk'),
              subtitle: const Text('Red Alert: Plavix (Genetic Inefficacy)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                final patientsAsync = ref.read(allPatientsProvider);
                patientsAsync.whenData((patients) {
                  final p = patients.firstWhere((p) => p.name == 'James T. Kirk');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDetailScreen(patientId: p.id, isMedicalProfessional: true)));
                });
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.orange, child: Text('BJ', style: TextStyle(color: Colors.white))),
              title: const Text('Benjamin Sisko'),
              subtitle: const Text('Warning: Lisinopril (Lab Value Conflict)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('Exam')) return Colors.orange;
    if (status.contains('Checked')) return Colors.blue;
    if (status.contains('Completed')) return Colors.green;
    return Colors.grey;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      case 7:
        return 'SUN';
      default:
        return '';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $ampm';
  }

  Widget _buildCommunicationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 20, color: Colors.indigo),
              SizedBox(width: 8),
              Text('Staff Communication', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
              Spacer(),
              Chip(
                label: Text('Staff Only', style: TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: Colors.indigo,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Type message to staff...',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: Icon(Icons.send, size: 20),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recent: "Surgery room B prep completed" - Nurse Joy (10m ago)', 
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  void _showSlotActionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Slot Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.green),
              title: const Text('Add Patient'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Redirecting to patient registration...')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block Slot'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot blocked successfully.')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSurgeryBlockingDialog(BuildContext context) {
    String? selectedAnesthesia;
    String? selectedNurse;
    String? selectedPatient;
    final patientController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Block Surgery'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Schedule surgery block and notify team.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 20),
                
                // Patient Search
                const Text('Patient Information', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Search Patient',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'James T. Kirk', child: Text('James T. Kirk (ID: P001)')),
                    DropdownMenuItem(value: 'Jean-Luc Picard', child: Text('Jean-Luc Picard (ID: P002)')),
                    DropdownMenuItem(value: 'Benjamin Sisko', child: Text('Benjamin Sisko (ID: P003)')),
                  ],
                  onChanged: (v) => setState(() => selectedPatient = v),
                ),
                if (selectedPatient != null)
                   Padding(
                     padding: const EdgeInsets.only(top: 8.0, left: 4),
                     child: Text('Condition: Cardiovascular Checkup', style: TextStyle(fontSize: 12, color: Colors.indigo.shade700)),
                   ),

                const SizedBox(height: 20),
                const Text('Surgical Team', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                
                // Anesthesiologist Search
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Anesthesiologist',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_search),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Dr. Spock', child: Text('Dr. Spock')),
                    DropdownMenuItem(value: 'Dr. House', child: Text('Dr. House')),
                    DropdownMenuItem(value: 'Dr. McCoy', child: Text('Dr. McCoy')),
                  ],
                  onChanged: (v) => setState(() => selectedAnesthesia = v),
                ),
                const SizedBox(height: 12),
                
                // Nurse Search
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Scrub Nurse / Staff',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_search),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Nurse Chapel', child: Text('Nurse Chapel')),
                    DropdownMenuItem(value: 'Nurse Joy', child: Text('Nurse Joy')),
                    DropdownMenuItem(value: 'Nurse Ogawa', child: Text('Nurse Ogawa')),
                  ],
                  onChanged: (v) => setState(() => selectedNurse = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: (selectedAnesthesia != null && selectedNurse != null && selectedPatient != null) ? () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Surgery Blocked for $selectedPatient. Notification sent to $selectedAnesthesia and $selectedNurse.'),
                    backgroundColor: Colors.green,
                  ),
                );
              } : null,
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Block & Notify Team'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
