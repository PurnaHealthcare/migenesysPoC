import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view/dashboard_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    );
  }

  testWidgets('Dashboard Screen renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify the screen renders
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('Dashboard shows Organ System grid', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify key UI elements are present
    expect(find.textContaining('Your Organs'), findsOneWidget);
  });
}
