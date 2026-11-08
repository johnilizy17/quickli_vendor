import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ReferralsController extends GetxController {
  final totalEarned = 70000.0.obs;
  final pendingEarnings = 15000.0.obs;
  final referralLink = 'quickli.io/join/janesdelights'.obs;
  final selectedTab = 0.obs; // 0 = Vendor Referrals, 1 = Customer Referrals

  final referrals = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReferrals();
  }

  void loadReferrals() {
    // Sample data - replace with API call
    referrals.value = [
      {
        'name': 'Bakery Bliss',
        'date': 'Referred on Feb 10, 2026',
        'status': 'Activated',
        'amount': 5000.0,
        'initial': 'B',
      },
      {
        'name': 'Spice Route',
        'date': 'Referred on Feb 18, 2026',
        'status': 'Pending Activation',
        'amount': 5000.0,
        'initial': 'S',
      },
      {
        'name': 'Green Grocer',
        'date': 'Referred on Jan 25, 2026',
        'status': 'Expired',
        'amount': 0.0,
        'initial': 'G',
      },
    ];
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void copyReferralLink() {
    Clipboard.setData(ClipboardData(text: referralLink.value));
    Get.snackbar(
      'Copied!',
      'Referral link copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void shareReferralLink() {
    // Show dialog with share options
    Get.dialog(
      AlertDialog(
        title: Text('Share Referral Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share your referral link:'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                referralLink.value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Copy and share via your preferred messaging app!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              copyReferralLink();
              Get.back();
            },
            child: Text('Copy & Close'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Activated':
        return Colors.green;
      case 'Pending Activation':
        return Colors.orange;
      case 'Expired':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String getStatusAmount(Map<String, dynamic> referral) {
    if (referral['status'] == 'Activated') {
      return '₦${referral['amount'].toStringAsFixed(0)}';
    } else if (referral['status'] == 'Pending Activation') {
      return '₦${referral['amount'].toStringAsFixed(0)}';
    } else {
      return 'ND';
    }
  }
}
