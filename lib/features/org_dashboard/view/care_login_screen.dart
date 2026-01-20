import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/org_dashboard/view/care_root_screen.dart';
import 'package:migenesys_poc/core/repositories/staff_repository.dart';
import 'package:migenesys_poc/features/org_dashboard/view/service_dashboard_screen.dart';
import 'package:migenesys_poc/features/org_dashboard/view/medical_dashboard_screen.dart';

class CareLoginScreen extends ConsumerStatefulWidget {
  const CareLoginScreen({super.key});

  @override
  ConsumerState<CareLoginScreen> createState() => _CareLoginScreenState();
}

class _CareLoginScreenState extends ConsumerState<CareLoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Only pre-fill credentials in debug mode
    _emailController = TextEditingController(text: kDebugMode ? 'alice@migenesys.com' : '');
    _passwordController = TextEditingController(text: kDebugMode ? 'password' : '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    
    final email = _emailController.text.trim();
    final repository = ref.read(staffRepositoryProvider);

    try {
      final user = await repository.findByEmail(email);
      
      if (user == null) {
        throw Exception('User not found');
      }

      if (!mounted) return;

      debugPrint('🔐 Login: ${user.email} | Role: "${user.role}" | isMedical: ${user.isMedicalProfessional}');
      
      // Routing Logic based on role
      if (user.role.toLowerCase().contains('service')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ServiceDashboardScreen(user: user)),
        );
      } else if (user.isMedicalProfessional && !user.role.toLowerCase().contains('manager')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MedicalDashboardScreen(user: user)),
        );
      } else {
        // Admin/Manager role
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CareRootScreen(user: user)),
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
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset coming soon')),
                  ),
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
