import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/health_journey_view_model.dart';
import 'widgets/add_journey_dialog.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/subscription_screen.dart';
import 'package:migenesys_poc/features/dashboard/view_model/subscription_provider.dart';
import 'journey_detail_screen.dart';

class HealthJourneyScreen extends ConsumerWidget {
  const HealthJourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeysAsync = ref.watch(healthJourneysProvider);
    final isSubscribed = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health Journeys 💙'),
        backgroundColor: const Color(0xFF64B5F6),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.layers),
            tooltip: 'Add Overlay',
            onSelected: (value) {
              if (value == '360') {
                 // Check if report exists (mocked as true for PoC)
                 bool hasReport = true; 
                 if (hasReport) {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionScreen(overlayTitle: 'MiGenomica 360'),
                    ),
                  );
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No report available for overlay.')));
                 }
              } else if (value == 'DocAssist') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionScreen(overlayTitle: 'MiGenesys Assist'),
                    ),
                  );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: '360',
                child: Text('MiGenomica 360 Overlay'),
              ),
              const PopupMenuItem<String>(
                value: 'DocAssist',
                child: Text('MiGenesys Assist Overlay'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Order Refills',
            onPressed: () => _showRefillDialog(context),
          ),
        ],
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
            : CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        'My Journeys',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF455A64),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final journey = journeys[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.favorite, color: Colors.blueAccent),
                            title: Text(journey.title,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Started: ${journey.startDate.toString().split(' ')[0]} • ${journey.period}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JourneyDetailScreen(journey: journey),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: journeys.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        'All Medications 💊',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF455A64),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Flatten all medications from all journeys
                        final allMedications = <Map<String, dynamic>>[];
                        for (var journey in journeys) {
                          for (var med in journey.medications) {
                            allMedications.add({
                              'med': med,
                              'journeyStart': journey.startDate,
                            });
                          }
                        }

                        if (allMedications.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('No medications recorded.'),
                          );
                        }

                        if (index >= allMedications.length) return null;

                        final item = allMedications[index];
                        final med = item['med'] as dynamic; // casting to simplify
                        final startDate = item['journeyStart'] as DateTime;
                        final duration = DateTime.now().difference(startDate).inDays;

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal.shade100,
                              child: const Icon(Icons.medication, color: Colors.teal),
                            ),
                            title: Text(
                              med.brandName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: (isSubscribed && med.brandName == 'Plavix') ? Colors.red : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${med.genericName}'),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.monitor_weight_outlined, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text('${med.dosage}'),
                                    const SizedBox(width: 12),
                                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text('${med.frequency}'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Duration: $duration days',
                                  style: TextStyle(
                                    color: Colors.blueGrey[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                      childCount: journeys.expand((j) => j.medications).length,
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMedicationOptions(context, ref),
        backgroundColor: const Color(0xFF64B5F6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showRefillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Refills'),
        content: const Text('How would you like to proceed with your refills?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showMockContactDialog(context, 'Calling Provider', 'Initiating call to Dr. Sarah Smith...');
            },
            child: const Text('Call Provider'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMockContactDialog(context, 'Notifying Pharmacy', 'A refill request has been sent to Genesys Pharmacy.');
            },
            child: const Text('Notify Pharmacy'),
          ),
        ],
      ),
    );
  }

  void _showMockContactDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showAddMedicationOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Add Medication', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner, color: Colors.blue),
            title: const Text('Scan Barcode'),
            onTap: () {
              Navigator.pop(context);
              _simulateBarcodeScan(context, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note, color: Colors.green),
            title: const Text('Add Manually'),
            onTap: () {
              Navigator.pop(context);
              _showAddJourneyDialog(context, ref);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _simulateBarcodeScan(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scanned: Atorvastatin 20mg added to Heart Health Journey!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showAddJourneyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddJourneyDialog(ref: ref),
    );
  }
}
