import '../../features/health_journey/model/health_journey.dart';

abstract class IMiGenesysService {
  Future<void> sendCommand(String type, Map<String, dynamic> data);
  Stream<List<HealthJourney>> watchHealthJourneys();
  Future<List<HealthJourney>> getHealthJourneys();
}
