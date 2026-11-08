import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class StaffDashboardView extends StatelessWidget {
  const StaffDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Staff Dashboard',
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
            'Staff List',
            Icons.chevron_right,
            () => Get.toNamed(Routes.STAFF_LIST),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            'Invite Staff',
            Icons.chevron_right,
            () => Get.toNamed(Routes.INVITE_STAFF),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            'Pending Staff Invites',
            Icons.chevron_right,
            () => Get.toNamed(Routes.PENDING_STAFF_INVITES),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            'Approval Workflow Settings',
            Icons.chevron_right,
            () => Get.toNamed(Routes.APPROVAL_WORKFLOW_SETTINGS),
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            'Staff Action Approval Queue',
            Icons.chevron_right,
            () => Get.toNamed(Routes.APPROVAL_QUEUE),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(icon, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
