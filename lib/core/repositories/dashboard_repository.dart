import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/dashboard_models.dart';

final dashboardRepositoryProvider = Provider((ref) => DashboardRepository());

/// Repository for dashboard-related data access.
/// Abstracts the data layer from the UI, enabling easy swap to real API.
class DashboardRepository {
  /// Fetches the list of KPIs for the dashboard.
  Future<List<KpiModel>> getKpis() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.dashboardKpis.map((k) => KpiModel.fromMap(k)).toList();
  }

  /// Fetches the multi-factor scores displayed on the dashboard.
  Future<List<ScoreModel>> getScores() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.dashboardScores.map((s) => ScoreModel.fromMap(s)).toList();
  }

  /// Fetches the critical alert status for the dashboard.
  Future<AlertModel> getCriticalAlert() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return AlertModel(
      isActive: MockData.hasCriticalAlert,
      message: MockData.criticalAlertMessage,
    );
  }
}
