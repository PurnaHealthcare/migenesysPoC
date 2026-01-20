import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/repositories/patient_repository.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/patient_model.dart';

/// Provider for all patients in the system.
final allPatientsProvider = FutureProvider<List<PatientModel>>((ref) async {
  final repository = ref.watch(patientRepositoryProvider);
  return repository.getAllPatients();
});

/// Provider for patient search results by query string.
final searchPatientsProvider = FutureProvider.family<List<PatientModel>, String>((ref, query) async {
  final repository = ref.watch(patientRepositoryProvider);
  return repository.searchPatients(query);
});
