import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view/dashboard_screen.dart';

void main() {
  // Use a wrapper to provide media query and directionality
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: DashboardScreen(),
      ),
    );
  }

  testWidgets('BMI Calculation Metric Logic Test', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter Height (180 cm)
    await tester.enterText(find.widgetWithText(TextField, 'Height (cm)'), '180');
    
    // Enter Weight (80 kg)
    // BMI = 80 / (1.8 * 1.8) = 24.7 -> Green
    await tester.enterText(find.widgetWithText(TextField, 'Weight (kg)'), '80');
    
    await tester.pump();

    // Verify BMI Text
    expect(find.text('24.7'), findsOneWidget);
    
    // Verify Color (We check the text style color)
    final textWidget = tester.widget<Text>(find.text('24.7'));
    expect(textWidget.style?.color, Colors.green);
  });

  testWidgets('BMI Calculation Imperial Logic Test', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Switch to Imperial
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Enter Height (5 ft 10 in)
    await tester.enterText(find.widgetWithText(TextField, 'ft'), '5');
    await tester.enterText(find.widgetWithText(TextField, 'in'), '10'); // 70 inches = 1.778 m

    // Enter Weight (220 lbs) -> ~99.8 kg
    // BMI = 99.8 / (1.778^2) = ~31.5 -> Red
    await tester.enterText(find.widgetWithText(TextField, 'Weight (lbs)'), '220');

    await tester.pump();

    // Verify BMI Text (approx)
    expect(find.text('31.6'), findsOneWidget); // 31.56 rounded

    // Verify Color
    final textWidget = tester.widget<Text>(find.text('31.6'));
    expect(textWidget.style?.color, Colors.red);
  });
  
  testWidgets('BMI Extreme Logic Test', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter Height (180 cm)
    await tester.enterText(find.widgetWithText(TextField, 'Height (cm)'), '180');
    
    // Enter Weight (140 kg)
    // BMI = 140 / 3.24 = 43.2 -> Purple
    await tester.enterText(find.widgetWithText(TextField, 'Weight (kg)'), '140');
    
    await tester.pump();

    // Verify BMI Text
    expect(find.text('43.2'), findsOneWidget); // 43.209

    // Verify Color
    final textWidget = tester.widget<Text>(find.text('43.2'));
    expect(textWidget.style?.color, Colors.purple);
  });
}
