import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/health_journey_view_model.dart';
import 'widgets/add_journey_dialog.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/subscription_screen.dart';
import 'package:migenesys_poc/features/dashboard/view_model/subscription_provider.dart';
import 'journey_detail_screen.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/my_providers_screen.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/provider_map_screen.dart';

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
                    child: BlinkingMedicationHeader(),
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
                                color: med.brandName == 'Carvedilol'
                                    ? Colors.green[700]
                                    : med.brandName == 'Lisinopril'
                                        ? Colors.orange[800]
                                        : isSubscribed
                                            ? (med.brandName == 'Plavix' ? Colors.red : (med.brandName == 'Atorvastatin' ? Colors.orange[800] : null))
                                            : null,
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
                            onTap: isSubscribed ? () {
                              if (med.brandName == 'Plavix') {
                                _showPlavixAlert(context);
                              } else if (med.brandName == 'Atorvastatin') {
                                _showAtorvastatinAlert(context);
                              } else if (med.brandName == 'Lisinopril') {
                                _showLisinoprilAlert(context);
                              }
                            } : null,
                          ),
                        );
                      },
                      childCount: journeys.expand((j) => j.medications).length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _showPharmacySelectionDialog(context),
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Order My Medications'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF81C784),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                        ),
                      ),
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

class BlinkingMedicationHeader extends ConsumerStatefulWidget {
  const BlinkingMedicationHeader({super.key});

  @override
  ConsumerState<BlinkingMedicationHeader> createState() => _BlinkingMedicationHeaderState();
}

class _BlinkingMedicationHeaderState extends ConsumerState<BlinkingMedicationHeader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.3),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubscribed = ref.watch(subscriptionProvider);

    return GestureDetector(
      onTap: !isSubscribed ? () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen(overlayTitle: 'MiGenomic 360 & Assist')));
      } : null,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            decoration: BoxDecoration(
              color: !isSubscribed ? _colorAnimation.value : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All Medications 💊',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF455A64),
                    ),
                  ),
                  if (!isSubscribed)
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Important information missing. Tap to subscribe.',
                        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
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
}
