import 'dart:io';
import 'dart:async';

/// Test Runner Script for MiGenesys
///
/// Usage:
///   dart tool/run_tests.dart [android] [ios] [web]
///   dart tool/run_tests.dart all
///
/// This script orchestrates the automated testing pipeline:
/// 1. Prepares the environment (detects devices).
/// 2. Starts platform-specific screen recording.
/// 3. Executes `flutter drive` test suite.
/// 4. Stops recording and saves artifacts to `recordings/`.

const String kAndroidRefDir = 'recordings/android';
const String kIosRefDir = 'recordings/ios';
const String kWebRefDir = 'recordings/web';
const String kTestTarget = 'lib/main_driver.dart';
const String kTestDriver = 'test_driver/medication_feature_test.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart tool/run_tests.dart [android] [ios] [web] | all');
    exit(1);
  }

  final platforms = args.contains('all') ? ['android', 'ios', 'web'] : args;

  print('🚀 Starting Test Automation for: $platforms\n');

  for (final platform in platforms) {
    await runTestForPlatform(platform);
  }

  print('\n✅ All requested test suites completed.');
}

Future<void> runTestForPlatform(String platform) async {
  print('----------------------------------------------------------------');
  print('🏁 Running Test Suite for: ${platform.toUpperCase()}');
  print('----------------------------------------------------------------');

  switch (platform) {
    case 'android':
      await _runAndroidTest();
      break;
    case 'ios':
      await _runIosTest();
      break;
    case 'web':
      await _runWebTest();
      break;
    default:
      print('❌ Unknown platform: $platform');
  }
}

// --- ANDROID AUTOMATION ---
Future<void> _runAndroidTest() async {
  // 1. Detect Device
  final devicesResult = await Process.run('adb', ['devices']);
  final output = devicesResult.stdout.toString();
  if (!output.contains('\tdevice')) {
    print('❌ No Android device/emulator detected. Skipping.');
    return;
  }

  // Parse first available device
  final deviceId = RegExp(
    r'^(\S+)\tdevice',
    multiLine: true,
  ).firstMatch(output)?.group(1);
  if (deviceId == null) {
    print('❌ Failed to parse Android device ID.');
    return;
  }
  print('📱 Android Device Detected: $deviceId');

  // 2. Configure Settings & Start Recording
  print('👆 Enabling Touch Visualization...');
  await Process.run('adb', [
    '-s',
    deviceId,
    'shell',
    'settings',
    'put',
    'system',
    'show_touches',
    '1',
  ]);

  print('🎥 Starting Screen Recording...');
  await Process.run('adb', [
    '-s',
    deviceId,
    'shell',
    'rm',
    '/sdcard/test_recording.mp4',
  ]);
  // detached process so it keeps running
  await Process.start('adb', [
    '-s',
    deviceId,
    'shell',
    'screenrecord',
    '--time-limit=180',
    '/sdcard/test_recording.mp4',
  ]);

  // 3. Run Flutter Drive
  print('🏎️  Executing Flutter Drive...');
  final exitCode = await _runFlutterDrive(
    device: deviceId,
  ); // auto-detects single connected android usually, or pass -d

  // 4. Stop Recording & Pull
  print('🛑 Stopping Recording...');
  await Process.run('adb', ['shell', 'pkill', '-SIGINT', 'screenrecord']);

  print('👆 Disabling Touch Visualization...');
  await Process.run('adb', [
    'shell',
    'settings',
    'put',
    'system',
    'show_touches',
    '0',
  ]);

  await Future.delayed(Duration(seconds: 2)); // Finalize

  print('💾 Pulling Artifact...');
  await Process.run('mkdir', ['-p', kAndroidRefDir]);
  await Process.run('adb', [
    'pull',
    '/sdcard/test_recording.mp4',
    '$kAndroidRefDir/${_timestamp()}_medication_test.mp4',
  ]);

  if (exitCode != 0) throw Exception('Android Test Failed');
}

// --- IOS AUTOMATION ---
Future<void> _runIosTest() async {
  // 1. Detect Simulator
  print('🍎 checking for booted iOS Simulator...');
  String? uuid;
  try {
    final result = await Process.run('xcrun', [
      'simctl',
      'list',
      'devices',
      'booted',
      '--json',
    ]);
    final output = result.stdout.toString();
    // Simple regex to grab the first UUID from the JSON output
    final regex = RegExp(r'"udid"\s*:\s*"([A-F0-9\-]+)"');
    final match = regex.firstMatch(output);
    if (match != null) {
      uuid = match.group(1);
      print('📱 Found Booted Simulator: $uuid');
    }
  } catch (e) {
    print('⚠️ Failed to auto-detect simulator UUID: $e');
  }

  if (uuid == null) {
    print('❌ No booted iOS simulator found. Launch a simulator first.');
    return;
  }

  // 2. Start Recording
  print('🎥 Starting Simulator Recording...');
  await Process.run('mkdir', ['-p', kIosRefDir]);
  final recordingProcess = await Process.start('xcrun', [
    'simctl',
    'io',
    uuid, // usage: xcrun simctl io <device> recordVideo <file>
    'recordVideo',
    '$kIosRefDir/${_timestamp()}_medication_test.mp4',
  ]);

  // 3. Run Flutter Drive
  print('🏎️  Executing Flutter Drive...');
  final exitCode = await _runFlutterDrive(device: uuid);

  // 4. Stop Recording
  print('🛑 Stopping Recording...');
  recordingProcess.kill(ProcessSignal.sigint); // cleanly stop
  await recordingProcess.exitCode;

  if (exitCode != 0) throw Exception('iOS Test Failed');
}

// --- WEB AUTOMATION ---
Future<void> _runWebTest() async {
  print('🌐 Preparing Web Test...');

  // Note: True automated video recording for Web in headless CI usually requires XVFB + FFMPEG.
  // For this PoC, we run the test logic. Video support is noted as manual/external.
  print(
    '⚠️  Note: Web Recording is best-effort. Ensure local screen recorder is active if needed.',
  );

  print('🏎️  Executing Flutter Drive (Chrome)...');
  final exitCode = await _runFlutterDrive(
    device: 'chrome',
    browserName: 'chrome',
  );

  if (exitCode != 0) throw Exception('Web Test Failed');
}

// --- HELPER --
Future<int> _runFlutterDrive({String? device, String? browserName}) async {
  final args = [
    'drive',
    '--target=$kTestTarget',
    '--driver=$kTestDriver',
    if (device != null) ...['-d', device],
    if (browserName != null) ...['--browser-name=$browserName'],
  ];

  final process = await Process.start('flutter', args);

  // Pipe output to console
  process.stdout
      .transform(SystemEncoding().decoder)
      .listen((data) => stdout.write(data));
  process.stderr
      .transform(SystemEncoding().decoder)
      .listen((data) => stderr.write(data));

  return await process.exitCode;
}

String _timestamp() {
  return DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
}
