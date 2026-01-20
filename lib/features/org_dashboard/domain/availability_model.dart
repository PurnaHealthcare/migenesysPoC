/// Represents an availability slot for a healthcare provider.
///
/// Used for scheduling and appointment booking.
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

  /// Calculates the end time based on start time and duration.
  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));

  /// Deserializes from a map.
  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      providerId: map['providerId'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      durationMinutes: map['durationMinutes'] as int,
      isBooked: (map['isBooked'] ?? false) as bool,
    );
  }

  /// Serializes to a map.
  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'startTime': startTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'isBooked': isBooked,
    };
  }
}
