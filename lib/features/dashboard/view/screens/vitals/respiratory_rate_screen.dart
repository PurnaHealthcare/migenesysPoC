import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view_model/vitals_provider.dart';
import '../../widgets/vitals_timeline_graph.dart';

class RespiratoryRateScreen extends ConsumerStatefulWidget {
  const RespiratoryRateScreen({super.key});

  @override
  ConsumerState<RespiratoryRateScreen> createState() => _RespiratoryRateScreenState();
}

class _RespiratoryRateScreenState extends ConsumerState<RespiratoryRateScreen> {
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(vitalsProvider);
    _rateController = TextEditingController(text: state.respiratoryRate?.toString() ?? '');
  }

  void _save() {
    final rate = int.tryParse(_rateController.text);
    if (rate != null) {
      ref.read(vitalsProvider.notifier).updateRespiratoryRate(rate);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Respiratory Rate Saved')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Respiratory Rate')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.air, size: 60, color: Colors.blue),
            const SizedBox(height: 32),
            TextField(
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Breaths per minute',
                border: OutlineInputBorder(),
                suffixText: 'breaths/min',
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  foregroundColor: Colors.white
                ),
                child: const Text('Save Record'),
              ),
            ),
            const SizedBox(height: 24),
            const VitalsTimelineGraph(title: 'Respiratory Rate'),
          ],
        ),
      ),
    );
  }
}
