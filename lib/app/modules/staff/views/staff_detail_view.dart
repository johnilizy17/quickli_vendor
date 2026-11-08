import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/staff_controller.dart';
import '../../../routes/app_pages.dart';

class StaffDetailView extends GetView<StaffController> {
  const StaffDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final staffId = Get.arguments as String;
    final staff = controller.getStaffById(staffId);

    if (staff == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Staff Detail'),
        ),
        body: const Center(
          child: Text('Staff not found'),
        ),
      );
    }

    final activities = controller.getStaffActivities(staffId);

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
          'Staff Detail',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.EDIT_STAFF, arguments: staffId),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B46C1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Edit Staff',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF6B46C1),
                  radius: 32,
                  child: Text(
                    staff.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      staff.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: staff.status == 'online' ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      staff.role,
                      style: const TextStyle(
                        color: Color(0xFF6B46C1),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      staff.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Last active: ${staff.lastActive}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Actions
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    'Reset Staff Password',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Password reset link sent to staff',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(
                  title: const Text(
                    'Suspend Staff',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Switch(
                    value: staff.status == 'away',
                    onChanged: (value) {
                      Get.snackbar(
                        'Info',
                        value ? 'Staff suspended' : 'Staff activated',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    activeColor: const Color(0xFF6B46C1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Staff Activity
          const Text(
            'Staff Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          ...activities.map((activity) => _buildActivityCard(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityCard(StaffActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  activity.action,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                activity.timestamp,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${activity.staffName} · ${activity.role} · ${activity.location}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          if (activity.oldValue != null && activity.newValue != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  activity.oldValue!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey[400]),
                ),
                Text(
                  activity.newValue!,
                  style: const TextStyle(
                    color: Color(0xFF6B46C1),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
