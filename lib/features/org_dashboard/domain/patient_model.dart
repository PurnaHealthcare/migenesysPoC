/// Represents a patient in the healthcare system.
///
/// Immutable model with serialization support and computed properties.
class PatientModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String? age;
  final String status;
  final String? provider;
  final String? lastVisit;
  final String? nextVisit;
  final String? condition;
  final String? bloodType;
  final String? allergies;
  final String? medications;

  const PatientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    this.age,
    required this.status,
    this.provider,
    this.lastVisit,
    this.nextVisit,
    this.condition,
    this.bloodType,
    this.allergies,
    this.medications,
  });

  /// Deserializes from a map (e.g., from JSON).
  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: (map['email'] ?? '') as String,
      phone: map['phone'] as String,
      dob: map['dob'] as String,
      age: map['age'] as String?,
      status: map['status'] as String,
      provider: map['provider'] as String?,
      lastVisit: map['lastVisit'] as String?,
      nextVisit: map['nextVisit'] as String?,
      condition: map['condition'] as String?,
      bloodType: map['bloodType'] as String?,
      allergies: map['allergies'] as String?,
      medications: map['medications'] as String?,
    );
  }

  /// Serializes to a map for storage/API calls.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'age': age,
      'status': status,
      'provider': provider,
      'lastVisit': lastVisit,
      'nextVisit': nextVisit,
      'condition': condition,
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
    };
  }

  /// Computes initials from the patient's name (max 2 characters).
  String get initials {
    final parts = name.split(' ').where((e) => e.isNotEmpty).take(2);
    return parts.map((e) => e[0]).join();
  }
}
