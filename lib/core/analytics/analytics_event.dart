class AnalyticsEvent {
  final String action; // e.g., 'VIEW_SCREEN', 'CLICK_BUTTON'
  final String category; // e.g., 'PATIENT_OVERSIGHT', 'STAFF_MGMT'
  final String? actorId; // User ID performing the action
  final String? role; // Role at time of action
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.action,
    required this.category,
    this.actorId,
    this.role,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().toUtc();

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'category': category,
      'actorId': actorId,
      'role': role,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
