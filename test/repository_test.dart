import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migenesys_poc/core/repositories/patient_repository.dart';
import 'package:migenesys_poc/core/repositories/staff_repository.dart';
import 'package:migenesys_poc/core/repositories/dashboard_repository.dart';
import 'package:migenesys_poc/core/repositories/availability_repository.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/patient_model.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/staff_model.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/dashboard_models.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/availability_model.dart';
import 'package:migenesys_poc/features/org_dashboard/domain/organization_model.dart';

void main() {
  group('Repository Unit Tests', () {
    group('PatientRepository', () {
      late PatientRepository repository;

      setUp(() {
        repository = PatientRepository();
      });

      test('getAllPatients returns list of PatientModel', () async {
        final patients = await repository.getAllPatients();

        expect(patients, isA<List<PatientModel>>());
        expect(patients.isNotEmpty, true);
        expect(patients.first.name, isNotEmpty);
      });

      test('searchPatients filters by name', () async {
        final all = await repository.getAllPatients();
        final firstName = all.first.name.split(' ').first;
        final results = await repository.searchPatients(firstName);

        expect(results, isNotEmpty);
        expect(
          results.every((p) => p.name.toLowerCase().contains(firstName.toLowerCase())),
          true,
        );
      });

      test('searchPatients with empty query returns all', () async {
        final all = await repository.getAllPatients();
        final results = await repository.searchPatients('');

        expect(results.length, equals(all.length));
      });

      test('getPatientById returns null for invalid ID', () async {
        final result = await repository.getPatientById('invalid-id');
        expect(result, isNull);
      });

      test('PatientModel.initials computes correctly', () async {
        final patients = await repository.getAllPatients();
        final patient = patients.first;

        expect(patient.initials.length, lessThanOrEqualTo(2));
        expect(patient.initials.isNotEmpty, true);
      });

      test('getPatientById returns patient for valid ID', () async {
        final patients = await repository.getAllPatients();
        final validId = patients.first.id;
        final result = await repository.getPatientById(validId);

        expect(result, isNotNull);
        expect(result!.id, equals(validId));
      });

      test('searchPatients filters by phone number', () async {
        final all = await repository.getAllPatients();
        final phone = all.first.phone;
        final results = await repository.searchPatients(phone);

        expect(results, isNotEmpty);
        expect(results.any((p) => p.phone == phone), true);
      });
    });

    group('StaffRepository', () {
      late StaffRepository repository;

      setUp(() {
        repository = StaffRepository();
      });

      test('getStaffByOrg returns staff for organization', () async {
        final staff = await repository.getStaffByOrg('org1');

        expect(staff, isNotEmpty);
        expect(staff.every((s) => s.orgId == 'org1'), true);
      });

      test('getMedicalStaffByOrg filters to medical professionals', () async {
        final medicalStaff = await repository.getMedicalStaffByOrg('org1');

        expect(medicalStaff.every((s) => s.isMedicalProfessional), true);
      });

      test('findByEmail returns null for unknown email', () async {
        final result = await repository.findByEmail('nonexistent@test.com');
        expect(result, isNull);
      });

      test('getSpecialties returns sorted unique list', () async {
        final specialties = await repository.getSpecialties('org1');

        expect(specialties, isA<List<String>>());
        // Verify sorted
        for (int i = 1; i < specialties.length; i++) {
          expect(specialties[i].compareTo(specialties[i - 1]) >= 0, true);
        }
      });

      test('findByEmail returns staff for valid email', () async {
        final staff = await repository.getStaffByOrg('org1');
        if (staff.isNotEmpty) {
          final validEmail = staff.first.email;
          final result = await repository.findByEmail(validEmail);

          expect(result, isNotNull);
          expect(result!.email.toLowerCase(), equals(validEmail.toLowerCase()));
        }
      });

      test('findByEmail is case-insensitive', () async {
        final staff = await repository.getStaffByOrg('org1');
        if (staff.isNotEmpty) {
          final email = staff.first.email;
          final upperResult = await repository.findByEmail(email.toUpperCase());
          final lowerResult = await repository.findByEmail(email.toLowerCase());

          expect(upperResult?.id, equals(lowerResult?.id));
        }
      });
    });

    group('DashboardRepository', () {
      late DashboardRepository repository;

      setUp(() {
        repository = DashboardRepository();
      });

      test('getKpis returns list of typed KpiModel', () async {
        final kpis = await repository.getKpis();

        expect(kpis, isA<List<KpiModel>>());
        expect(kpis.isNotEmpty, true);
        expect(kpis.first.title, isNotEmpty);
        expect(kpis.first.value, isNotEmpty);
      });

      test('getScores returns list of typed ScoreModel', () async {
        final scores = await repository.getScores();

        expect(scores, isA<List<ScoreModel>>());
        expect(scores.isNotEmpty, true);
        expect(scores.first.title, isNotEmpty);
      });

      test('getCriticalAlert returns AlertModel', () async {
        final alert = await repository.getCriticalAlert();

        expect(alert, isA<AlertModel>());
        expect(alert.message, isNotNull);
      });

      test('KpiModel.isPositiveChange works correctly', () async {
        final kpis = await repository.getKpis();
        
        for (final kpi in kpis) {
          if (kpi.change.startsWith('+')) {
            expect(kpi.isPositiveChange, true);
          } else if (kpi.change.startsWith('-')) {
            expect(kpi.isPositiveChange, false);
          }
        }
      });
    });

    group('AvailabilityRepository', () {
      late AvailabilityRepository repository;

      setUp(() {
        repository = AvailabilityRepository();
      });

      test('getAvailableSlots returns unbooked slots', () async {
        final slots = await repository.getAvailableSlots({'staff1', 'staff2'});

        expect(slots, isA<List<AvailabilityModel>>());
        expect(slots.every((s) => !s.isBooked), true);
      });

      test('AvailabilityModel.endTime computed correctly', () async {
        final slots = await repository.getAvailableSlots({'staff1'});
        
        if (slots.isNotEmpty) {
          final slot = slots.first;
          final expectedEnd = slot.startTime.add(Duration(minutes: slot.durationMinutes));
          expect(slot.endTime, equals(expectedEnd));
        }
      });

      test('getSlotsByProvider returns slots for single provider', () async {
        final allSlots = await repository.getAvailableSlots({'staff1', 'staff2'});
        if (allSlots.isNotEmpty) {
          final providerId = allSlots.first.providerId;
          final providerSlots = await repository.getSlotsByProvider(providerId);

          expect(providerSlots.every((s) => s.providerId == providerId), true);
        }
      });
    });
  });

  group('Model Unit Tests', () {
    group('PatientModel', () {
      test('fromMap/toMap serialization roundtrip', () {
        final map = {
          'id': 'p1',
          'name': 'John Doe',
          'email': 'john@test.com',
          'phone': '555-1234',
          'dob': '1990-01-15',
          'status': 'Active',
          'age': '34',
          'provider': 'Dr. Smith',
        };

        final model = PatientModel.fromMap(map);
        final serialized = model.toMap();

        expect(serialized['id'], equals(map['id']));
        expect(serialized['name'], equals(map['name']));
        expect(serialized['email'], equals(map['email']));
      });

      test('initials handles single name', () {
        final model = PatientModel.fromMap({
          'id': 'p1',
          'name': 'Madonna',
          'email': '',
          'phone': '555-1234',
          'dob': '1990-01-15',
          'status': 'Active',
        });

        expect(model.initials, equals('M'));
      });

      test('initials handles empty name parts', () {
        final model = PatientModel.fromMap({
          'id': 'p1',
          'name': '  John   Doe  ',
          'email': '',
          'phone': '555-1234',
          'dob': '1990-01-15',
          'status': 'Active',
        });

        expect(model.initials.length, lessThanOrEqualTo(2));
      });
    });

    group('StaffModel', () {
      test('fromJson/toJson serialization roundtrip', () {
        final json = {
          'id': 's1',
          'name': 'Dr. Jane Smith',
          'email': 'jane@hospital.com',
          'role': 'Physician',
          'isMedicalProfessional': true,
          'isPharmacist': false,
          'orgId': 'org1',
          'specialty': 'Cardiology',
        };

        final model = StaffModel.fromJson(json);
        final serialized = model.toJson();

        expect(serialized['id'], equals(json['id']));
        expect(serialized['specialty'], equals(json['specialty']));
        expect(model.isMedicalProfessional, true);
      });

      test('unknown() factory creates fallback staff', () {
        final unknown = StaffModel.unknown(orgId: 'testOrg');

        expect(unknown.id, equals('0'));
        expect(unknown.name, equals('Unknown'));
        expect(unknown.orgId, equals('testOrg'));
        expect(unknown.isMedicalProfessional, false);
      });

      test('copyWith creates modified copy', () {
        final original = StaffModel.unknown();
        final modified = original.copyWith(name: 'Updated Name', role: 'Admin');

        expect(modified.name, equals('Updated Name'));
        expect(modified.role, equals('Admin'));
        expect(modified.id, equals(original.id)); // Unchanged fields
      });
    });

    group('AvailabilityModel', () {
      test('fromMap/toMap serialization roundtrip', () {
        final now = DateTime.now();
        final map = {
          'providerId': 'staff1',
          'startTime': now.toIso8601String(),
          'durationMinutes': 30,
          'isBooked': false,
        };

        final model = AvailabilityModel.fromMap(map);
        final serialized = model.toMap();

        expect(serialized['providerId'], equals(map['providerId']));
        expect(serialized['durationMinutes'], equals(30));
      });
    });

    group('OrganizationModel', () {
      test('fromJson/toJson serialization roundtrip', () {
        final json = {
          'id': 'org1',
          'name': 'City Hospital',
          'type': 'Hospital',
        };

        final model = OrganizationModel.fromJson(json);
        final serialized = model.toJson();

        expect(serialized['id'], equals(json['id']));
        expect(serialized['name'], equals(json['name']));
        expect(serialized['type'], equals(json['type']));
      });
    });

    group('DashboardModels', () {
      test('KpiModel.fromMap creates typed model', () {
        final map = {
          'title': 'Revenue',
          'value': '\$50K',
          'change': '+12%',
          'icon': Icons.attach_money,
        };

        final model = KpiModel.fromMap(map);

        expect(model.title, equals('Revenue'));
        expect(model.isPositiveChange, true);
      });

      test('ScoreModel.fromMap creates typed model', () {
        final map = {
          'title': 'Quality',
          'value': '95%',
          'color': Colors.green,
        };

        final model = ScoreModel.fromMap(map);

        expect(model.title, equals('Quality'));
        expect(model.color, equals(Colors.green));
      });

      test('AlertModel.inactive() creates inactive alert', () {
        final alert = AlertModel.inactive();

        expect(alert.isActive, false);
        expect(alert.message, isEmpty);
      });
    });
  });
}
