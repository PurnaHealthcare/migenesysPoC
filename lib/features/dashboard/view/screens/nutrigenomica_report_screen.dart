import 'package:flutter/material.dart';

class NutrigenomicaReportScreen extends StatelessWidget {
  const NutrigenomicaReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MiGenesys Nutrigenomica'),
        backgroundColor: const Color(0xFF81C784),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Nutrition Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildReportItem(
              'Vitamin D Metabolism',
              'Increased risk of deficiency based on VDR gene variants.',
              Colors.orange,
              0.7,
            ),
            _buildReportItem(
              'Omega-3 Response',
              'Enhanced benefit from DHA/EPA supplementation.',
              Colors.green,
              0.9,
            ),
            _buildReportItem(
              'Caffeine Sensitivity',
              'Fast metabolizer (CYP1A2 genotype).',
              Colors.blue,
              0.4,
            ),
            _buildReportItem(
              'Lactose Intolerance',
              'Genetic predisposition to adult-type hypolactasia.',
              Colors.red,
              0.85,
            ),
            const SizedBox(height: 24),
            const Card(
              color: Color(0xFFE8F5E9),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'AI Recommendation',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Based on your nutrigenomic profile, a Mediterranean-style diet with additional Vitamin D supplementation is highly recommended.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showScanPermission(context),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan here to know if your purchase is healthy'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showScanPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect to Camera?'),
        content: const Text('MiGenesys needs permission to access your camera to scan product barcodes and assess health impact.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Don\'t Allow')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Camera connected. Scanning...'), duration: Duration(seconds: 2)),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, String description, Color color, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            backgroundColor: color.withOpacity(0.1),
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
