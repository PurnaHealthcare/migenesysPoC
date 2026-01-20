class StaffModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'Admin', 'Clerk', etc.
  final bool isMedicalProfessional;
  final bool isPharmacist;
  final String orgId;
  final String? avatar;

  StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isMedicalProfessional,
    this.isPharmacist = false,
    required this.orgId,
    this.avatar,
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
      orgId: json['orgId'] as String,
      avatar: json['avatar'] as String?,
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
      'orgId': orgId,
      'avatar': avatar,
    };
  }

  StaffModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isMedicalProfessional,
    bool? isPharmacist,
    String? orgId,
    String? avatar,
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
    );
  }
}
