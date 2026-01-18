class Medication {
  final String brandName;
  final String genericName;
  final String dosage;
  final String frequency;

  Medication({
    required this.brandName,
    required this.genericName,
    required this.dosage,
    required this.frequency,
  });

  Map<String, dynamic> toJson() => {
    'brandName': brandName,
    'genericName': genericName,
    'dosage': dosage,
    'frequency': frequency,
  };

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
    brandName: json['brandName'] as String,
    genericName: json['genericName'] as String,
    dosage: json['dosage'] as String,
    frequency: json['frequency'] as String,
  );
}

class HealthJourney {
  final String id;
  final String title;
  final DateTime startDate;
  final String period;
  final String status;
  final List<Medication> medications;
  final List<String> notes;

  HealthJourney({
    required this.id,
    required this.title,
    required this.startDate,
    required this.period,
    this.status = 'Active',
    this.medications = const [],
    this.notes = const [],
  });

  HealthJourney copyWith({
    String? title,
    String? status,
    String? period,
    List<Medication>? medications,
    List<String>? notes,
  }) {
    return HealthJourney(
      id: id,
      title: title ?? this.title,
      startDate: startDate,
      period: period ?? this.period,
      status: status ?? this.status,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
    );
  }
}
