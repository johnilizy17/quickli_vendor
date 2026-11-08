import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_settings_controller.dart';

class NotificationSettingsView extends GetView<NotificationSettingsController> {
  const NotificationSettingsView({Key? key}) : super(key: key);

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
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'CHANNELS',
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
                        'Push notifications',
                        controller.pushNotifications.value,
                        controller.togglePushNotifications,
                      )),
                      Divider(height: 1, color: Colors.grey[200]),
                      Obx(() => _buildSwitchTile(
                        'Email',
                        controller.email.value,
                        controller.toggleEmail,
                      )),
                      Divider(height: 1, color: Colors.grey[200]),
                      Obx(() => _buildSwitchTile(
                        'SMS',
                        controller.sms.value,
                        controller.toggleSms,
                        isLast: true,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                const Text(
                  'CATEGORIES',
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
                        'New orders',
                        controller.newOrders.value,
                        controller.toggleNewOrders,
                      )),
                      Divider(height: 1, color: Colors.grey[200]),
                      Obx(() => _buildSwitchTile(
                        'Low stock & inventory',
                        controller.lowStockInventory.value,
                        controller.toggleLowStockInventory,
                      )),
                      Divider(height: 1, color: Colors.grey[200]),
                      Obx(() => _buildSwitchTile(
                        'Payouts',
                        controller.payouts.value,
                        controller.togglePayouts,
                      )),
                      Divider(height: 1, color: Colors.grey[200]),
                      Obx(() => _buildSwitchTile(
                        'Disputes & support',
                        controller.disputesSupport.value,
                        controller.toggleDisputesSupport,
                      )),
                      Divider(height: 1, color: Colors.grey[200]),
                      Obx(() => _buildSwitchTile(
                        'Promotions',
                        controller.promotions.value,
                        controller.togglePromotions,
                        isLast: true,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Save Changes Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B46C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
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
        top: 16,
        bottom: isLast ? 16 : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF6B46C1),
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
