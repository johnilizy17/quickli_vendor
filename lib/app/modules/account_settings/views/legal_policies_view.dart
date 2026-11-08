import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LegalPoliciesView extends StatelessWidget {
  const LegalPoliciesView({Key? key}) : super(key: key);

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
          'Legal & Policies',
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
          _buildPolicyItem(
            icon: Icons.description_outlined,
            iconColor: Colors.grey,
            title: 'Terms of Service',
            onTap: () => Get.toNamed('/legal/terms'),
          ),
          const SizedBox(height: 16),
          _buildPolicyItem(
            icon: Icons.lock_outline,
            iconColor: Colors.grey,
            title: 'Privacy Policy',
            onTap: () => Get.toNamed('/legal/privacy'),
          ),
          const SizedBox(height: 16),
          _buildPolicyItem(
            icon: Icons.handshake_outlined,
            iconColor: Colors.orange,
            title: 'Vendor Agreement',
            onTap: () => Get.toNamed('/legal/vendor-agreement'),
          ),
          const SizedBox(height: 16),
          _buildPolicyItem(
            icon: Icons.account_balance_outlined,
            iconColor: Colors.orange,
            title: 'Payout & Refund Policy',
            onTap: () => Get.toNamed('/legal/payout-refund'),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
