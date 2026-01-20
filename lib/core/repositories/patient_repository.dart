import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/patient_model.dart';

/// Provider for [PatientRepository] dependency injection.
final patientRepositoryProvider = Provider((ref) => PatientRepository());

/// Repository for patient data access.
///
/// Provides methods to fetch, search, and retrieve patient records.
/// Currently uses mock data; can be swapped for API implementation.
class PatientRepository {
  /// Retrieves all patients from the data source.
  Future<List<PatientModel>> getAllPatients() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.patients.map((p) => PatientModel.fromMap(p)).toList();
  }

  /// Searches patients by name or phone number.
  ///
  /// Returns all patients if [query] is empty.
  Future<List<PatientModel>> searchPatients(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final patients = MockData.patients.map((p) => PatientModel.fromMap(p)).toList();
    if (query.isEmpty) return patients;
    final lowerQuery = query.toLowerCase();
    return patients
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.phone.contains(query))
        .toList();
  }

  /// Retrieves a single patient by [id].
  ///
  /// Returns null if patient is not found.
  Future<PatientModel?> getPatientById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final map = MockData.patients.firstWhere((p) => p['id'] == id);
      return PatientModel.fromMap(map);
    } catch (_) {
      return null;
    }
  }
}
