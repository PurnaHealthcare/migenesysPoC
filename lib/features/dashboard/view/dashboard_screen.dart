import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/health_journey/view/health_journey_screen.dart';
import 'widgets/organ_system_grid.dart';
import 'widgets/profile_menu.dart';
import '../view_model/vitals_provider.dart';
import '../view_model/allergies_provider.dart';
import 'screens/my_docs_screen.dart';
import 'screens/vitals_screen.dart';
import 'screens/provider_map_screen.dart';
import 'screens/my_providers_screen.dart';
import 'screens/vitals/bmi_screen.dart';
import 'screens/vitals/blood_pressure_screen.dart';
import 'screens/vitals/blood_glucose_screen.dart';
import 'screens/vitals/pulse_screen.dart';
import 'screens/vitals/respiratory_rate_screen.dart';
import 'screens/subscription_screen.dart';
import '../view_model/subscription_provider.dart';
import 'dart:math' as math;
import 'screens/nutrigenomica_report_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final double _completionRatio = 0.6; 

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('MiGenomica Report'),
        content: const SizedBox(
          height: 300,
          child: Column(
            children: [
              Icon(Icons.picture_as_pdf, size: 60, color: Colors.red),
              SizedBox(height: 20),
              Text('Report Content Placeholder...'),
              Spacer(),
              LinearProgressIndicator(),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(onPressed: () {
            // Check for subscription? For now just mock download
          }, child: const Text('Download PDF')),
        ],
      ),
    );
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileMenu(),
    );
  }

  void _showMyIdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Information?'),
        content: const Text('Do you want to share your health information?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showShareOptionsDialog();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showShareOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 150),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () { Navigator.pop(context); }, child: const Text('Share All Data')),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); }, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[100], foregroundColor: Colors.blue[900]),
              child: const Text('Family share 👨‍👩‍👧‍👦')
            ),
            TextButton(onPressed: () { Navigator.pop(context); }, child: const Text('Choose Data Points')),
          ],
        ),
      ),
    );
  }

  void _showCalendarDialog() {
    final now = DateTime.now();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My Calendar 📅'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('January ${now.year}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(31, (index) {
                final day = index + 1;
                final isSpecial = day == 20 || day == 22;
                return GestureDetector(
                  onTap: isSpecial ? () {
                    Navigator.pop(context);
                    _showAppointmentDetails(day);
                  } : null,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSpecial ? Border.all(color: Colors.red, width: 2) : null,
                      color: day == now.day ? Colors.blue[100] : null,
                    ),
                    alignment: Alignment.center,
                    child: Text('$day', style: TextStyle(color: isSpecial ? Colors.red : null, fontWeight: isSpecial ? FontWeight.bold : null)),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(int day) {
    final doctors = ['Dr. Nelson Maldonado', 'Dr. Cardidad Davalos', 'Dr. Alvaro Davalos', 'Dr. Alberto Cardenas'];
    final doctor = doctors[day % doctors.length];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 50, color: Colors.blue[700]),
            const SizedBox(height: 16),
            Text('Appointment with $doctor', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Time: 10:30 AM'),
            const Text('Location: Main Clinic, Tower A'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAlertsDialog() {
    final alerts = [
      'Blood pressure readings higher than normal today.',
      'Blood glucose check due in 30 minutes.',
      'Flu vaccination due next week.',
      'Refill for Atorvastatin is ready.',
      'Medication alert: Plavix dose missed.',
    ];
    alerts.shuffle();
    final selectedAlerts = alerts.take(3).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Alerts 🔔'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...selectedAlerts.map((alert) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                title: Text(alert, style: const TextStyle(fontSize: 14)),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            )),
            const Divider(),
            const Text('Sign up for premium insights:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen(overlayTitle: 'MiGenomica 360')));
              },
              child: const Text('Sign up for MiGenomica 360'),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen(overlayTitle: 'MiGenesys Assist')));
              },
              child: const Text('Sign up for MiGenesys Assist'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMissingFieldsDialog() {
    // Mock logic for missing fields based on completion ratio
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Your Profile'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are missing the following information:'),
            SizedBox(height: 10),
            Text('• Family History', style: TextStyle(color: Colors.red)),
            Text('• Recent Blood Work', style: TextStyle(color: Colors.red)),
            Text('• Allergies Confirmation', style: TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
  
  // --- COLOR LOGIC HELPERS ---

  Color _getBMIColor(double? bmi) {
    if (bmi == null) return Colors.grey;
    if (bmi < 25.0) return Colors.green;
    if (bmi < 30.0) return Colors.amber; 
    if (bmi < 40.0) return Colors.red;
    return Colors.purple;
  }

  Color _getBPColor(int? sys, int? dia) {
    if (sys == null || dia == null) return Colors.grey;
    if (sys > 150 || sys < 100 || dia > 90 || dia < 60) return Colors.red;
    if ((sys >= 135 && sys <= 149) || (dia >= 81 && dia <= 90)) return Colors.orange;
    return Colors.green;
  }

  Color _getGlucoseColor(int? bg) {
    if (bg == null) return Colors.grey;
    if (bg < 90 || bg > 180) return Colors.red;
    if (bg >= 141 && bg <= 180) return Colors.orange;
    return Colors.green;
  }

  Color _getPulseColor(int? pulse) {
    if (pulse == null) return Colors.grey;
    if (pulse > 160 || pulse < 50) return Colors.red;
    if ((pulse >= 141 && pulse <= 160) || (pulse >= 51 && pulse <= 60)) return Colors.orange;
    return Colors.green;
  }
  
  Color _getRespiratoryColor(int? rate) {
    if (rate == null) return Colors.grey;
    if (rate >= 12 && rate <= 20) return Colors.green; // Normal
    return Colors.red; // Abnormal
  }

  Widget _buildOrbitingIcon(IconData icon, String label, Color color, VoidCallback onTap, double angle, double radius) {
    return Transform.translate(
      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 2),
                ],
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                label, 
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap, {Color? color}) {
     return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                 BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
              ]
            ),
            child: Icon(icon, color: color ?? const Color(0xFF0277BD), size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vitalsState = ref.watch(vitalsProvider);
    final allergies = ref.watch(allergiesProvider);
    final hasAllergies = allergies.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Healthcentral'),
        elevation: 0,
        backgroundColor: Colors.transparent, 
        foregroundColor: Colors.white, 
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: _showCalendarDialog,
              tooltip: 'Calendar',
            ),
            IconButton(
              icon: const Icon(Icons.notifications_active),
              onPressed: _showAlertsDialog,
              tooltip: 'Alerts',
            ),
          ],
        ),
        leadingWidth: 100,
        actions: [
          // Allergy Icon
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.coronavirus, 
                color: hasAllergies ? Colors.red : Colors.green,
              ),
            ),
          ),
          // Call Icon -> My Providers
          IconButton(
            icon: const Icon(Icons.phone_in_talk), 
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProvidersScreen()));
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4FC3F7), // Light Blue
              Color(0xFF81C784), // Light Green
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // --- 1. Artistic Circular Layout ---
                SizedBox(
                  height: 320, 
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Center Avatar
                      GestureDetector(
                        onTap: _showProfileMenu,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, spreadRadius: 5)
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/avatar.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      
                      // Orbiting Icons
                      // BMI (Top Left)
                      _buildOrbitingIcon(
                        Icons.monitor_weight, 'BMI', 
                        _getBMIColor(vitalsState.bmi),
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BmiScreen())),
                        -3 * math.pi / 4, 
                        130
                      ),
                      // BP (Top Right)
                      _buildOrbitingIcon(
                        Icons.favorite, 'BP', 
                        _getBPColor(vitalsState.bpSystolic, vitalsState.bpDiastolic),
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodPressureScreen())),
                        -math.pi / 4, 
                        130
                      ),
                      // Glucose (Bottom Left)
                      _buildOrbitingIcon(
                        Icons.water_drop, 'Glucose',
                        _getGlucoseColor(vitalsState.bloodGlucose), 
                         () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodGlucoseScreen())),
                        3 * math.pi / 4, 
                        130
                      ),
                      // Pulse (Bottom Right)
                      _buildOrbitingIcon(
                        Icons.monitor_heart, 'Pulse', 
                        _getPulseColor(vitalsState.pulse),
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PulseScreen())),
                        math.pi / 4, 
                        130
                      ),
                      // Respiratory (Bottom Center)
                       _buildOrbitingIcon(
                        Icons.air, 'Resp Rate', 
                        _getRespiratoryColor(vitalsState.respiratoryRate),
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RespiratoryRateScreen())),
                        math.pi / 2, 
                        130
                      ),
                      // Nutrition (Top Center - Orbiting)
                      _buildOrbitingIcon(
                        Icons.restaurant, 'Nutrition', 
                        Colors.teal,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NutrigenomicaReportScreen())),
                        -math.pi / 2, 
                        130
                      ),
                    ],
                  ),
                ),
                
                // Report Button
                ElevatedButton(
                  onPressed: _showReportDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0277BD),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('View My Report 📄'),
                ),
                
                const SizedBox(height: 30),
                
                // --- 2. Action Icons (MiGenesys ID, My Docs, Meds) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionIcon(Icons.badge, 'MiGenesys ID', _showMyIdDialog),
                      _buildActionIcon(Icons.folder_shared, 'My Docs', () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDocsScreen()));
                      }),
                      _buildActionIcon(Icons.medication, 'Medications', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthJourneyScreen()));
                      }),
                       // Vitals Menu Link (Restored)
                       _buildActionIcon(Icons.apps, 'All Vitals', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const VitalsScreen()));
                      }),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // --- 2b. Overlay Actions (360, Assist) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       _buildActionIcon(Icons.auto_awesome, '360', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen(overlayTitle: 'MiGenomica 360')));
                      }, color: Colors.red),
                      const SizedBox(width: 40),
                      _buildActionIcon(Icons.assistant, 'Assist', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen(overlayTitle: 'MiGenesys Assist')));
                      }, color: Colors.red),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                // --- 3. Completion Bar (Clickable) ---
                GestureDetector(
                  onTap: _showMissingFieldsDialog,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Profile Completeness', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${(_completionRatio * 100).toInt()}%'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _completionRatio,
                          backgroundColor: Colors.grey[200],
                          color: Colors.green,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap to see what is missing! 🚀', 
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // --- 4. Organ Systems (Header Renamed) ---
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'Your Organs', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                      ),
                      const OrganSystemGrid(),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
