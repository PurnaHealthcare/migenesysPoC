import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view_model/vitals_provider.dart';

class BmiScreen extends ConsumerStatefulWidget {
  const BmiScreen({super.key});

  @override
  ConsumerState<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends ConsumerState<BmiScreen> {
  // BMI Controllers
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _feetController;
  late TextEditingController _inchesController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(vitalsProvider);
    _heightController = TextEditingController(text: state.height?.toStringAsFixed(0) ?? '');
    _weightController = TextEditingController(text: state.weight?.toStringAsFixed(1) ?? '');
    
    // Reverse calc for ft/in
    double feet = 0;
    double inches = 0;
    if (state.height != null) {
      double totalInches = state.height! / 2.54;
      feet = (totalInches / 12).floorToDouble();
      inches = totalInches % 12;
    }
    _feetController = TextEditingController(text: feet > 0 ? feet.toStringAsFixed(0) : '');
    _inchesController = TextEditingController(text: inches > 0 ? inches.toStringAsFixed(0) : '');
  }

  void _updateState() {
    final notifier = ref.read(vitalsProvider.notifier);
    final isMetric = ref.read(vitalsProvider).isMetric;
    
    double? h;
    double? w = double.tryParse(_weightController.text);
    
    if (isMetric) {
      h = double.tryParse(_heightController.text);
    } else {
      // Convert Imperial inputs to stored Metric values
      double f = double.tryParse(_feetController.text) ?? 0;
      double i = double.tryParse(_inchesController.text) ?? 0;
      if (f > 0 || i > 0) {
        h = ((f * 12) + i) * 2.54;
      }
      
      if (w != null) {
        w = w * 0.453592; // lbs to kg
      }
    }
    
    notifier.updateBMI(height: h, weight: w);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vitalsProvider);
    final bmi = state.bmi;

    Color bmiColor = Colors.grey;
    if (bmi != null) {
      if (bmi < 25.0) bmiColor = Colors.green;
      else if (bmi < 30.0) bmiColor = Colors.amber;
      else if (bmi < 40.0) bmiColor = Colors.red;
      else bmiColor = Colors.purple;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Imperial'),
                Switch(
                  value: state.isMetric,
                  onChanged: (val) {
                    ref.read(vitalsProvider.notifier).updateBMI(isMetric: val);
                  },
                ),
                const Text('Metric'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: state.isMetric
                      ? TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
                          onChanged: (_) => _updateState(),
                        )
                      : Row(
                          children: [
                            Expanded(child: TextField(controller: _feetController, decoration: const InputDecoration(labelText: 'ft', border: OutlineInputBorder()), onChanged: (_) => _updateState())),
                            const SizedBox(width: 8),
                            Expanded(child: TextField(controller: _inchesController, decoration: const InputDecoration(labelText: 'in', border: OutlineInputBorder()), onChanged: (_) => _updateState())),
                          ],
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: state.isMetric ? 'Weight (kg)' : 'Weight (lbs)',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _updateState(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (bmi != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: bmiColor.withOpacity(0.1),
                  border: Border.all(color: bmiColor, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Text(
                      bmi.toStringAsFixed(1),
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: bmiColor),
                    ),
                    const Text('BMI', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            // Personal Details (Age/Gender) could be here too as per request "move all info here",
            // but usually demographics are static. For now implemented the main math inputs.
          ],
        ),
      ),
    );
  }
}
