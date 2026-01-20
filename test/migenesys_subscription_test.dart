import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard should show 360 and Assist icons', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    ));
    await tester.pumpAndSettle();

    // Check for subscription-related icons
    final icon360 = find.text('360');
    final iconAssist = find.text('Assist');

    expect(icon360, findsOneWidget);
    expect(iconAssist, findsOneWidget);
  });

  testWidgets('360 icon is tappable', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    ));
    await tester.pumpAndSettle();

    // Verify 360 is tappable
    await tester.tap(find.text('360'));
    await tester.pumpAndSettle();
    
    // Success if no exception thrown
    expect(true, isTrue);
  });
}
