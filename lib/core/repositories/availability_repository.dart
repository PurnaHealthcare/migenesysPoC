import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/availability_model.dart';

/// Provider for [AvailabilityRepository] dependency injection.
final availabilityRepositoryProvider = Provider((ref) => AvailabilityRepository());

/// Repository for provider availability and scheduling slots.
///
/// Provides methods to fetch available appointment slots
/// for medical providers.
class AvailabilityRepository {
  /// Retrieves available (unbooked) slots for the given [providerIds].
  Future<List<AvailabilityModel>> getAvailableSlots(Set<String> providerIds) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.availability
        .where((slot) => providerIds.contains(slot.providerId) && !slot.isBooked)
        .toList();
  }

  /// Retrieves available slots for a single [providerId].
  Future<List<AvailabilityModel>> getSlotsByProvider(String providerId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return MockData.availability
        .where((slot) => slot.providerId == providerId && !slot.isBooked)
        .toList();
  }
}
