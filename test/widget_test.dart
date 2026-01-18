import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/main.dart';

void main() {
  testWidgets('Welcome screen shows health journey prompt', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MiGenesysApp(),
      ),
    );

    // Verify the welcoming prompt and button are present
    expect(find.textContaining('What would you like to take care of today?'), findsOneWidget);
    expect(find.text('Start Health Journey 🌱'), findsOneWidget);
  });
}
