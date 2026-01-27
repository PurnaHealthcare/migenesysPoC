import 'package:flutter/material.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({super.key});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a short delay for the "secure exit" process
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        // Navigate to the Role Selection Screen (Root)
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Securely Logging Out...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thank you for using MiGenesys Patient Portal',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
