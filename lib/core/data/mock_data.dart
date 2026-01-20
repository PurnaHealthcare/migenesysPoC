import 'package:flutter/material.dart';
import '../../features/org_dashboard/domain/staff_model.dart';
import '../../features/org_dashboard/domain/organization_model.dart';
import '../../features/org_dashboard/domain/availability_model.dart';
import '../../core/analytics/analytics_event.dart';

class MockData {
  // --- Organizations ---
  static final List<OrganizationModel> organizations = [
    OrganizationModel(id: 'org1', name: 'Downtown Clinic', type: 'Clinic'),
    OrganizationModel(id: 'org2', name: 'Specialty Center', type: 'Specialty Center'),
  ];

  // --- Org Dashboard Data (Mock - potentially filtered by Org in future) ---
  static const List<Map<String, dynamic>> dashboardScores = [
    {'title': 'Efficiency Score', 'value': '88/100', 'color': Colors.blue, 'trend': '+2.5%'},
    {'title': 'Patient Satisfaction', 'value': '4.9/5.0', 'color': Colors.green, 'trend': '+0.1'},
    {'title': 'Provider Satisfaction', 'value': '94/100', 'color': Colors.orange, 'trend': '+1.2%'},
  ];

  static const List<Map<String, dynamic>> dashboardKpis = [
    {'title': 'Unique Visits', 'value': '156', 'change': '+14%', 'icon': Icons.people},
    {'title': 'Avg Wait Time', 'value': '14m', 'change': '-4m', 'icon': Icons.timer},
    {'title': 'New Patients', 'value': '32', 'change': '+8%', 'icon': Icons.person_add},
    {'title': 'No-Shows', 'value': '3', 'change': '-25%', 'icon': Icons.event_busy},
  ];

  static const bool hasCriticalAlert = true;
  static const String criticalAlertMessage = 'CRITICAL: ER Overflow (112% Capacity). Divert enabled.';

  // --- Staff Data ---
  static final List<StaffModel> staffList = [
    StaffModel(
      id: 's1',
      name: 'Dr. Sarah Connor',
      email: 's.connor@migenesys.com',
      role: 'Physician',
      isMedicalProfessional: true,
      orgId: 'org1',
    ),
    StaffModel(
      id: 's2',
      name: 'Nurse John Smith',
      email: 'j.smith@migenesys.com',
      role: 'Nurse',
      isMedicalProfessional: true,
      orgId: 'org1',
    ),
    StaffModel(
      id: 's3',
      name: 'Alice Admin',
      email: 'alice@migenesys.com',
      role: 'Practice Manager',
      isMedicalProfessional: false,
      orgId: 'org1',
    ),
    StaffModel(
      id: 's4',
      name: 'Pharm. David Miller',
      email: 'd.miller@migenesys.com',
      role: 'Pharmacist',
      isMedicalProfessional: true,
      isPharmacist: true,
      orgId: 'org1',
    ),
     StaffModel(
      id: 's5',
      name: 'Dr. Emily Chen',
      email: 'e.chen@migenesys.com',
      role: 'Specialist',
      isMedicalProfessional: true,
      orgId: 'org2',
    ),
    // New Test Users for Phase 2
    StaffModel(
      id: 's6',
      name: 'Service Agent',
      email: 'service@example.com',
      role: 'Customer Service',
      isMedicalProfessional: false,
      orgId: 'org1', // Downtown Clinic
    ),
    StaffModel(
      id: 's7',
      name: 'Dr. Medical Pro',
      email: 'med@example.com',
      role: 'Physician',
      isMedicalProfessional: true,
      orgId: 'org2', // Specialty Center
    ),
  ];

  // --- Availability Data (Mock) ---
  static final List<AvailabilityModel> availability = [
    // Dr. Connor (Org 1)
    AvailabilityModel(providerId: 's1', startTime: DateTime.now().add(const Duration(hours: 1)), durationMinutes: 30),
    AvailabilityModel(providerId: 's1', startTime: DateTime.now().add(const Duration(hours: 2)), durationMinutes: 30),
    AvailabilityModel(providerId: 's1', startTime: DateTime.now().add(const Duration(hours: 3)), durationMinutes: 30, isBooked: true),
    
    // Dr. Chen (Org 2) - Medical Pro
    AvailabilityModel(providerId: 's5', startTime: DateTime.now().add(const Duration(hours: 1)), durationMinutes: 45),
    AvailabilityModel(providerId: 's5', startTime: DateTime.now().add(const Duration(hours: 3)), durationMinutes: 45),
    
    // Dr. Medical Pro (Org 2)
    AvailabilityModel(providerId: 's7', startTime: DateTime.now().add(const Duration(days: 1, hours: 9)), durationMinutes: 60),
    AvailabilityModel(providerId: 's7', startTime: DateTime.now().add(const Duration(days: 1, hours: 11)), durationMinutes: 60),
  ];

  // --- Patient Data ---
  static const List<Map<String, dynamic>> patients = [
    {
      'id': 'p1',
      'name': 'James T. Kirk',
      'email': 'jtk@enterprise.com',
      'phone': '(555) 170-1000',
      'dob': '1980-03-22',
      'age': '45',
      'status': 'In Exam Room 2',
      'provider': 'Dr. Connor',
      'lastVisit': '2025-10-15',
      'nextVisit': '2026-02-10',
      'condition': 'Hypertension',
    },
    {
      'id': 'p2',
      'name': 'Jean-Luc Picard',
      'email': 'picard@starfleet.org',
      'phone': '(555) 170-1701',
      'dob': '1975-07-13',
      'age': '50',
      'status': 'Checked In',
      'provider': 'Dr. Chen',
      'lastVisit': '2025-11-20',
      'nextVisit': 'Today',
      'condition': 'Annual Checkup',
    },
    {
      'id': 'p3',
      'name': 'Kathryn Janeway',
      'email': 'janeway@voyager.net',
      'phone': '(555) 746-5683',
      'dob': '1982-05-20',
      'age': '43',
      'status': 'Completed',
      'provider': 'Dr. Connor',
      'lastVisit': '2026-01-10',
      'nextVisit': '2026-07-10',
      'condition': 'Migraine',
    },
     {
      'id': 'p4',
      'name': 'Benjamin Sisko',
      'email': 'sisko@ds9.st',
      'phone': '(555) 987-6543',
      'dob': '1978-01-02',
      'age': '48',
      'status': 'Waiting',
      'provider': 'Pharm. Miller',
      'lastVisit': '2025-12-05',
      'nextVisit': 'Today',
      'condition': 'Medication Review',
    },
  ];

  // --- Clinical Data (Mock) ---
  static const Map<String, dynamic> patientClinicalData = {
    'medications': [
      {'name': 'Lisinopril', 'dosage': '10mg daily', 'prescriber': 'Dr. Connor'},
      {'name': 'Atorvastatin', 'dosage': '20mg nightly', 'prescriber': 'Dr. Connor'},
    ],
    'vitals': [
      {'type': 'Blood Pressure', 'value': '120/80 mmHg', 'date': 'Today'},
      {'type': 'Heart Rate', 'value': '72 bpm', 'date': 'Today'},
      {'type': 'Weight', 'value': '185 lbs', 'date': 'Today'},
    ],
    'allergies': ['Penicillin', 'Peanuts'],
  };
}
