import 'package:flutter/material.dart';

class ProviderMapScreen extends StatelessWidget {
  const ProviderMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Provider')),
      body: Stack(
        children: [
          // Mock Map Background
          Container(
            color: const Color(0xFFE0E0E0),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: Colors.grey),
                  Text('Map Placeholder', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          // Pins (Mock)
          const Positioned(
            top: 150,
            left: 100,
            child: Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
          const Positioned(
            top: 300,
            right: 80,
            child: Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
          
          // Provider List / Card
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      leading: CircleAvatar(child: Icon(Icons.location_city)),
                      title: Text('Q\'Ra'),
                      subtitle: Text('Diagnostic Imaging Center • 0.8 miles away'),
                      trailing: Icon(Icons.star, color: Colors.amber),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: CircleAvatar(child: Icon(Icons.business)),
                      title: Text('Hospital de los Valles'),
                      subtitle: Text('Full-service Hospital • 2.4 miles away'),
                      trailing: Icon(Icons.star, color: Colors.amber),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling Hospital de los Valles...')),
                            );
                          },
                          icon: const Icon(Icons.call),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Navigating to Q\'Ra...')),
                            );
                          },
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
