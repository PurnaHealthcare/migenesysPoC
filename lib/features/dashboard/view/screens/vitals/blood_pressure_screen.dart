import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view_model/vitals_provider.dart';

class BloodPressureScreen extends ConsumerStatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  ConsumerState<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends ConsumerState<BloodPressureScreen> {
  late TextEditingController _sysController;
  late TextEditingController _diaController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(vitalsProvider);
    _sysController = TextEditingController(text: state.bpSystolic?.toString() ?? '');
    _diaController = TextEditingController(text: state.bpDiastolic?.toString() ?? '');
  }

  void _save() {
    final sys = int.tryParse(_sysController.text);
    final dia = int.tryParse(_diaController.text);
    if (sys != null && dia != null) {
      ref.read(vitalsProvider.notifier).updateBP(sys, dia);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('BP Saved')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Pressure')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.favorite, size: 60, color: Colors.red),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Systolic (mmHg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('/', style: TextStyle(fontSize: 24, color: Colors.grey)),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _diaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Diastolic (mmHg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Save Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
