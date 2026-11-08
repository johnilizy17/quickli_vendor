import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsDashboardView extends StatelessWidget {
  const AccountSettingsDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuItem(
            icon: Icons.key_outlined,
            iconColor: Colors.orange,
            title: 'Change password',
            subtitle: 'Last changed 2 months ago',
            onTap: () => Get.toNamed('/change-password'),
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.description_outlined,
            iconColor: Colors.grey,
            title: 'Activity Log',
            onTap: () => Get.toNamed('/activity-log'),
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.gavel_outlined,
            iconColor: Colors.grey,
            title: 'Legal & Policies',
            onTap: () => Get.toNamed('/legal-policies'),
          ),
          const SizedBox(height: 100),
          Center(
            child: TextButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                      'Are you sure you want to delete your business account? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.snackbar('Info', 'Account deletion initiated');
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Delete your business account',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
