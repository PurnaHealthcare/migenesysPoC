import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migenesys_poc/app/app_care.dart';
import 'package:migenesys_poc/features/org_dashboard/view/service_dashboard_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view/medical_dashboard_screen.dart';

void main() {

  testWidgets('Phase 2 Workflow: Customer Service Login & Routing', (WidgetTester tester) async {
    // 1. Launch App
    await tester.pumpWidget(const MiGenesysCareApp());
    await tester.pumpAndSettle();

    // 2. Identify Login Fields
    final emailField = find.widgetWithText(TextField, 'Email');
    final passwordField = find.widgetWithText(TextField, 'Password');
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    // 3. Login as Service Agent
    await tester.enterText(emailField, 'service@example.com');
    await tester.enterText(passwordField, 'password');
    await tester.tap(loginButton);
    
    // 4. Wait for Navigation (Service dashboard loads)
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 5. Verify Service Dashboard
    expect(find.byType(ServiceDashboardScreen), findsOneWidget);
    expect(find.text('Service Portal'), findsOneWidget); // AppBar title
    expect(find.text('All'), findsOneWidget); // Specialty "All" chip
  });

  testWidgets('Phase 2 Workflow: Medical Professional Login & Routing', (WidgetTester tester) async {
    // 1. Launch App
    await tester.pumpWidget(const MiGenesysCareApp());
    await tester.pumpAndSettle();

    final emailField = find.widgetWithText(TextField, 'Email');
    final passwordField = find.widgetWithText(TextField, 'Password');
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');

    // 2. Login as Medical Pro
    await tester.enterText(emailField, 'med@example.com');
    await tester.enterText(passwordField, 'password');
    await tester.tap(loginButton);
    
    // 3. Wait for Navigation
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 4. Verify Medical Dashboard
    expect(find.byType(MedicalDashboardScreen), findsOneWidget);
    expect(find.text('My Patients'), findsOneWidget);
  });
}
