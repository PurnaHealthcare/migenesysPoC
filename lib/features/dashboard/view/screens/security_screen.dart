import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF455A64),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSecurityOption(
            context,
            icon: Icons.lock_reset,
            title: 'Reset Password',
            subtitle: 'Change your login password',
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password Reset link sent to email.')),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSecurityOption(
            context,
            icon: Icons.phonelink_lock,
            title: 'Multi-Factor Authentication (MFA)',
            subtitle: 'Enhance your account security',
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to MFA setup flow.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE3F2FD),
          child: Icon(icon, color: const Color(0xFF64B5F6)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
