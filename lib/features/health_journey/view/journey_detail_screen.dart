import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/health_journey/model/health_journey.dart';
import 'widgets/vitals_graph_widget.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view_model/subscription_provider.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/my_providers_screen.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/provider_map_screen.dart';

class JourneyDetailScreen extends ConsumerWidget {
  final HealthJourney journey;

  const JourneyDetailScreen({super.key, required this.journey});

  List<Map<String, dynamic>> _generateMockData(String type) {
    final now = DateTime.now();
    final random = Random();
    List<Map<String, dynamic>> data = [];
    
    for (int i = 0; i < 12; i++) {
       final date = now.subtract(Duration(days: i * 30));
       double value = 0;
       
       if (type == 'BMI') value = 22 + random.nextDouble() * 5;
       else if (type == 'Blood Pressure') value = 110 + random.nextDouble() * 40; // Systolic
       else if (type == 'Blood Glucose') value = 80 + random.nextDouble() * 100;
       else if (type == 'Pulse') value = 60 + random.nextDouble() * 40;
       
       data.add({'date': date, 'value': value});
    }
    return data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubscribed = ref.watch(subscriptionProvider);
    final medicationStartDates = [journey.startDate];

    return Scaffold(
      appBar: AppBar(
        title: Text(journey.title),
        backgroundColor: const Color(0xFF64B5F6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${journey.status}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Started: ${journey.startDate.toString().split(' ')[0]}'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timeline Graphs
            const Text('Vitals Timeline (1 Year)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            VitalsGraphWidget(
              title: 'Blood Pressure (Systolic)',
              dataPoints: _generateMockData('Blood Pressure'),
              medicationStartDates: medicationStartDates,
            ),
             VitalsGraphWidget(
              title: 'Blood Glucose',
              dataPoints: _generateMockData('Blood Glucose'),
              medicationStartDates: medicationStartDates,
            ),
             VitalsGraphWidget(
              title: 'BMI',
              dataPoints: _generateMockData('BMI'),
              medicationStartDates: medicationStartDates,
            ),
            
            const SizedBox(height: 24),
            
            // Medication List
            const Text('Medications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (journey.medications.isEmpty)
              const Text('No medications recorded.')
            else 
              ...journey.medications.map((med) => Card(
                child: ListTile(
                  leading: const Icon(Icons.medication, color: Colors.teal),
                  title: Text(
                    med.brandName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: med.brandName == 'Carvedilol'
                          ? Colors.green[700]
                          : med.brandName == 'Lisinopril'
                              ? Colors.orange[800]
                              : isSubscribed
                                  ? (med.brandName == 'Plavix' ? Colors.red : (med.brandName == 'Atorvastatin' ? Colors.orange[800] : null))
                                  : null,
                    ),
                  ),
                  subtitle: Text('${med.genericName} • ${med.dosage}'),
                  trailing: Text(med.frequency),
                  onTap: () {
                    if (med.brandName == 'Plavix' && isSubscribed) {
                      _showPlavixAlert(context);
                    } else if (med.brandName == 'Atorvastatin' && isSubscribed) {
                      _showAtorvastatinAlert(context);
                    } else if (med.brandName == 'Lisinopril') {
                      _showLisinoprilAlert(context);
                    }
                  },
                ),
              )).toList(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showPharmacySelectionDialog(context),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Order My Medications'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF81C784),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Alert Dialogs (Same as HealthJourneyScreen) ---

  void _showPlavixAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medication Alert', style: TextStyle(color: Colors.red)),
        content: const Text('Genetic analysis indicates Plavix will be ineffective for you. Important risk of future cardiovascular events.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProvidersScreen()));
            },
            child: const Text('Call My Provider'),
          ),
        ],
      ),
    );
  }

  void _showAtorvastatinAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medication Risk', style: TextStyle(color: Colors.orange)),
        content: const Text('High risk for Statin side effects causing muscle pain (myopathy). Please monitor symptoms closely.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProvidersScreen()));
            },
            child: const Text('Call My Provider'),
          ),
        ],
      ),
    );
  }

  void _showLisinoprilAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert: Medication Status', style: TextStyle(color: Colors.orange)),
        content: const Text('Recent blood tests indicate kidney values need attention. This medication dosage may need adjustment.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProvidersScreen()));
            },
            child: const Text('Call My Provider'),
          ),
        ],
      ),
    );
  }

  void _showPharmacySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Pharmacy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Hospital de los Valles'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Farmacias Fybeca'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.storefront),
              title: const Text('Sana Sana'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderMapScreen()));
              },
              icon: const Icon(Icons.map),
              label: const Text('Map Search'),
            ),
          ],
        ),
      ),
    );
  }
}
