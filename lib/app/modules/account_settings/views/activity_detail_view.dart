import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_settings_controller.dart';

class ActivityDetailView extends GetView<AccountSettingsController> {
  const ActivityDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activityId = Get.arguments as String;
    final detail = controller.getActivityDetail(activityId);

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
          'Activity Detail',
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.action,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (detail.oldValue != null && detail.newValue != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        detail.oldValue!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.arrow_forward, color: Colors.grey[400]),
                      ),
                      Text(
                        detail.newValue!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B46C1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                _buildDetailRow('User', detail.user),
                const SizedBox(height: 16),
                _buildDetailRow('Role', detail.role),
                const SizedBox(height: 16),
                _buildDetailRow('Branch', detail.branch),
                const SizedBox(height: 16),
                _buildDetailRow('Timestamp', detail.timestamp),
                const SizedBox(height: 16),
                _buildDetailRow('Action', detail.actionType),
                if (detail.oldValue != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow('Old value', detail.oldValue!),
                ],
                if (detail.newValue != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow('New value', detail.newValue!),
                ],
                const SizedBox(height: 16),
                _buildDetailRow('Source / device', detail.sourceDevice),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
