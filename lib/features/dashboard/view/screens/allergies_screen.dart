import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/dashboard/view_model/allergies_provider.dart';

class AllergiesScreen extends ConsumerStatefulWidget {
  const AllergiesScreen({super.key});

  @override
  ConsumerState<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends ConsumerState<AllergiesScreen> {
  final List<String> _commonAllergens = [
    'Penicillin',
    'Peanuts',
    'Latex',
    'Shellfish',
    'Pollen',
    'Dust Mites',
    'Sulfa Drugs',
    'Insulin',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedAllergies = ref.watch(allergiesProvider);
    final notifier = ref.read(allergiesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergies & Intolerances'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF455A64),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedAllergies.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Selected:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                children: selectedAllergies.map((allergy) {
                  return Chip(
                    label: Text(allergy),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      notifier.removeAllergy(allergy);
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(),
          ],
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Common Allergens',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _commonAllergens.length,
              itemBuilder: (context, index) {
                final allergen = _commonAllergens[index];
                final isSelected = selectedAllergies.contains(allergen);
                return CheckboxListTile(
                  title: Text(allergen),
                  value: isSelected,
                  onChanged: (bool? value) {
                    if (value == true) {
                      notifier.addAllergy(allergen);
                    } else {
                      notifier.removeAllergy(allergen);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
