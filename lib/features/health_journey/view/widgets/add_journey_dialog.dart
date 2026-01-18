import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/health_journey.dart';
import '../../view_model/health_journey_view_model.dart';

class AddJourneyDialog extends StatefulWidget {
  final WidgetRef ref;
  const AddJourneyDialog({super.key, required this.ref});

  @override
  State<AddJourneyDialog> createState() => _AddJourneyDialogState();
}

class _AddJourneyDialogState extends State<AddJourneyDialog> {
  final _titleController = TextEditingController();
  final _medSearchController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();

  DateTime _startDate = DateTime.now();
  String _period = '3 Months';
  List<Medication> _selectedMedications = [];
  bool _showMedicationInputs = false;
  Map<String, String>? _currentMedication;

  final List<Map<String, String>> _mockMeds = [
    {
      'brand': 'Norvasc',
      'generic': 'Amlodipine',
      'dosage': '5mg',
      'freq': 'Once daily',
    },
    {
      'brand': 'Zestril',
      'generic': 'Lisinopril',
      'dosage': '10mg',
      'freq': 'Once daily',
    },
    {
      'brand': 'Glucophage',
      'generic': 'Metformin',
      'dosage': '500mg',
      'freq': 'Twice daily',
    },
  ];

  void _onMedicationSelected(Map<String, String> med) {
    setState(() {
      _currentMedication = med;
      _dosageController.text = med['dosage']!;
      _frequencyController.text = med['freq']!;
      _showMedicationInputs = true;
    });
  }

  void _addMedication() {
    if (_currentMedication == null) return;

    setState(() {
      _selectedMedications.add(
        Medication(
          brandName: _currentMedication!['brand']!,
          genericName: _currentMedication!['generic']!,
          dosage: _dosageController.text,
          frequency: _frequencyController.text,
        ),
      );
      _currentMedication = null;
      _medSearchController.clear();
      _dosageController.clear();
      _frequencyController.clear();
      _showMedicationInputs = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('What would you like to take care of today? 💙'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const ValueKey('journey_title_field'),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Journey Title',
                hintText: 'e.g., Hypertension Care',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Medications 💊',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._selectedMedications.map(
              (m) => ListTile(
                title: Text(m.brandName),
                subtitle: Text(
                  '${m.genericName} - ${m.dosage}, ${m.frequency}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () =>
                      setState(() => _selectedMedications.remove(m)),
                ),
              ),
            ),
            if (!_showMedicationInputs)
              Autocomplete<Map<String, String>>(
                displayStringForOption: (option) => option['brand']!,
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty)
                    return const Iterable.empty();
                  return _mockMeds.where(
                    (m) => m['brand']!.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                onSelected: _onMedicationSelected,
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      _medSearchController.text = controller.text;
                      return TextField(
                        key: const ValueKey('med_search_field'),
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Search medication brand...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      );
                    },
              ),
            if (_showMedicationInputs) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Confirm Dosage'),
              ),
              TextField(
                controller: _frequencyController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Frequency',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addMedication,
                child: const Text('Add Medication 💊'),
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Journey Timeline 🌱',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text(_startDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) setState(() => _startDate = date);
              },
            ),
            DropdownButtonFormField<String>(
              value: _period,
              decoration: const InputDecoration(labelText: 'Period'),
              items: [
                'Ongoing',
                '1 Month',
                '3 Months',
                '6 Months',
                '1 Year',
              ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => setState(() => _period = val!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _titleController,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const ValueKey('add_journey_submit_btn'),
              onPressed: value.text.isNotEmpty
                  ? () async {
                      await widget.ref
                          .read(healthJourneyNotifierProvider.notifier)
                          .startNewJourney(
                            title: _titleController.text,
                            startDate: _startDate,
                            period: _period,
                            medications: _selectedMedications,
                          );
                      if (context.mounted) Navigator.pop(context);
                    }
                  : null,
              child: const Text('Start Journey 🌱'),
            );
          },
        ),
      ],
    );
  }
}
