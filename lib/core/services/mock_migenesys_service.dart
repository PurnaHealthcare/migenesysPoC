import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../features/health_journey/model/health_journey.dart';
import 'migenesys_service.dart';

class MockMiGenesysService implements IMiGenesysService {
  final List<HealthJourney> _journeys = [];
  final _controller = StreamController<List<HealthJourney>>.broadcast();
  final _uuid = const Uuid();

  MockMiGenesysService() {
    _journeys.add(
      HealthJourney(
        id: _uuid.v4(),
        title: 'Myocardial Infarction',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        period: 'Ongoing',
        medications: [
          Medication(
            brandName: 'Plavix',
            genericName: 'Clopidogrel',
            dosage: '75mg',
            frequency: 'Once daily',
          ),
        ],
      ),
    );
    _controller.add(List.unmodifiable(_journeys));
  }

  @override
  Future<void> sendCommand(String type, Map<String, dynamic> data) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    switch (type) {
      case 'StartJourney':
        final newJourney = HealthJourney(
          id: _uuid.v4(),
          title: data['title'] ?? 'New Journey',
          startDate: DateTime.parse(data['startDate'] ?? DateTime.now().toIso8601String()),
          period: data['period'] ?? 'Ongoing',
          medications: (data['medications'] as List? ?? [])
              .map((m) => Medication.fromJson(Map<String, dynamic>.from(m)))
              .toList(),
        );
        _journeys.add(newJourney);
        _controller.add(List.from(_journeys));
        break;
      
      case 'UpdateJourneyStatus':
        final index = _journeys.indexWhere((j) => j.id == data['id']);
        if (index != -1) {
          _journeys[index] = _journeys[index].copyWith(status: data['status']);
          _controller.add(List.from(_journeys));
        }
        break;
    }
  }

  @override
  Stream<List<HealthJourney>> watchHealthJourneys() async* {
    yield List.unmodifiable(_journeys);
    yield* _controller.stream;
  }

  @override
  Future<List<HealthJourney>> getHealthJourneys() async => List.from(_journeys);

  void dispose() {
    _controller.close();
  }
}
