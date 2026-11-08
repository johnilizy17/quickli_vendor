import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class VendorMenuController extends GetxController {
  
  void referVendor() {
    Get.toNamed(Routes.REFERRALS);
  }

  void goToBusinessProfile() {
    Get.toNamed('/business-profile');
  }

  void goToOperatingHours() {
    Get.toNamed('/business-profile/operating-hours');
  }

  void goToDeliveryPickup() {
    Get.toNamed('/business-profile/delivery-pickup');
  }

  void goToInventory() {
    // TODO: Navigate to inventory page
    Get.snackbar('Info', 'Inventory - Coming soon');
  }

  void goToSalesDashboard() {
    Get.toNamed(Routes.SALES_DASHBOARD);
  }

  void goToPromotions() {
    // TODO: Navigate to promotions page
    Get.snackbar('Info', 'Promotions - Coming soon');
  }

  void goToBranchSettings() {
    // TODO: Navigate to branch settings
    Get.snackbar('Info', 'Branch Settings - Coming soon');
  }

  void goToReports() {
    Get.toNamed(Routes.REPORTS_DASHBOARD);
  }

  void goToStaffRoles() {
    Get.toNamed(Routes.STAFF_DASHBOARD);
  }

  void goToReferrals() {
    Get.toNamed(Routes.REFERRALS);
  }

  void goToBadgeDetails() {
    // TODO: Navigate to badge details
    Get.snackbar('Info', 'Badge Details - Coming soon');
  }

  void goToRatingsReviews() {
    Get.toNamed(Routes.RATINGS_REVIEWS);
  }

  void goToNotifications() {
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  void goToSupport() {
    Get.toNamed(Routes.HELP_SUPPORT);
  }

  void goToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('Log out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Clear auth token and user data
              Get.back(); // Close dialog
              Get.offAllNamed(Routes.LOGIN);
            },
            child: Text(
              'Log out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
