import 'package:flutter/material.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import '../domain/staff_model.dart';
import '../domain/availability_model.dart';

class ServiceDashboardScreen extends StatefulWidget {
  final StaffModel user;
  const ServiceDashboardScreen({super.key, required this.user});

  @override
  State<ServiceDashboardScreen> createState() => _ServiceDashboardScreenState();
}

class _ServiceDashboardScreenState extends State<ServiceDashboardScreen> {
  String? _selectedProviderId;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('Service Dashboard');
  }

  @override
  Widget build(BuildContext context) {
    // Filter availability based on selection
    final List<AvailabilityModel> availableSlots = MockData.availability.where((slot) {
      if (_selectedProviderId != null && slot.providerId != _selectedProviderId) {
        return false;
      }
      return !slot.isBooked;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Service'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (index) {},
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text('Service Portal', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.calendar_today),
            label: Text('Availability'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.people),
            label: Text('Patient Directory'),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel: Filters & Quick Actions
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[100],
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('New Walk-In'),
                  ),
                  const Divider(height: 30),
                  const Text('Filter Provider', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...MockData.staffList
                      .where((s) => s.isMedicalProfessional && s.orgId == widget.user.orgId)
                      .map((staff) => RadioListTile<String>(
                            title: Text(staff.name),
                            value: staff.id,
                            groupValue: _selectedProviderId,
                            onChanged: (val) {
                              setState(() {
                                _selectedProviderId = val;
                              });
                            },
                          )),
                   RadioListTile<String?>(
                    title: const Text('All Providers'),
                    value: null,
                    groupValue: _selectedProviderId,
                    onChanged: (val) {
                      setState(() {
                        _selectedProviderId = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Right Panel: Calendar / Slots
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Available Slots (${availableSlots.length})',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: availableSlots.length,
                    itemBuilder: (context, index) {
                      final slot = availableSlots[index];
                      final provider = MockData.staffList.firstWhere((s) => s.id == slot.providerId);
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.access_time, color: Colors.green),
                          title: Text('${provider.name} - ${slot.durationMinutes} min'),
                          subtitle: Text('Start: ${slot.startTime.toString()}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Booking flow initiated...')),
                              );
                            },
                            child: const Text('Book'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
