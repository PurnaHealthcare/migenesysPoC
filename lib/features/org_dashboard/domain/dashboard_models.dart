import 'package:flutter/material.dart';

/// Represents a Key Performance Indicator on the dashboard
class KpiModel {
  final String title;
  final String value;
  final String change;
  final IconData icon;

  const KpiModel({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });

  factory KpiModel.fromMap(Map<String, dynamic> map) {
    return KpiModel(
      title: map['title'] as String,
      value: map['value'] as String,
      change: map['change'] as String,
      icon: map['icon'] as IconData,
    );
  }

  /// Returns true if the change is positive
  bool get isPositiveChange => change.startsWith('+');
}

/// Represents a score metric on the dashboard (e.g., Efficiency Score)
class ScoreModel {
  final String title;
  final String value;
  final Color color;
  final String? trend;

  const ScoreModel({
    required this.title,
    required this.value,
    required this.color,
    this.trend,
  });

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      title: map['title'] as String,
      value: map['value'] as String,
      color: map['color'] as Color,
      trend: map['trend'] as String?,
    );
  }
}

/// Represents a critical alert on the dashboard
class AlertModel {
  final bool isActive;
  final String message;

  const AlertModel({
    required this.isActive,
    required this.message,
  });

  factory AlertModel.inactive() {
    return const AlertModel(isActive: false, message: '');
  }
}
