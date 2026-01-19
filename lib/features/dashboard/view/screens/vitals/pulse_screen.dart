import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view_model/vitals_provider.dart';
import '../../widgets/vitals_timeline_graph.dart';

class PulseScreen extends ConsumerStatefulWidget {
  const PulseScreen({super.key});

  @override
  ConsumerState<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends ConsumerState<PulseScreen> {
  late TextEditingController _pulseController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(vitalsProvider);
    _pulseController = TextEditingController(text: state.pulse?.toString() ?? '');
  }

  void _save() {
    final pulse = int.tryParse(_pulseController.text);
    if (pulse != null) {
      ref.read(vitalsProvider.notifier).updatePulse(pulse);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pulse Saved')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pulse')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.monitor_heart, size: 60, color: Colors.pink),
            const SizedBox(height: 32),
            TextField(
              controller: _pulseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Heart Rate (bpm)',
                border: OutlineInputBorder(),
                suffixText: 'bpm',
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                child: const Text('Save Record'),
              ),
            ),
            const SizedBox(height: 24),
            const VitalsTimelineGraph(title: 'Pulse'),
          ],
        ),
      ),
    );
  }
}
