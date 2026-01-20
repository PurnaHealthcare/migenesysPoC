import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/repositories/staff_repository.dart';
import 'package:migenesys_poc/core/repositories/availability_repository.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/availability_model.dart';

/// Provider for medical staff in service dashboard context.
final serviceMedicalStaffProvider = FutureProvider.family<List<StaffModel>, String>((ref, orgId) async {
  final repository = ref.watch(staffRepositoryProvider);
  return repository.getMedicalStaffByOrg(orgId);
});

/// Provider for medical specialties available in organization.
final serviceSpecialtiesProvider = FutureProvider.family<List<String>, String>((ref, orgId) async {
  final repository = ref.watch(staffRepositoryProvider);
  return repository.getSpecialties(orgId);
});

/// Provider for available appointment slots by provider IDs.
/// 
/// Uses comma-separated string of provider IDs for proper caching.
final serviceAvailabilityProvider = FutureProvider.family<List<AvailabilityModel>, String>((ref, providerIdsStr) async {
  final repository = ref.watch(availabilityRepositoryProvider);
  if (providerIdsStr.isEmpty) return [];
  final providerIds = providerIdsStr.split(',').toSet();
  return repository.getAvailableSlots(providerIds);
});
