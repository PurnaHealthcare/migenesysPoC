import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/app/app_life.dart';
import 'package:migenesys_poc/app/app_docassist.dart';
import 'package:migenesys_poc/app/app_care.dart';
import 'package:migenesys_poc/app/app_partner.dart';

void main() {
  group('App Smoke Tests', () {
    testWidgets('MiGenesys Life App launches', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MiGenesysLifeApp()));
      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for Splash
      // Should find logic from Login screen or Splash
      // Just verifying no crash
      expect(find.byType(MiGenesysLifeApp), findsOneWidget);
    });

    testWidgets('DocAssist App launches', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: DocAssistApp()));
      await tester.pumpAndSettle();
      expect(find.text('DocAssist Dashboard'), findsOneWidget);
    });

    testWidgets('MiGenesys Care App launches', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MiGenesysCareApp()));
      await tester.pumpAndSettle();
      expect(find.text('MiGenesys Care Admin'), findsOneWidget);
    });

    testWidgets('MiGenesys Partner App launches', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MiGenesysPartnerApp()));
      await tester.pumpAndSettle();
      expect(find.text('MiGenesys Partner Portal'), findsOneWidget);
    });
  });
}
