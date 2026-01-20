import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/org_dashboard/view/care_root_screen.dart';
import 'package:migenesys_poc/core/data/mock_data.dart';
import 'package:migenesys_poc/features/org_dashboard/view/service_dashboard_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view/medical_dashboard_screen.dart';

class CareLoginScreen extends StatefulWidget {
  const CareLoginScreen({super.key});

  @override
  State<CareLoginScreen> createState() => _CareLoginScreenState();
}

class _CareLoginScreenState extends State<CareLoginScreen> {
  final _emailController = TextEditingController(text: 'alice@migenesys.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // Mock Delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;

    final email = _emailController.text.trim();
    
    // Find user in MockData
    try {
      final user = MockData.staffList.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      // Routing Logic
      debugPrint('🔐 Login: ${user.email} | Role: "${user.role}" | isMedical: ${user.isMedicalProfessional}');
      if (user.role.toLowerCase().contains('service')) {
        debugPrint('   → Routing to ServiceDashboardScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ServiceDashboardScreen(user: user)),
        );
      } else if (user.isMedicalProfessional && user.role != 'Practice Manager') {
        // Medical Professionals (Doctors, Nurses, Specialists) but excluding Admins who might be medical
        // Note: Logic can be refined. For now, if role is explicitly 'Physician', 'Nurse', 'Specialist' -> Medical Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MedicalDashboardScreen(user: user)),
        );
      } else {
        // Default to Admin/Management View (CareRootScreen)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CareRootScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Credentials or User not found')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: 400,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.health_and_safety, size: 80, color: Color(0xFF1565C0)), // Unique Icon
                    const SizedBox(height: 24),
                    const Text(
                      'MiGenesys Care',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Organization Portal',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 48),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
