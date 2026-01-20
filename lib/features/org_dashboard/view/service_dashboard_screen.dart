import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/service_view_model.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/patient_view_model.dart';
import '../domain/staff_model.dart';

class ServiceDashboardScreen extends ConsumerStatefulWidget {
  final StaffModel user;
  const ServiceDashboardScreen({super.key, required this.user});

  @override
  ConsumerState<ServiceDashboardScreen> createState() => _ServiceDashboardScreenState();
}

class _ServiceDashboardScreenState extends ConsumerState<ServiceDashboardScreen> {
  String? _selectedSpecialty;
  String _searchQuery = '';
  DateTime _selectedDate = DateTime.now();
  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView('Service Dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedDrawerIndex == 0 ? 'Service Portal' : 'Patient Directory'),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            ),
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile coming soon')),
            ),
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: _selectedDrawerIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedDrawerIndex = index);
          Navigator.pop(context);
        },
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text('Service Portal', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          NavigationDrawerDestination(icon: Icon(Icons.calendar_today), label: Text('Availability')),
          NavigationDrawerDestination(icon: Icon(Icons.people), label: Text('Patient Directory')),
        ],
      ),
      body: _selectedDrawerIndex == 0 ? _buildAvailabilityView() : _buildPatientDirectoryView(),
    );
  }

  Widget _buildAvailabilityView() {
    final specialtiesAsync = ref.watch(serviceSpecialtiesProvider(widget.user.orgId));
    final medicalStaffAsync = ref.watch(serviceMedicalStaffProvider(widget.user.orgId));

    return Column(
      children: [
        // Specialty Chips
        Container(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedSpecialty == null,
                  onSelected: (selected) => setState(() => _selectedSpecialty = null),
                ),
                const SizedBox(width: 8),
                ...specialtiesAsync.when(
                  data: (specialties) => specialties.map((spec) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(spec),
                      selected: _selectedSpecialty == spec,
                      onSelected: (selected) => setState(() => _selectedSpecialty = selected ? spec : null),
                    ),
                  )),
                  loading: () => [const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))],
                  error: (e, s) => [const Text('Error')],
                ),
              ],
            ),
          ),
        ),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search provider...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(height: 8),
        // Calendar
        _buildMiniCalendar(),
        // Slots
        Expanded(
          child: medicalStaffAsync.when(
            data: (allProviders) {
              // Filter providers by specialty and search
              final providers = allProviders.where((s) {
                if (_selectedSpecialty != null && s.specialty != _selectedSpecialty) return false;
                if (_searchQuery.isNotEmpty && !s.name.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
                return true;
              }).toList();
              
              final providerIds = providers.map((p) => p.id).toSet();
              return _buildSlotsList(providerIds, providers);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientDirectoryView() {
    final patientsAsync = ref.watch(searchPatientsProvider(_searchQuery));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        Expanded(
          child: patientsAsync.when(
            data: (patients) => ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(patient.initials.isNotEmpty ? patient.initials : '?')),
                    title: Text(patient.name),
                    subtitle: Text('${patient.phone} • ${patient.status}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Viewing ${patient.name}...')),
                      );
                    },
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCalendar() {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.add(Duration(days: i)));

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: today,
                    lastDate: today.add(const Duration(days: 90)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('More Dates'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: days.map((day) {
                final isSelected = day.day == _selectedDate.day &&
                    day.month == _selectedDate.month &&
                    day.year == _selectedDate.year;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedDate = day),
                    child: Container(
                      width: 60,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1],
                            style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey),
                          ),
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            day.day == today.day ? 'Today' : '',
                            style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotsList(Set<String> providerIds, List<StaffModel> providers) {
    final slotsAsync = ref.watch(serviceAvailabilityProvider(providerIds));

    return slotsAsync.when(
      data: (slots) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Available Slots (${slots.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            if (slots.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No slots available for selected filters')),
                ),
              )
            else
              ...slots.map((slot) {
                final provider = providers.firstWhere(
                  (s) => s.id == slot.providerId,
                  orElse: () => StaffModel.unknown(orgId: widget.user.orgId),
                );
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.access_time, color: Colors.green),
                    ),
                    title: Text(provider.name),
                    subtitle: Text('${provider.specialty ?? provider.role} • ${slot.durationMinutes} min'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${slot.startTime.hour}:${slot.startTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Booking with ${provider.name}...')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            minimumSize: const Size(50, 28),
                          ),
                          child: const Text('Book', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading slots: $e')),
    );
  }
}
