import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';

/// Provider for [StaffRepository] dependency injection.
final staffRepositoryProvider = Provider((ref) => StaffRepository());

/// Repository for staff/employee data access.
///
/// Provides methods to fetch staff by organization, find by email,
/// and retrieve medical specialties.
class StaffRepository {
  /// Retrieves all staff members for a given [orgId].
  Future<List<StaffModel>> getStaffByOrg(String orgId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.staffList.where((s) => s.orgId == orgId).toList();
  }

  /// Retrieves only medical professional staff for [orgId].
  Future<List<StaffModel>> getMedicalStaffByOrg(String orgId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.staffList
        .where((s) => s.isMedicalProfessional && s.orgId == orgId)
        .toList();
  }

  /// Finds a staff member by their [email] address.
  ///
  /// Returns null if no matching staff member is found.
  Future<StaffModel?> findByEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return MockData.staffList.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns a list of unique medical specialties for [orgId].
  Future<List<String>> getSpecialties(String orgId) async {
    final staff = await getMedicalStaffByOrg(orgId);
    return staff
        .where((s) => s.specialty != null)
        .map((s) => s.specialty!)
        .toSet()
        .toList()
      ..sort();
  }
}
