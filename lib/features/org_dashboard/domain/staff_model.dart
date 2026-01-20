class StaffModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'Admin', 'Clerk', etc.
  final bool isMedicalProfessional;
  final bool isPharmacist;

  StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isMedicalProfessional,
    this.isPharmacist = false,
  });

  // Factory for json serialization
  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isMedicalProfessional: json['isMedicalProfessional'] as bool,
      isPharmacist: (json['isPharmacist'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isMedicalProfessional': isMedicalProfessional,
      'isPharmacist': isPharmacist,
    };
  }

  StaffModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isMedicalProfessional,
    bool? isPharmacist,
  }) {
    return StaffModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isMedicalProfessional: isMedicalProfessional ?? this.isMedicalProfessional,
      isPharmacist: isPharmacist ?? this.isPharmacist,
    );
  }
}
