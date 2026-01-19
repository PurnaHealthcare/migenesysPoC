import 'package:flutter/material.dart';
import 'dart:math';

class VitalsGraphWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> dataPoints; // {date: DateTime, value: double}
  final List<DateTime> medicationStartDates;

  const VitalsGraphWidget({
    super.key,
    required this.title,
    required this.dataPoints,
    required this.medicationStartDates,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(
                painter: _GraphPainter(
                  dataPoints: dataPoints,
                  medicationStartDates: medicationStartDates,
                  title: title,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.star, color: Colors.amber, size: 16),
                 SizedBox(width: 4),
                 Text('Medication Started', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<Map<String, dynamic>> dataPoints;
  final List<DateTime> medicationStartDates;
  final String title;

  _GraphPainter({required this.dataPoints, required this.medicationStartDates, required this.title});

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));
    final paintLine = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    final paintAxis = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    // AXIS
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paintAxis); // X
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paintAxis); // Y

    // Determine Y Range
    double minVal = 0;
    double maxVal = 200;
    if (title == 'BMI') { minVal = 10; maxVal = 50; }
    else if (title == 'Blood Glucose') { minVal = 50; maxVal = 250; }
    else if (title == 'Pulse') { minVal = 40; maxVal = 180; }
    
    // Normalize Helper
    double getX(DateTime date) {
      final totalMillis = now.millisecondsSinceEpoch - oneYearAgo.millisecondsSinceEpoch;
      final diff = date.millisecondsSinceEpoch - oneYearAgo.millisecondsSinceEpoch;
      return (diff / totalMillis) * size.width;
    }

    double getY(double value) {
      final range = maxVal - minVal;
      final normalized = (value - minVal) / range;
      return size.height - (normalized * size.height);
    }

    // DRAW DATA POINTS
    for (var point in dataPoints) {
      final date = point['date'] as DateTime;
      final value = point['value'] as double;
      if (date.isAfter(oneYearAgo) && date.isBefore(now)) {
        final x = getX(date);
        final y = getY(value);
        
        // Color Logic
        Color color = Colors.green;
        if (title == 'Blood Pressure') {
             if (value > 140) color = Colors.red; else if (value > 120) color = Colors.orange;
        } else if (title == 'Blood Glucose') {
             if (value > 180) color = Colors.red; else if (value > 140) color = Colors.orange;
        }
        
        canvas.drawCircle(Offset(x, y), 5, Paint()..color = color);
      }
    }

    // DRAW STARS FOR MEDICATIONS
    // Using a path for a star or simple icon drawing
    final starPaint = Paint()..color = Colors.amber;
    for (var date in medicationStartDates) {
       if (date.isAfter(oneYearAgo) && date.isBefore(now)) {
         final x = getX(date);
         // Draw vertical line marking the start
         canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintLine..color = Colors.amber.withOpacity(0.5)..style = PaintingStyle.stroke);
         
         // Draw Star at top
         _drawStar(canvas, x, 10, 8, starPaint);
       }
    }
  }
  
  void _drawStar(Canvas canvas, double cx, double cy, double radius, Paint paint) {
      Path path = Path();
      double innerRadius = radius / 2.5;
      for (int i = 0; i < 10; i++) {
        double angle = (i * 36 * pi) / 180;
        double r = (i % 2 == 0) ? radius : innerRadius;
        double x = cx + r * sin(angle);
        double y = cy - r * cos(angle);
        if (i == 0) path.moveTo(x, y);
        else path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
