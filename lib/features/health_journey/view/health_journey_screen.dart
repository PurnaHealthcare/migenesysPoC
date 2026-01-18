import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/health_journey_view_model.dart';
import 'widgets/add_journey_dialog.dart';

class HealthJourneyScreen extends ConsumerWidget {
  const HealthJourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeysAsync = ref.watch(healthJourneysProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health Journeys 💙'),
        backgroundColor: const Color(0xFF64B5F6),
        foregroundColor: Colors.white,
      ),
      body: journeysAsync.when(
        data: (journeys) => journeys.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No journeys yet 🌱', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    const Text('“What would you like to take care of today?”', 
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _showAddJourneyDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Start Your First Journey'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: journeys.length,
                itemBuilder: (context, index) {
                  final journey = journeys[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpansionTile(
                      leading: const Icon(Icons.favorite, color: Colors.blueAccent),
                      title: Text(journey.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Started: ${journey.startDate.toString().split(' ')[0]} • ${journey.period}'),
                      trailing: Chip(label: Text(journey.status)),
                      children: [
                        if (journey.medications.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('Medications 💊', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ...journey.medications.map((m) => ListTile(
                            dense: true,
                            title: Text(m.brandName),
                            subtitle: Text('${m.genericName} - ${m.dosage}, ${m.frequency}'),
                          )),
                        ] else
                          const ListTile(
                            title: Text('No medications listed'),
                            dense: true,
                          ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddJourneyDialog(context, ref),
        backgroundColor: const Color(0xFF64B5F6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddJourneyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddJourneyDialog(ref: ref),
    );
  }
}
