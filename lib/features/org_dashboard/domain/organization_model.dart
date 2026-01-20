class OrganizationModel {
  final String id;
  final String name;
  final String type; // 'Clinic', 'Hospital', 'Specialty Center'

  OrganizationModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}
