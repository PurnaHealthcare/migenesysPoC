import 'package:flutter/material.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/core/analytics/analytics_event.dart';
import '../../dashboard/view/widgets/vitals_timeline_graph.dart';

class PatientDetailScreen extends StatefulWidget {
  final bool isMedicalProfessional; // Logic to derive view
  final String? patientId;
  const PatientDetailScreen({super.key, required this.isMedicalProfessional, this.patientId});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    
    // Log initial screen view - Now starting with Clinical Tab (index 0)
    AnalyticsService().logScreenView('PatientDetails_ClinicalTab', role: widget.isMedicalProfessional ? 'Medical' : 'Admin');
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final tabNames = ['ClinicalTab', 'VaccinationsTab', 'AdminTab'];
      final tabName = tabNames[_tabController.index];
      AnalyticsService().logScreenView('PatientDetails_$tabName', role: widget.isMedicalProfessional ? 'Medical' : 'Admin');
      
      // Audit Log for Clinical Access
      if (_tabController.index == 0 && widget.isMedicalProfessional) {
        AnalyticsService().logEvent(AnalyticsEvent(
          action: 'ACCESS_PHI',
          category: 'COMPLIANCE',
          role: 'Medical',
          metadata: {'patient_id': widget.patientId ?? 'MOCK_ID'},
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
            Tab(text: 'Clinical'),
            Tab(text: 'Vaccinations'),
            Tab(text: 'Admin'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Clinical View (Now First) - Accessible to Medical Professionals
          widget.isMedicalProfessional 
              ? const _ClinicalTab() 
              : const _AccessRestrictedView(),

          // Tab 2: Vaccinations - Accessible to Medical Professionals
          widget.isMedicalProfessional 
              ? const _VaccinationsTab(patientAge: 45, patientGender: 'Male') 
              : const _AccessRestrictedView(),

          // Tab 3: Admin View - Accessible to All
          const _AdminTab(),
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
        _buildInfoRow('Name', 'James T. Kirk'),
        _buildInfoRow('DOB', '1980-03-22 (45 yrs)'),
        const Divider(),
        _buildSectionHeader('Contact & Insurance', canEdit: true),
        _buildInfoRow('Address', '1701 Starfleet Academy Drive'),
        _buildInfoRow('Phone', '(555) 170-1000'),
        _buildInfoRow('Insurance', 'Starfleet Health Plan'),
        _buildInfoRow('Policy #', 'NCC-1701-A'),
        const Divider(),
        _buildSectionHeader('Visit History', canEdit: false, action: 
          FilledButton.icon(
            onPressed: () {}, 
            icon: const Icon(Icons.calendar_today, size: 16),
            label: const Text('Schedule'),
          )
        ),
        _buildVisitCard('Cardiology Consultation', 'Dr. Connor', 'Oct 15, 2025', 'Completed'),
        _buildVisitCard('Follow-up', 'Dr. Connor', 'Feb 10, 2026', 'Scheduled'),
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
        leading: Icon(Icons.event_note, color: Colors.indigo.shade300),
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

// ==================== VACCINATIONS TAB ====================

class _VaccinationsTab extends StatelessWidget {
  final int patientAge;
  final String patientGender;
  
  const _VaccinationsTab({required this.patientAge, required this.patientGender});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Vaccination Status Section
        _buildSectionHeader('Vaccination Status', Icons.vaccines),
        const SizedBox(height: 12),
        _buildVaccineCard('COVID-19 (Pfizer)', 'Complete', '2 doses + booster', 'Dec 15, 2024', VaccineStatus.complete),
        _buildVaccineCard('Influenza 2025-26', 'Due', 'Annual flu shot', 'Due: Oct 2025', VaccineStatus.due),
        _buildVaccineCard('Tetanus/Tdap', 'Complete', 'Booster', 'Mar 2023', VaccineStatus.complete),
        _buildVaccineCard('Hepatitis B', 'Complete', '3-dose series', 'Completed 2020', VaccineStatus.complete),
        _buildVaccineCard('Shingles (Shingrix)', 'Due', 'Recommended at 50+', 'Not yet scheduled', VaccineStatus.due),
        _buildVaccineCard('Pneumococcal (PPSV23)', 'Overdue', 'Recommended for adults', 'Last: Never', VaccineStatus.overdue),
        
        const SizedBox(height: 32),
        
        // Vaccination Passport / e-Card Section
        _buildSectionHeader('Vaccination Passport', Icons.card_membership),
        const SizedBox(height: 12),
        _buildVaccinationPassport(context),
        
        const SizedBox(height: 32),
        
        // Preventive Care Section (Age/Gender specific)
        _buildSectionHeader('Preventive Care Screenings', Icons.health_and_safety),
        const SizedBox(height: 12),
        
        // Colonoscopy - Show for patients 40+
        if (patientAge >= 40)
          _buildScreeningCard(
            'Colonoscopy',
            'Recommended for adults 40+',
            'Last: Aug 2022',
            'Next Due: Aug 2032',
            Icons.monitor_heart,
            Colors.teal,
          ),
        
        // Pap Smear - Show for female patients only
        if (patientGender.toLowerCase() == 'female')
          _buildScreeningCard(
            'Pap Smear',
            'Cervical cancer screening',
            'Last: N/A',
            'Schedule recommended',
            Icons.female,
            Colors.pink,
          ),
        
        // General screenings for all
        _buildScreeningCard(
          'Lipid Panel',
          'Cholesterol screening',
          'Last: Jan 2026',
          'Annual',
          Icons.bloodtype,
          Colors.red,
        ),
        _buildScreeningCard(
          'Blood Pressure',
          'Cardiovascular screening',
          'Last: Jan 15, 2026',
          'Every visit',
          Icons.speed,
          Colors.indigo,
        ),
        
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }

  Widget _buildVaccineCard(String name, String status, String details, String date, VaccineStatus vaccineStatus) {
    Color statusColor;
    IconData statusIcon;
    
    switch (vaccineStatus) {
      case VaccineStatus.complete:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case VaccineStatus.due:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case VaccineStatus.overdue:
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(details, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationPassport(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VACCINATION PASSPORT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'James T. Kirk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'DOB: Mar 22, 1980',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_2, size: 50, color: Colors.indigo),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white30),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vaccines on Record', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('4 Complete • 2 Pending', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('📧 E-Card sent to patient email')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Share', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('📥 Downloading vaccination e-card...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScreeningCard(String title, String description, String lastDate, String nextDue, IconData icon, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 2),
            Text('$lastDate • $nextDue', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.calendar_month, color: Colors.indigo),
          onPressed: () {},
          tooltip: 'Schedule',
        ),
      ),
    );
  }
}

enum VaccineStatus { complete, due, overdue }

class _ClinicalTab extends StatefulWidget {
  const _ClinicalTab();

  @override
  State<_ClinicalTab> createState() => _ClinicalTabState();
}

class _ClinicalTabState extends State<_ClinicalTab> with SingleTickerProviderStateMixin {
  // Gated Logic State
  bool _isProSubscribed = false;
  bool _isListening = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_glowController);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _startListeningSimulation() {
    setState(() => _isListening = true);
    _showToast(context, '🎤 AI Listening: Capturing clinical conversation...');
  }

  void _showESignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.draw, color: Colors.indigo),
            SizedBox(width: 8),
            Text('e-Sign Clinic Note'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('By signing, you confirm the clinical note is complete and accurate.'),
            const SizedBox(height: 16),
            Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Signature Area', style: TextStyle(color: Colors.grey))),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast(context, '✅ Note signed and locked by Dr. Connor');
            },
            child: const Text('Sign & Lock'),
          ),
        ],
      ),
    );
  }

  Widget _buildAIGeneratedNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🧠 AI-Generated Clinical Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo)),
        const Divider(),
        const Text('📋 HISTORY OF PRESENT ILLNESS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const Text('45 y/o male with acute MI, s/p PCI 3 months ago. Reports improved exercise tolerance but occasional chest tightness with exertion. No orthopnea or PND.', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        const Text('📊 INTERVAL HISTORY:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const Text('Adherent to Plavix, Atorvastatin, Carvedilol, Lisinopril. No hospital admissions. Labs show stable creatinine at 1.2, LDL reduced to 72.', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        const Text('💡 RECOMMENDATIONS (DocAssist Pro):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
        const Text('• STOP Plavix → START Prasugrel (CYP2C19 poor metabolizer)\n• STOP Atorvastatin → START Rosuvastatin (myopathy risk)\n• Reduce Lisinopril (Cr 1.2, monitor for hyperkalemia)\n• Cardiology referral: Repeat angiogram in 6 months\n• Lifestyle: Daily water intake < 2L', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pro Subscription Glowing Banner
        if (!_isProSubscribed)
          ScaleTransition(
            scale: _glowAnimation,
            child: GestureDetector(
              onTap: () => _showSubscriptionPrompt(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.red.withValues(alpha: 0.4), blurRadius: 15, spreadRadius: 5),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Important genetic risk and personalized information for this patient is missing, subscribe to DoAssist Pro to unlock recommendations.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Banner for Medical Professional
        Container(
          color: Colors.green.shade50,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          child: const Row(
            children: [
              Icon(Icons.verified_user, color: Colors.green),
              SizedBox(width: 8),
              Text('Medical Professional Access', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // Diagnosis Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Diagnosis: ICD-10', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
            Row(
              children: [
                _buildToolIcon(context, Icons.science, 'Labs', 'View the PDF\n\nSummary of labs for DocAssist-Pro users'),
                const SizedBox(width: 8),
                _buildToolIcon(context, Icons.description, 'Documents', '📁 PDF Icon: james_kirk_history.pdf\n\nSummary of documents for DocAssist Pro users'),
                const SizedBox(width: 8),
                _buildToolIcon(context, Icons.image_search, 'Imaging', 'Reports view:\n- Chest X-Ray (10/15/25)\n- Cardiac MRI (Pending)'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildDiagnosisChip('I21.9', 'Acute Myocardial Infarction'),
            _buildDiagnosisChip('I10', 'Essential Hypertension'),
            _buildDiagnosisChip('E11.9', 'Type 2 Diabetes Mellitus'),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Add Diagnosis'),
              onPressed: () {},
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Medications Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Medications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
            if (_isProSubscribed)
              TextButton(
                onPressed: () => _showCorrectionDialog(context),
                child: const Text('Resolve Risk Alerts', style: TextStyle(decoration: TextDecoration.underline)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _buildMedCard('Plavix', '75mg daily', color: _isProSubscribed ? Colors.red : null, dnaRed: _isProSubscribed, labRed: false, drugRed: false),
        _buildMedCard('Atorvastatin', '10mg nightly', color: _isProSubscribed ? Colors.orange : null, dnaRed: false, labRed: false, drugRed: _isProSubscribed),
        _buildMedCard('Carvedilol', '12.5mg twice daily', color: _isProSubscribed ? Colors.green : null, dnaRed: false, labRed: false, drugRed: false),
        _buildMedCard('Lisinopril', '10mg daily', color: _isProSubscribed ? Colors.orange : null, dnaRed: false, labRed: _isProSubscribed, drugRed: false),

        const SizedBox(height: 16),
        // Prescribe Options
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showToast(context, 'New Rx form opened...'),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Prescription'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showToast(context, 'Refill request sent to pharmacy...'),
                icon: const Icon(Icons.repeat),
                label: const Text('Order Refills'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Clinic Notes Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Clinic Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic, color: _isListening ? Colors.red : Colors.indigo),
                  onPressed: _isProSubscribed ? () => _startListeningSimulation() : () => _showSubscriptionPrompt(context),
                  tooltip: _isProSubscribed ? 'Turn on autolistening' : 'Pro feature',
                ),
                if (_isProSubscribed)
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    onPressed: () => _showESignDialog(context),
                    tooltip: 'e-Sign Note',
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: _isProSubscribed && _isListening
              ? _buildAIGeneratedNote()
              : _isProSubscribed
                  ? const TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Create your note here or tap mic icon to start AI-assisted note taking...',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 14),
                    )
                  : const Text('Subscribe to DocAssist Pro to enable AI-assisted clinic notes with voice-to-text and smart summaries.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
        ),

        const SizedBox(height: 32),

        // Vitals Section
        const Text('Clinical Vitals & Trends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
        const SizedBox(height: 16),
        _buildVitalTrendItem('Blood Pressure', '124/82 mmHg', Icons.speed),
        _buildVitalTrendItem('Pulse', '72 bpm', Icons.favorite_border),
        _buildVitalTrendItem('Temperature', '98.6 °F', Icons.thermostat),
        _buildVitalTrendItem('SpO2', '98%', Icons.bloodtype_outlined),
        
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDiagnosisChip(String code, String label) {
    return Chip(
      label: Text('$code: $label'),
      backgroundColor: Colors.indigo.shade50,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.indigo),
    );
  }

  void _showSubscriptionPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DocAssist Pro 🧬'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('MiGenesis DocAssist Pro provides real-time genetic risk analysis, lab integration checks, and drug-drug interaction alerts.'),
            SizedBox(height: 16),
            Text('Would you like to subscribe for \$49.99/mo per provider to unlock all clinical insights?'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Later')),
          ElevatedButton(
            onPressed: () {
              setState(() => _isProSubscribed = true);
              Navigator.pop(context);
            },
            child: const Text('Subscribe Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildToolIcon(BuildContext context, IconData icon, String title, String content) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: Colors.indigo),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 4)));
  }

  Widget _buildMedCard(String name, String dosage, {Color? color, bool dnaRed = false, bool labRed = false, bool drugRed = false}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color ?? Colors.black)),
                    Text(dosage, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
                Row(
                  children: [
                    _buildRiskIcon(Icons.biotech, dnaRed), // DNA
                    const SizedBox(width: 8),
                    _buildRiskIcon(Icons.science, labRed), // Lab
                    const SizedBox(width: 8),
                    _buildRiskIcon(Icons.medication_liquid, drugRed), // Drug-Drug
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskIcon(IconData icon, bool isRed) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isRed ? Colors.red.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isRed ? Colors.red.shade200 : Colors.grey.shade200),
      ),
      child: Icon(icon, size: 18, color: isRed ? Colors.red : Colors.grey),
    );
  }

  Widget _buildVitalTrendItem(String title, String value, IconData icon) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.indigo),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              const Icon(Icons.show_chart, color: Colors.indigo),
            ],
          ),
        ),
        VitalsTimelineGraph(title: title),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showCorrectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manual Color Override', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Select a medication to manually adjust its risk status displayed on the patient dashboard.'),
            const SizedBox(height: 24),
            ...['Plavix', 'Atorvastatin', 'Lisinopril'].map((med) => ListTile(
              title: Text(med),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _circle(Colors.red),
                  _circle(Colors.orange),
                  _circle(Colors.green),
                ],
              ),
              onTap: () => Navigator.pop(context),
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _circle(Color color) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
