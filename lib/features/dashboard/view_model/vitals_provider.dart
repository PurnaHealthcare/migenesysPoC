import 'package:flutter_riverpod/flutter_riverpod.dart';

class VitalsState {
  final double? height; // in cm
  final double? weight; // in kg
  final bool isMetric;
  final int? bpSystolic;
  final int? bpDiastolic;
  final int? bloodGlucose;
  final int? pulse;
  final int? respiratoryRate;

  const VitalsState({
    this.height,
    this.weight,
    this.isMetric = true,
    this.bpSystolic,
    this.bpDiastolic,
    this.bloodGlucose,
    this.pulse,
    this.respiratoryRate,
  });

  VitalsState copyWith({
    double? height,
    double? weight,
    bool? isMetric,
    int? bpSystolic,
    int? bpDiastolic,
    int? bloodGlucose,
    int? pulse,
    int? respiratoryRate,
  }) {
    return VitalsState(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isMetric: isMetric ?? this.isMetric,
      bpSystolic: bpSystolic ?? this.bpSystolic,
      bpDiastolic: bpDiastolic ?? this.bpDiastolic,
      bloodGlucose: bloodGlucose ?? this.bloodGlucose,
      pulse: pulse ?? this.pulse,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
    );
  }

  double? get bmi {
    if (height == null || weight == null || height! <= 0 || weight! <= 0) return null;
    // Height stored in cm, convert to meters
    final hM = height! / 100;
    return weight! / (hM * hM);
  }
}

class VitalsNotifier extends Notifier<VitalsState> {
  @override
  VitalsState build() {
    return const VitalsState();
  }

  void updateBMI({double? height, double? weight, bool? isMetric}) {
    state = state.copyWith(
      height: height,
      weight: weight,
      isMetric: isMetric,
    );
  }

  void updateBP(int systolic, int diastolic) {
    state = state.copyWith(bpSystolic: systolic, bpDiastolic: diastolic);
  }

  void updateGlucose(int glucose) {
    state = state.copyWith(bloodGlucose: glucose);
  }

  void updatePulse(int pulse) {
    state = state.copyWith(pulse: pulse);
  }

  void updateRespiratoryRate(int rate) {
    state = state.copyWith(respiratoryRate: rate);
  }
}

final vitalsProvider = NotifierProvider<VitalsNotifier, VitalsState>(() {
  return VitalsNotifier();
});
