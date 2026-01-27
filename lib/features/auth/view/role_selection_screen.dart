import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/org_dashboard/view/care_login_screen.dart';
import 'package:migenesys_poc/features/auth/view/login_screen.dart';
import 'package:migenesys_poc/features/auth/view/doc_assist_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.hub,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'MiGenesys Simulation',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a Role to Begin',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 48),
                _buildRoleCard(
                  context,
                  title: 'Care Organization',
                  subtitle: 'For Managers, Staff & Service',
                  icon: Icons.business,
                  color: Colors.blue.shade700,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CareLoginScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRoleCard(
                  context,
                  title: 'DocAssist Provider',
                  subtitle: 'For Physicians & Medical Pros',
                  icon: Icons.medical_services,
                  color: Colors.indigo.shade600,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DocAssistLoginScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRoleCard(
                  context,
                  title: 'Patient Portal',
                  subtitle: 'For Members & Partners',
                  icon: Icons.person,
                  color: Colors.teal.shade600,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'MiGenesys PoC Environment',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
