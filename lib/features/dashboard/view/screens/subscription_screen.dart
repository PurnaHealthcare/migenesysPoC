import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/subscription_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  final String overlayTitle;

  const SubscriptionScreen({super.key, required this.overlayTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscribe')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              'Unlock $overlayTitle',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Get advanced insights and personalized reports with our premium subscription.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
             Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('\$9.99 / month', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Cancel anytime', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(subscriptionProvider.notifier).subscribe();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Subscribed to $overlayTitle!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64B5F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Pay Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
