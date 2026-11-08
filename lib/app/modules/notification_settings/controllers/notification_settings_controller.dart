import 'package:get/get.dart';

class NotificationSettingsController extends GetxController {
  // Channels
  final pushNotifications = true.obs;
  final email = true.obs;
  final sms = false.obs;

  // Categories
  final newOrders = true.obs;
  final lowStockInventory = true.obs;
  final payouts = true.obs;
  final disputesSupport = true.obs;
  final promotions = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotificationSettings();
  }

  void loadNotificationSettings() {
    // TODO: Load settings from API or local storage
    // For now, using default values
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void toggleEmail(bool value) {
    email.value = value;
  }

  void toggleSms(bool value) {
    sms.value = value;
  }

  void toggleNewOrders(bool value) {
    newOrders.value = value;
  }

  void toggleLowStockInventory(bool value) {
    lowStockInventory.value = value;
  }

  void togglePayouts(bool value) {
    payouts.value = value;
  }

  void toggleDisputesSupport(bool value) {
    disputesSupport.value = value;
  }

  void togglePromotions(bool value) {
    promotions.value = value;
  }

  void saveChanges() {
    // TODO: Save settings to API
    Get.snackbar(
      'Success',
      'Notification settings updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool get hasChanges {
    // TODO: Compare with original values to detect changes
    return true;
  }
}
