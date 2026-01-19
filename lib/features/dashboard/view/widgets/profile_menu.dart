import 'package:flutter/material.dart';
import '../screens/security_screen.dart';
import '../screens/family_history_screen.dart';
import '../screens/allergies_screen.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            context,
            icon: Icons.security,
            title: 'Security',
            color: Colors.blueGrey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecurityScreen()),
            ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.family_restroom,
            title: 'Family History',
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FamilyHistoryScreen()),
            ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.coronavirus, // Allergen icon
            title: 'Allergies',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllergiesScreen()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.pop(context); // Close sheet
        onTap();
      },
    );
  }
}
