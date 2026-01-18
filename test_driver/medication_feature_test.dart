import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Medication Feature Test', () {
    late FlutterDriver driver;

    setUpAll(() async {
      print('DEBUG: setUpAll started');
      print('VM_SERVICE_URL: ${Platform.environment['VM_SERVICE_URL']}');
      // Connect Driver
      print('DEBUG: connecting to driver...');
      driver = await FlutterDriver.connect(
        printCommunication: true,
        timeout: const Duration(seconds: 60),
      );
      print('DEBUG: driver connected');
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    // Helper for human-like pauses
    Future<void> humanDelay([int ms = 1500]) async {
      await Future.delayed(Duration(milliseconds: ms));
    }

    test(
      'Add a new Health Journey with Medication',
      () async {
        print('DEBUG: Test started');
        // Keys
        final startJourneyBtn = find.text('Start Health Journey 🌱');
        final titleField = find.byValueKey('journey_title_field');
        final medSearchField = find.byValueKey('med_search_field');
        final submitBtn = find.byValueKey('add_journey_submit_btn');
        final fab = find.byValueKey('add_journey_fab');

        // 1. Wait for Home Screen (Welcome)
        print('waiting for welcome screen...');
        await driver.waitFor(startJourneyBtn);
        await humanDelay(); // Pause to look at screen
        await driver.tap(startJourneyBtn);

        // 2. Open Add Journey Dialog (from HealthJourneyScreen)
        print('navigating to health journey screen...');
        final startFirstJourneyBtn = find.text('Start Your First Journey');
        await driver.waitFor(startFirstJourneyBtn);
        await humanDelay();
        await driver.tap(startFirstJourneyBtn);

        // 3. Wait for Dialog (Synchronized)
        print('opening dialog...');
        await driver.waitFor(
          find.text('What would you like to take care of today? 💙'),
        );
        await humanDelay();

        // 4. Enter Journey Title (Unsynchronized for blinking cursor)
        print('entering details...');
        await driver.runUnsynchronized(() async {
          await driver.waitFor(titleField);
          await driver.tap(titleField);
          await humanDelay(500); // Quick pause before typing
          await driver.enterText('Heart Health Journey');

          await driver.waitFor(find.text('Heart Health Journey'));
          await humanDelay(500);
          await driver.sendTextInputAction(TextInputAction.done);
          await humanDelay();
        });

        // 5. Add Medication (Unsynchronized for typing)
        await driver.runUnsynchronized(() async {
          await driver.tap(medSearchField);
          await humanDelay(500);
          await driver.enterText('Nor');

          final medOption = find.text('Norvasc');
          await driver.waitFor(medOption);
          await humanDelay(1000); // Pause to see options
          await driver.tap(medOption);

          await humanDelay(500);
          await driver.sendTextInputAction(TextInputAction.done);
          await humanDelay();
        });

        print('adding medication...');
        final addMedBtn = find.text('Add Medication 💊');
        await driver.waitFor(addMedBtn);
        await driver.tap(addMedBtn);
        await humanDelay();

        // 6. Submit Journey
        print('submitting journey...');
        await driver.waitFor(submitBtn);
        await driver.tap(submitBtn);
        await humanDelay(2000); // Wait for submission animation

        // 7. Verify Success
        print('verifying results...');
        final journeyCard = find.text('Heart Health Journey');
        await driver.waitFor(journeyCard);

        await driver.tap(journeyCard); // Expand
        await humanDelay();
        await driver.waitFor(find.text('Medications 💊'));
        await humanDelay(3000); // Final gaze
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );
  });
}
