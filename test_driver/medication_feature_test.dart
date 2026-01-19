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

        // 1. Login Flow
        print('waiting for login screen...');
        final emailField = find.byValueKey('email_field');
        final passField = find.byValueKey('password_field');
        final loginBtn = find.byValueKey('login_btn');

        await driver.waitFor(emailField);
        await driver.tap(emailField);
        await driver.enterText('test@example.com');
        await humanDelay(500);

        await driver.tap(passField);
        await driver.enterText('password');
        await humanDelay(500);

        await driver.tap(loginBtn);
        await humanDelay(2000); // 1s network delay + animation

        // 2. Navigate to Health Journeys from Dashboard
        print('dashboard loaded. navigating to health journeys...');
        final viewJourneysBtn = find.text('View Health Journeys');
        
        // You might need to scroll down if the button is not visible
        await driver.scrollUntilVisible(
          find.byType('SingleChildScrollView'),
          viewJourneysBtn,
          dyScroll: -300.0,
        );

        await driver.tap(viewJourneysBtn);
        await humanDelay();

        // 3. Verify Health Journey Screen Content
        print('waiting for health journey screen content...');
        // Since we have data, we look for the main content
        await driver.waitFor(find.text('My Journeys'));
        await humanDelay(); 

        // 2. Verify Pre-existing Journey (Myocardial Infarction)
        print('verifying pre-existing journey...');
        final preExistingJourney = find.text('Myocardial Infarction');
        await driver.waitFor(preExistingJourney);
        
        // Expand it to check for Plavix
        await driver.tap(preExistingJourney);
        await humanDelay();
        await driver.waitFor(find.text('Plavix'));
        await driver.tap(preExistingJourney); // Collapse it back
        await humanDelay();

        // 3. Open Add Journey Dialog via FAB
        print('opening dialog via FAB...');
        await driver.tap(fab);

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
        await humanDelay(1000); 

        // Part 2 (Adding Myocardial Infarction) is removed since it is now pre-populated.
        // We proceed directly to verification.

        // ---------------------------------------------------------
        // PART 3: Verify "All Medications" Section
        // ---------------------------------------------------------
        print('Verifying All Medications section...');
        
        // Scroll to bottom to ensure "All Medications" is visible
        final allMedsHeader = find.text('All Medications 💊');
        await driver.scrollUntilVisible(
          find.byType('CustomScrollView'), // Scroll the main view
          allMedsHeader,
          dyScroll: -300.0, // Scroll down
        );
        
        await driver.waitFor(allMedsHeader);
        
        // Verify Plavix is in the list
        final plavixCard = find.text('Plavix');
        await driver.waitFor(plavixCard);
        
        // Verify Norvasc is in the list
        final norvascCard = find.text('Norvasc');
        await driver.waitFor(norvascCard);

        await humanDelay(3000); // Final gaze
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );
  });
}
