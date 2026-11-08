import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/staff_controller.dart';

class ApprovalWorkflowSettingsView extends GetView<StaffController> {
  const ApprovalWorkflowSettingsView({Key? key}) : super(key: key);

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
          'Approval Workflow Settings',
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
          const Text(
            'ACTIONS REQUIRING APPROVAL',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Obx(() => _buildSwitchTile(
                  'Product price changes',
                  controller.priceChangesRequireApproval.value,
                  (value) => controller.priceChangesRequireApproval.value = value,
                )),
                Divider(height: 1, color: Colors.grey[200]),
                Obx(() => _buildSwitchTile(
                  'Bulk product edits',
                  controller.bulkEditsRequireApproval.value,
                  (value) => controller.bulkEditsRequireApproval.value = value,
                )),
                Divider(height: 1, color: Colors.grey[200]),
                Obx(() => _buildSwitchTile(
                  'Staff role changes',
                  controller.roleChangesRequireApproval.value,
                  (value) => controller.roleChangesRequireApproval.value = value,
                )),
                Divider(height: 1, color: Colors.grey[200]),
                Obx(() => _buildSwitchTile(
                  'Promotion creation',
                  controller.promotionCreationRequireApproval.value,
                  (value) => controller.promotionCreationRequireApproval.value = value,
                )),
                Divider(height: 1, color: Colors.grey[200]),
                Obx(() => _buildSwitchTile(
                  'Order cancellations > ₦5,000',
                  controller.largeOrderCancellationsRequireApproval.value,
                  (value) => controller.largeOrderCancellationsRequireApproval.value = value,
                )),
                Divider(height: 1, color: Colors.grey[200]),
                Obx(() => _buildSwitchTile(
                  'Inventory adjustments',
                  controller.inventoryAdjustmentsRequireApproval.value,
                  (value) => controller.inventoryAdjustmentsRequireApproval.value = value,
                  isLast: true,
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'APPROVERS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              final approver = controller.selectedApprover.value;
              if (approver == null) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No approver selected'),
                );
              }
              
              return ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF6B46C1),
                  radius: 24,
                  child: Text(
                    approver.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(
                  approver.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  approver.role,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                trailing: TextButton(
                  onPressed: controller.changeApprover,
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      color: Color(0xFF6B46C1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'NOTIFICATIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Obx(() => _buildSwitchTile(
                  'Notify approver via push',
                  controller.notifyApproverViaPush.value,
                  (value) => controller.notifyApproverViaPush.value = value,
                )),
                Divider(height: 1, color: Colors.grey[200]),
                Obx(() => _buildSwitchTile(
                  'Notify requester on decision',
                  controller.notifyRequesterOnDecision.value,
                  (value) => controller.notifyRequesterOnDecision.value = value,
                  isLast: true,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    Function(bool) onChanged, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: isLast ? 12 : 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6B46C1),
          ),
        ],
      ),
    );
  }
}
