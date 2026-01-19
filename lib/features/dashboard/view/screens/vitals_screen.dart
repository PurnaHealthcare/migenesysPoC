import 'package:flutter/material.dart';
import 'vitals/bmi_screen.dart';
import 'vitals/blood_pressure_screen.dart';
import 'vitals/blood_glucose_screen.dart';
import 'vitals/pulse_screen.dart';
import 'vitals/respiratory_rate_screen.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate pop-up after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWearableDialog();
    });
  }

  void _showWearableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect Wearable?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.watch_rounded, size: 48, color: Colors.blue),
            SizedBox(height: 16),
            Text('Would you like to sync data from your Apple Watch or Fitbit?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Searching for devices...')),
              );
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vitals'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF455A64),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildVitalTile(
            context,
            'BMI',
            Icons.monitor_weight_outlined,
            Colors.green,
            const BmiScreen(),
          ),
          _buildVitalTile(
            context,
            'Blood Pressure',
            Icons.favorite_border,
            Colors.red,
            const BloodPressureScreen(),
          ),
          _buildVitalTile(
            context,
            'Blood Glucose',
            Icons.water_drop_outlined,
            Colors.orange,
            const BloodGlucoseScreen(),
          ),
          _buildVitalTile(
            context,
            'Pulse',
            Icons.monitor_heart_outlined,
            Colors.pink,
            const PulseScreen(),
          ),
           _buildVitalTile(
            context,
            'Respiratory',
            Icons.air,
            Colors.blue,
            const RespiratoryRateScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalTile(BuildContext context, String title, IconData icon, Color color, Widget destination) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
