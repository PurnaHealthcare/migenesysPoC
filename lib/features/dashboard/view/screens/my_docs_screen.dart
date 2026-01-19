import 'package:flutter/material.dart';

class MyDocsScreen extends StatelessWidget {
  const MyDocsScreen({super.key});

  void _handleUpload(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _simulateCameraAccess(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload File'),
              onTap: () {
                Navigator.pop(context);
                _simulateUpload(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _simulateCameraAccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('“MiGenesys” Would Like to Access the Camera'),
        content: const Text('This lets you scan documents and upload them directly to your profile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Don't Allow
            child: const Text('Don’t Allow'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateUpload(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _simulateUpload(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Document uploaded successfully!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Docs'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF455A64),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No documents yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _handleUpload(context),
              icon: const Icon(Icons.upload),
              label: const Text('Upload Document'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
