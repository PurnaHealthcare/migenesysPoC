import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view/dashboard_screen.dart';
import 'package:migenesys_poc/features/dashboard/view/screens/subscription_screen.dart';
import 'package:migenesys_poc/features/health_journey/view/health_journey_screen.dart';
import 'package:migenesys_poc/features/dashboard/view_model/subscription_provider.dart';

class MockSubscriptionNotifier extends SubscriptionNotifier {
  @override
  bool build() => true;
}

void main() {
  testWidgets('Dashboard should show 360 and Assist icons in Red', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    ));

    final icon360 = find.text('360');
    final iconAssist = find.text('Assist');

    expect(icon360, findsOneWidget);
    expect(iconAssist, findsOneWidget);

    // Let's find the icon and check its color
    final iconData360 = find.byIcon(Icons.auto_awesome);
    final iconWidget360 = tester.widget<Icon>(iconData360);
    expect(iconWidget360.color, Colors.red);

    final iconDataAssist = find.byIcon(Icons.assistant);
    final iconWidgetAssist = tester.widget<Icon>(iconDataAssist);
    expect(iconWidgetAssist.color, Colors.red);
  });

  testWidgets('Clicking 360 icon navigates to SubscriptionScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    ));

    await tester.tap(find.text('360'));
    await tester.pumpAndSettle();

    expect(find.byType(SubscriptionScreen), findsOneWidget);
    expect(find.text('Unlock MiGenomica 360'), findsOneWidget);
  });

  testWidgets('Subscribing updates Plavix color to Red in HealthJourneyScreen', (WidgetTester tester) async {
    // Start with HealthJourneyScreen
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: HealthJourneyScreen(),
      ),
    ));

    // Verify Plavix is NOT red initially
    await tester.pump(); 
    await tester.pump(); 

    final plavixTitle = find.text('Plavix');
    expect(plavixTitle, findsOneWidget);
    
    final plavixText = tester.widget<Text>(plavixTitle);
    expect(plavixText.style?.color, isNot(Colors.red));

    // Get the element to access the provider
    final element = tester.element(find.byType(HealthJourneyScreen));
    final container = ProviderScope.containerOf(element);
    
    // Subscribe
    container.read(subscriptionProvider.notifier).subscribe();
    
    await tester.pump();

    final plavixTitleRed = find.text('Plavix');
    final plavixTextRed = tester.widget<Text>(plavixTitleRed);
    expect(plavixTextRed.style?.color, Colors.red);
  });
}
