import 'package:flutter/foundation.dart';
import 'analytics_event.dart';

class AnalyticsService {
  // Singleton instance
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Mock logging to console for PoC (In real app, send to AWS Kinesis/Pinpoint)
  final List<AnalyticsEvent> _recentEvents = [];
  List<AnalyticsEvent> get recentEvents => List.unmodifiable(_recentEvents);

  Future<void> logEvent(AnalyticsEvent event) async {
    _recentEvents.add(event); // Store for testing
    if (kDebugMode) {
      debugPrint('📊 [ANALYTICS] ${event.action} | Category: ${event.category} | Role: ${event.role ?? "N/A"}');
      if (event.metadata != null) {
        debugPrint('   Metadata: ${event.metadata}');
      }
    }
    // TODO: Send to backend
  }

  // Helper for Screen Views
  void logScreenView(String screenName, {String? role}) {
    logEvent(AnalyticsEvent(
      action: 'VIEW_SCREEN',
      category: 'NAVIGATION',
      role: role,
      metadata: {'screen_name': screenName},
    ));
  }

  // Helper for Feature Usage
  void logFeatureUsage(String feature, String action, {String? role, Map<String, dynamic>? details}) {
    logEvent(AnalyticsEvent(
      action: action,
      category: feature,
      role: role,
      metadata: details,
    ));
  }

  // Clear events for test isolation
  void clearEvents() {
    _recentEvents.clear();
  }
}
