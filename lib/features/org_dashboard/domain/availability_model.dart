class AvailabilityModel {
  final String providerId;
  final DateTime startTime;
  final int durationMinutes;
  final bool isBooked;

  AvailabilityModel({
    required this.providerId,
    required this.startTime,
    required this.durationMinutes,
    this.isBooked = false,
  });

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));
}
