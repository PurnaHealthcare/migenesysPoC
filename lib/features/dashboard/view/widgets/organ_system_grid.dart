import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/vitals_provider.dart';
import '../../view_model/subscription_provider.dart';
import 'package:migenesys_poc/features/health_journey/view_model/health_journey_view_model.dart';
import 'package:migenesys_poc/features/health_journey/view/health_journey_screen.dart';
import '../screens/vitals/blood_pressure_screen.dart';
import '../screens/vitals/pulse_screen.dart';

class OrganSystemGrid extends ConsumerWidget {
  const OrganSystemGrid({super.key});

  final List<Map<String, dynamic>> _organs = const [
    {'name': 'Cardiovascular', 'icon': Icons.favorite, 'color': Colors.red},
    {'name': 'Neurology', 'icon': Icons.psychology, 'color': Colors.pink}, 
    {'name': 'Respiratory', 'icon': Icons.air, 'color': Colors.blue}, 
    {'name': 'Gastro', 'icon': Icons.lunch_dining, 'color': Colors.orange}, 
    {'name': 'Renal', 'icon': Icons.water_drop, 'color': Colors.brown}, 
    {'name': 'Endocrine', 'icon': Icons.opacity, 'color': Colors.purple},
    {'name': 'Ob/Gyn', 'icon': Icons.pregnant_woman, 'color': Colors.pinkAccent},
    {'name': 'Psychiatry', 'icon': Icons.theater_comedy, 'color': Colors.deepPurple},
    {'name': 'Orthopedics', 'icon': Icons.accessibility_new, 'color': Colors.blueGrey},
  ];

  Color _getBPColor(int? sys, int? dia) {
    if (sys == null || dia == null) return Colors.green;
    if (sys > 150 || sys < 100 || dia > 90 || dia < 60) return Colors.red;
    return Colors.green;
  }

  Color _getPulseColor(int? pulse) {
    if (pulse == null) return Colors.green;
    if (pulse > 160 || pulse < 50) return Colors.red;
    return Colors.green;
  }

  void _showDiagnosisDialog(BuildContext context, String organName, Color bgColor, VitalsState vitals, bool isPlavixRed) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        bool isRed = bgColor != Colors.white;
        String? reason;
        VoidCallback? onReasonTap;

        if (isRed) {
          if (organName == 'Cardiovascular') {
            if (isPlavixRed) {
               reason = 'Please check your medications (Plavix risk identified).';
               onReasonTap = () {
                 Navigator.pop(context);
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthJourneyScreen()));
               };
            } else {
               reason = 'Please check your vitals (Abnormal readings).';
               onReasonTap = () {
                 Navigator.pop(context);
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodPressureScreen()));
               };
            }
          } else if (organName == 'Neurology' && isPlavixRed) {
            reason = 'Please check your medications (Genetic risk detected).';
            onReasonTap = () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthJourneyScreen()));
            };
          }
        }

        return AlertDialog(
          title: Text('$organName Diagnosis'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (reason != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: onReasonTap,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red)),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(reason, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13))),
                        ],
                      ),
                    ),
                  ),
                ),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter diagnosis...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved $organName diagnosis: ${controller.text}')),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vitalsState = ref.watch(vitalsProvider);
    final isSubscribed = ref.watch(subscriptionProvider);
    
    // Check if Plavix is "Red" (using the same logic as medication list)
    bool isPlavixRed = false;
    if (isSubscribed) {
      final journeysAsync = ref.watch(healthJourneysProvider);
      journeysAsync.whenData((journeys) {
        for (var journey in journeys) {
          for (var med in journey.medications) {
            if (med.brandName == 'Plavix') {
              isPlavixRed = true;
            }
          }
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Organ Systems',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF455A64)),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: _organs.length,
          itemBuilder: (context, index) {
            final organ = _organs[index];
            
            // Dynamic Background Color Logic
            Color bgColor = Colors.white;
            if (organ['name'] == 'Cardiovascular') {
              final bpColor = _getBPColor(vitalsState.bpSystolic, vitalsState.bpDiastolic);
              final pulseColor = _getPulseColor(vitalsState.pulse);
              if (bpColor == Colors.red || pulseColor == Colors.red || isPlavixRed) {
                bgColor = Colors.red.withOpacity(0.2);
              }
            } else if (organ['name'] == 'Neurology' && isPlavixRed) {
              bgColor = Colors.red.withOpacity(0.2);
            }

            return InkWell(
              onTap: () => _showDiagnosisDialog(context, organ['name'], bgColor, vitalsState, isPlavixRed),
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: bgColor != Colors.white ? Border.all(color: Colors.red, width: 1) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(organ['icon'], size: 32, color: organ['color']),
                    const SizedBox(height: 8),
                    Text(
                      organ['name'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
