/// Represents a staff member in the healthcare organization.
///
/// Immutable model with serialization support for API integration.
class StaffModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isMedicalProfessional;
  final bool isPharmacist;
  final String orgId;
  final String? avatar;
  final String? specialty;

  const StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isMedicalProfessional,
    this.isPharmacist = false,
    required this.orgId,
    this.avatar,
    this.specialty,
  });

  /// Factory for unknown/fallback staff member
  factory StaffModel.unknown({String orgId = 'unknown'}) {
    return StaffModel(
      id: '0',
      name: 'Unknown',
      email: '',
      role: 'N/A',
      isMedicalProfessional: false,
      orgId: orgId,
    );
  }

  /// Deserializes from JSON map.
  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isMedicalProfessional: json['isMedicalProfessional'] as bool,
      isPharmacist: (json['isPharmacist'] ?? false) as bool,
      orgId: json['orgId'] as String,
      avatar: json['avatar'] as String?,
      specialty: json['specialty'] as String?,
    );
  }

  /// Serializes to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isMedicalProfessional': isMedicalProfessional,
      'isPharmacist': isPharmacist,
      'orgId': orgId,
      'avatar': avatar,
      'specialty': specialty,
    };
  }

  /// Creates a copy with optional field overrides.
  StaffModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isMedicalProfessional,
    bool? isPharmacist,
    String? orgId,
    String? avatar,
    String? specialty,
  }) {
    return StaffModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isMedicalProfessional: isMedicalProfessional ?? this.isMedicalProfessional,
      isPharmacist: isPharmacist ?? this.isPharmacist,
      orgId: orgId ?? this.orgId,
      avatar: avatar ?? this.avatar,
      specialty: specialty ?? this.specialty,
    );
  }
}
