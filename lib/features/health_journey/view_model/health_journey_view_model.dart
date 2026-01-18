import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/migenesys_service.dart';
import '../../../core/services/mock_migenesys_service.dart';
import '../model/health_journey.dart';

final migenesysServiceProvider = Provider<IMiGenesysService>((ref) {
  return MockMiGenesysService();
});

final healthJourneysProvider = StreamProvider<List<HealthJourney>>((ref) {
  final service = ref.watch(migenesysServiceProvider);
  return service.watchHealthJourneys();
});

class HealthJourneyNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> startNewJourney({
    required String title,
    required DateTime startDate,
    required String period,
    required List<Medication> medications,
  }) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(migenesysServiceProvider);
      await service.sendCommand('StartJourney', {
        'title': title,
        'startDate': startDate.toIso8601String(),
        'period': period,
        'medications': medications.map((m) => m.toJson()).toList(),
      });
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final healthJourneyNotifierProvider =
    AsyncNotifierProvider<HealthJourneyNotifier, void>(() {
  return HealthJourneyNotifier();
});
