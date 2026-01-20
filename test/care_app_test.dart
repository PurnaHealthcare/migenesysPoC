import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/app/app_care.dart';
import 'package:migenesys_poc/features/org_dashboard/view/patient_detail_screen.dart';

void main() {
  group('MiGenesys Care App Smoke Tests', () {
    testWidgets('Dashboard shows Analytics KPIs', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MiGenesysCareApp()));
      await tester.pumpAndSettle();

      // Find KPI cards
      expect(find.text('Unique Visits'), findsOneWidget);
      expect(find.text('Avg Wait Time'), findsOneWidget);
      
      // Find Chart Placeholder
      expect(find.text('Visits by Specialty'), findsOneWidget);
    });

    testWidgets('Patient Detail Screen - RBAC Logic', (WidgetTester tester) async {
      // 1. Test as Non-Medical (Admin)
      await tester.pumpWidget(const MaterialApp(
        home: PatientDetailScreen(isMedicalProfessional: false),
      ));
      await tester.pumpAndSettle();

      // Should see Admin Tab content
      expect(find.text('Personal Information'), findsOneWidget);
      
      // Switch to Clinical Tab
      await tester.tap(find.text('Clinical'));
      await tester.pumpAndSettle();

      // Should see Restricted Message
      expect(find.text('Access Restricted'), findsOneWidget);
      expect(find.text('Current Medications'), findsNothing);

      // 2. Test as Medical Professional
      await tester.pumpWidget(const MaterialApp(
        home: PatientDetailScreen(isMedicalProfessional: true),
      ));
      await tester.pumpAndSettle();

      // Switch to Clinical Tab
      await tester.tap(find.text('Clinical'));
      await tester.pumpAndSettle();

      // Should see Clinical Content
      expect(find.text('Access Restricted'), findsNothing);
      expect(find.text('Current Medications'), findsOneWidget);
      expect(find.text('Lisinopril'), findsOneWidget);
    });
  });
}
