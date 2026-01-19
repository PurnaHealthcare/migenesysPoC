import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view_model/vitals_provider.dart';

class BloodGlucoseScreen extends ConsumerStatefulWidget {
  const BloodGlucoseScreen({super.key});

  @override
  ConsumerState<BloodGlucoseScreen> createState() => _BloodGlucoseScreenState();
}

class _BloodGlucoseScreenState extends ConsumerState<BloodGlucoseScreen> {
  late TextEditingController _bgController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(vitalsProvider);
    _bgController = TextEditingController(text: state.bloodGlucose?.toString() ?? '');
  }

  void _save() {
    final bg = int.tryParse(_bgController.text);
    if (bg != null) {
      ref.read(vitalsProvider.notifier).updateGlucose(bg);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Glucose Saved')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Glucose')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.water_drop, size: 60, color: Colors.orange),
            const SizedBox(height: 32),
            TextField(
              controller: _bgController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Blood Glucose (mg/dl)',
                border: OutlineInputBorder(),
                suffixText: 'mg/dl',
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                child: const Text('Save Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
