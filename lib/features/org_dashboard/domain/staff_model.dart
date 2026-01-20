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

  // Factory for json serialization (placeholder)
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
}
