# Automated Testing & Recording Guide for MiGenesys

This document details the setup, execution, and troubleshooting steps for running automated UI tests and capturing video evidence for the MiGenesys application on Android, iOS, and Web.

## 1. Environment Setup (Common)

### 1.1 Flutter Driver Configuration
The project is configured for Flutter Driver, which allows external tools (like the Dart MCP Server or scripts) to drive the application.

*   **Entry Point**: `lib/main_driver.dart` (Enables the driver extension).
*   **Dependencies**: `flutter_driver` is added to `dev_dependencies` in `pubspec.yaml`.

### 1.2 Widget Keys
For reliable testing, critical UI elements have been assigned `ValueKey`s. Always use these keys instead of relying solely on text or types.

*   `ValueKey('journey_title_field')`: Journey Title Text Field
*   `ValueKey('med_search_field')`: Medication Search Text Field
*   `ValueKey('add_journey_submit_btn')`: "Start Journey" Button
*   `ValueKey('add_journey_fab')`: Floating Action Button (Main Screen)

---

## 2. Running Automated Tests (Android)

### Step 1: Launch the App with Driver
```bash
flutter run -d <device_id> --target=lib/main_driver.dart
```

### Step 2: Start Screen Recording (Background)
Before starting interactions, start the recording utility on the device.
```bash
adb -s <device_id> shell "screenrecord /sdcard/medication_feature.mp4" &
```

### Step 3: Run the Automated Test Suite (CI/CD Ready)
We have a unified test orchestration script that handles platform detection, recording, and test execution automatically.

**Run for ALL platforms:**
```bash
dart tool/run_tests.dart all
```

**Run for specific platform:**
```bash
dart tool/run_tests.dart android
# OR
dart tool/run_tests.dart ios
# OR
dart tool/run_tests.dart web
```

**What this script does:**
1.  **Environment Check**: Verifies device is connected/booted.
2.  **Start Recording**: Automatically starts `adb screenrecord` (Android) or `xcrun simctl` (iOS) in the background.
3.  **Run Test**: Executes `flutter drive` against the target.
4.  **Save Artifact**: Stops recording and saves timestamped video to `recordings/<platform>/`.

### Step 4: Verify Results
Check the `recordings/` folder. You will see files like:
*   `recordings/android/2026-01-14T21-30-00_medication_test.mp4`
*   `recordings/ios/2026-01-14T21-35-00_medication_test.mp4`

---

## 3. CI/CD Integration
To integrate this into your pipeline (e.g., GitHub Actions, Jenkins):

1.  **Boot Emulator**: Ensure your CI step starts the emulator.
2.  **Run Script**: Execute `dart tool/run_tests.dart android` (or ios).
3.  **Archive Artifacts**: key the `recordings/` directory as a build artifact.

This ensures every test run produces video evidence for Product Owner review without manual intervention.

---

## 5. Known Issues & Troubleshooting

### 📱 Common (Mobile)
**❌ Issue: "Timed out waiting for Flutter Driver response" (Tap Fails)**
*   **Cause**: The element is obscured, usually by the **keyboard**.
*   **Fix**: Explicitly send `send_text_input_action: done` after entering text. Use `sleep` delays to allow keyboard animation to finish.

**❌ Issue: "Element not found"**
*   **Cause**: Relying on Text/Type that changed or is ambiguous.
*   **Fix**: Use `find.byValueKey('your_key')`. Keys are robust.

**❌ Issue: App Hangs on Loading**
*   **Cause**: Stream listeners registering after the event emission.
*   **Fix**: Update Services to `yield` initial state immediately (Fixed in `MockMiGenesysService`).

### 🤖 Android Specific
**❌ Issue: Empty Recording File (0 bytes)**
*   **Cause**: Killing `screenrecord` with `kill -9` or via "Stop App".
*   **Fix**: Must use `pkill -SIGINT screenrecord` to allow the MP4 container to close properly.

### 🍎 iOS Specific
**❌ Issue: Keyboard doesn't dismiss**
*   **Cause**: `send_text_input_action` might behave differently.
*   **Fix**: Look for the specific "Done" button on the iOS keyboard toolbar if standard actions fail.

### 🌐 Web Specific
**❌ Issue: CORS Errors / Image Loading**
*   **Cause**: Web security policies.
*   **Fix**: Run chrome with specific flags or ensure test assets are served locally.
