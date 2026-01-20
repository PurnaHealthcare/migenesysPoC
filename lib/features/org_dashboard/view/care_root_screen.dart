import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/org_dashboard/view/org_dashboard_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view/staff_list_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view/patient_list_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view/settings_screen.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/dashboard_view_model.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';

class CareRootScreen extends ConsumerStatefulWidget {
  final StaffModel user;
  const CareRootScreen({super.key, required this.user});

  @override
  ConsumerState<CareRootScreen> createState() => _CareRootScreenState();
}

class _CareRootScreenState extends ConsumerState<CareRootScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const OrgDashboardScreen(),
    StaffListScreen(orgId: widget.user.orgId),
    const PatientListScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    'Practice Analytics',
    'Staff Management',
    'Patient Oversight',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final alertAsync = ref.watch(dashboardCriticalAlertProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications coming soon')),
                ),
                icon: const Icon(Icons.notifications),
              ),
              alertAsync.when(
                data: (alert) => alert.isActive
                    ? Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                          constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (e, s) => const SizedBox.shrink(),
              ),
            ],
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
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          AnalyticsService().logScreenView(_titles[index]);
          Navigator.pop(context); // Close drawer
        },
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'MiGenesys Care',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: Text('Dashboard'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: Text('Staff'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services),
            label: Text('Patients'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
           NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
