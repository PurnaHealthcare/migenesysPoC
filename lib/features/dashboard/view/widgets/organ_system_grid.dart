import 'package:flutter/material.dart';

class OrganSystemGrid extends StatelessWidget {
  const OrganSystemGrid({super.key});

  final List<Map<String, dynamic>> _organs = const [
    {'name': 'Cardiovascular', 'icon': Icons.favorite, 'color': Colors.red},
    {'name': 'Neurology', 'icon': Icons.psychology, 'color': Colors.pink}, // Brain
    {'name': 'Respiratory', 'icon': Icons.air, 'color': Colors.blue}, // Lung
    {'name': 'Gastro', 'icon': Icons.lunch_dining, 'color': Colors.orange}, // Stomach/Gaster
    {'name': 'Renal', 'icon': Icons.water_drop, 'color': Colors.brown}, // Kidney
  ];

  void _showDiagnosisDialog(BuildContext context, String organName) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('$organName Diagnosis'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter diagnosis...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Save diagnosis
                // For PoC, just close
                if (controller.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Saved $organName diagnosis: ${controller.text}')),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Organ Systems',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF455A64)),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: _organs.length,
          itemBuilder: (context, index) {
            final organ = _organs[index];
            return InkWell(
              onTap: () => _showDiagnosisDialog(context, organ['name']),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(organ['icon'], size: 32, color: organ['color']),
                    const SizedBox(height: 8),
                    Text(
                      organ['name'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
