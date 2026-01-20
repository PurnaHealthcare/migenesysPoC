import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migenesys_poc/core/analytics/analytics_service.dart';
import 'package:migenesys_poc/features/org_dashboard/view/care_root_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view/patient_detail_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';

void main() {
  group('Analytics Smoke Tests', () {
    setUp(() {
      AnalyticsService().clearEvents();
    });

    testWidgets('Logs Screen View on Root Navigation', (WidgetTester tester) async {
      final testUser = StaffModel(
        id: 'test1',
        name: 'Test Admin',
        email: 'test@example.com',
        role: 'Practice Manager',
        isMedicalProfessional: false,
        orgId: 'org1',
      );

      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(home: CareRootScreen(user: testUser)),
      ));
      await tester.pumpAndSettle();

      // Open Drawer and navigate
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Staff'));
      await tester.pumpAndSettle();

      // Verify Event Logged
      final events = AnalyticsService().recentEvents;
      expect(events.any((e) => e.action == 'VIEW_SCREEN' && e.metadata?['screen_name'] == 'Staff Management'), isTrue);
    });

    testWidgets('Logs PHI Access Audit on Clinical Tab View', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: PatientDetailScreen(patientId: 'p1', isMedicalProfessional: true),
      ));
      await tester.pumpAndSettle();

      // Switch to Clinical Tab
      await tester.tap(find.text('Clinical'));
      await tester.pumpAndSettle();

      // Verify Audit Event
      final events = AnalyticsService().recentEvents;
      expect(events.any((e) => e.action == 'ACCESS_PHI' && e.role == 'Medical'), isTrue);
    });
  });
}
