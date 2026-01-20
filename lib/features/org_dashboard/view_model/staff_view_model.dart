import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/repositories/staff_repository.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';

/// Provider for all staff members by organization ID.
final staffListProvider = FutureProvider.family<List<StaffModel>, String>((ref, orgId) async {
  final repository = ref.watch(staffRepositoryProvider);
  return repository.getStaffByOrg(orgId);
});

/// Provider for medical staff only by organization ID.
final medicalStaffProvider = FutureProvider.family<List<StaffModel>, String>((ref, orgId) async {
  final repository = ref.watch(staffRepositoryProvider);
  return repository.getMedicalStaffByOrg(orgId);
});
