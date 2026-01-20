/// Represents a healthcare organization (clinic, hospital, or specialty center).
///
/// Immutable model with JSON serialization support.
class OrganizationModel {
  final String id;
  final String name;
  /// Organization type: 'Clinic', 'Hospital', or 'Specialty Center'.
  final String type;

  const OrganizationModel({
    required this.id,
    required this.name,
    required this.type,
  });

  /// Deserializes from JSON map.
  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  /// Serializes to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}
