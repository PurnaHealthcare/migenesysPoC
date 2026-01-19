import 'package:flutter/material.dart';

class FamilyHistoryScreen extends StatefulWidget {
  const FamilyHistoryScreen({super.key});

  @override
  State<FamilyHistoryScreen> createState() => _FamilyHistoryScreenState();
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {
  final List<String> _commonConditions = [
    'I10 - Essential (primary) hypertension',
    'E11 - Type 2 diabetes mellitus',
    'I25.10 - Atherosclerotic heart disease',
    'E78.5 - Hyperlipidemia, unspecified',
    'J45 - Asthma',
    'C34 - Malignant neoplasm of bronchus and lung',
    'F32 - Major depressive disorder',
    'M19.9 - Osteoarthritis, unspecified site',
  ];

  List<String> _filteredConditions = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredConditions = _commonConditions;
  }

  void _filterConditions(String query) {
    setState(() {
      _filteredConditions = _commonConditions
          .where((c) => c.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family History'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF455A64),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conditions (ICD-10)...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: _filterConditions,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredConditions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredConditions[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${_filteredConditions[index]}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
