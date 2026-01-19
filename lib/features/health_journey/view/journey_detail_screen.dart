import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/health_journey/model/health_journey.dart';
import 'widgets/vitals_graph_widget.dart';
import 'dart:math';

class JourneyDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final medicationStartDates = [journey.startDate]; // Use journey start as med start for now

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
                  title: Text(med.brandName),
                  subtitle: Text('${med.genericName} • ${med.dosage}'),
                  trailing: Text(med.frequency),
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }
}
