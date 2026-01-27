import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/patient_mgmt/view/physician_dashboard_screen.dart';
import 'package:migenesys_poc/core/repositories/staff_repository.dart';

class DocAssistLoginScreen extends ConsumerStatefulWidget {
  const DocAssistLoginScreen({super.key});

  @override
  ConsumerState<DocAssistLoginScreen> createState() => _DocAssistLoginScreenState();
}

class _DocAssistLoginScreenState extends ConsumerState<DocAssistLoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with a doctor's email for convenience in debug mode
    _emailController = TextEditingController(text: kDebugMode ? 's.connor@migenesys.com' : '');
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
      // Simulate network delay for realism
      await Future.delayed(const Duration(seconds: 1));

      final user = await repository.findByEmail(email);
      
      if (user == null) {
        throw Exception('User not found');
      }

      if (!mounted) return;

      debugPrint('🔐 DocAssist Login: ${user.email} | Role: "${user.role}" | isMedical: ${user.isMedicalProfessional}');
      
      // Strict role validation for DocAssist
      if (user.isMedicalProfessional) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PhysicianDashboardScreen()),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access Denied: Account is not authorized for DocAssist.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
        }
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - kToolbarHeight, // Adjust for AppBar
                maxWidth: 400,
              ),
              child: Center(
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.medical_services_outlined, size: 64, color: Colors.indigo),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'DocAssist',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Provider Portal',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 48),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Provider Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
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
            ),
          );
        },
      ),
    );
  }
}
