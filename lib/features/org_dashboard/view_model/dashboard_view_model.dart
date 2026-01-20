import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/repositories/dashboard_repository.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/dashboard_models.dart';

/// Provider for dashboard KPI metrics.
final dashboardKpisProvider = FutureProvider<List<KpiModel>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getKpis();
});

/// Provider for dashboard score cards (efficiency, quality, etc.).
final dashboardScoresProvider = FutureProvider<List<ScoreModel>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getScores();
});

/// Provider for critical alert banner status.
final dashboardCriticalAlertProvider = FutureProvider<AlertModel>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getCriticalAlert();
});
