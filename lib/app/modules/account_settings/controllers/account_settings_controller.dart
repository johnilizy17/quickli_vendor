import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityLogItem {
  final String id;
  final String action;
  final String user;
  final String role;
  final String branch;
  final String timestamp;
  final String? oldValue;
  final String? newValue;
  final String category; // 'staff', 'orders', 'products', 'inventory', 'pc'

  ActivityLogItem({
    required this.id,
    required this.action,
    required this.user,
    required this.role,
    required this.branch,
    required this.timestamp,
    this.oldValue,
    this.newValue,
    required this.category,
  });
}

class ActivityDetail {
  final String action;
  final String? oldValue;
  final String? newValue;
  final String user;
  final String role;
  final String branch;
  final String timestamp;
  final String actionType;
  final String sourceDevice;

  ActivityDetail({
    required this.action,
    this.oldValue,
    this.newValue,
    required this.user,
    required this.role,
    required this.branch,
    required this.timestamp,
    required this.actionType,
    required this.sourceDevice,
  });
}

class AccountSettingsController extends GetxController {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isLoading = false.obs;
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final verificationCode = List<String>.filled(4, '').obs;
  final selectedActivityFilter = 'All'.obs;

  // Password strength
  final passwordStrength = 0.0.obs; // 0.0 to 1.0
  final has8Characters = false.obs;
  final hasUpperLowerCase = false.obs;
  final hasNumber = false.obs;

  // Sample activity log data
  final activityLog = <ActivityLogItem>[
    ActivityLogItem(
      id: '1',
      action: 'Changed product price',
      user: 'Tunde Adeyemi',
      role: 'Manager',
      branch: 'Victoria Island',
      timestamp: 'Now',
      oldValue: '₦2,500',
      newValue: '₦2,800',
      category: 'products',
    ),
    ActivityLogItem(
      id: '2',
      action: 'Accepted order #QL-7841',
      user: 'Chioma Eze',
      role: 'Cashier',
      branch: 'Harbour Town',
      timestamp: '8 min ago',
      category: 'orders',
    ),
    ActivityLogItem(
      id: '3',
      action: 'Updated payout account',
      user: 'Lena Okonkwo',
      role: 'Owner',
      branch: 'All branches',
      timestamp: '32 min ago',
      oldValue: '****1180',
      newValue: '****4821',
      category: 'pc',
    ),
    ActivityLogItem(
      id: '4',
      action: 'Auto-paused Jollof Rice',
      user: 'System',
      role: 'Automation',
      branch: 'Harbour Town',
      timestamp: '1 hr ago',
      oldValue: '12 units',
      newValue: '0 units',
      category: 'inventory',
    ),
    ActivityLogItem(
      id: '5',
      action: 'Marked order ready #QL-7838',
      user: 'Bola Adebisi',
      role: 'Cashier',
      branch: 'Harbour Town',
      timestamp: '2 hrs ago',
      category: 'orders',
    ),
    ActivityLogItem(
      id: '6',
      action: 'Order accepted',
      user: 'Chioma Eze',
      role: 'Cashier',
      branch: 'Harbour Town',
      timestamp: '15:10',
      oldValue: 'Incoming',
      newValue: 'Preparing',
      category: 'orders',
    ),
    ActivityLogItem(
      id: '7',
      action: 'Assigned rider',
      user: 'System',
      role: 'Automation',
      branch: 'Harbour Town',
      timestamp: '15:34',
      category: 'orders',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(checkPasswordStrength);
  }

  @override
  void onClose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void checkPasswordStrength() {
    final password = newPasswordController.text;
    
    // Check individual requirements
    has8Characters.value = password.length >= 8;
    hasUpperLowerCase.value = password.contains(RegExp(r'[a-z]')) && 
                              password.contains(RegExp(r'[A-Z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));
    
    // Calculate overall strength
    int strength = 0;
    if (has8Characters.value) strength++;
    if (hasUpperLowerCase.value) strength++;
    if (hasNumber.value) strength++;
    
    passwordStrength.value = strength / 3;
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  void sendResetLink() {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email or phone number');
      return;
    }
    
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.toNamed('/change-password/verify');
    });
  }

  void verifyCode() {
    final code = verificationCode.join();
    if (code.length != 4) {
      Get.snackbar('Error', 'Please enter the 4-digit code');
      return;
    }
    
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.toNamed('/change-password/create');
    });
  }

  void resendCode() {
    Get.snackbar('Success', 'Verification code sent');
  }

  void updatePassword() {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }
    
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    
    if (passwordStrength.value < 1.0) {
      Get.snackbar('Error', 'Password does not meet all requirements');
      return;
    }
    
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.toNamed('/change-password/success');
    });
  }

  void changeActivityFilter(String filter) {
    selectedActivityFilter.value = filter;
  }

  List<ActivityLogItem> get filteredActivityLog {
    if (selectedActivityFilter.value == 'All') {
      return activityLog;
    }
    return activityLog.where((item) {
      switch (selectedActivityFilter.value) {
        case 'Staff':
          return item.category == 'staff';
        case 'Orders':
          return item.category == 'orders';
        case 'Products':
          return item.category == 'products';
        case 'Inventory':
          return item.category == 'inventory';
        case 'PC':
          return item.category == 'pc';
        default:
          return true;
      }
    }).toList();
  }

  ActivityDetail getActivityDetail(String activityId) {
    final activity = activityLog.firstWhere((item) => item.id == activityId);
    return ActivityDetail(
      action: activity.action,
      oldValue: activity.oldValue,
      newValue: activity.newValue,
      user: activity.user,
      role: activity.role,
      branch: activity.branch,
      timestamp: '3 Sep 2026 · 15:42:08',
      actionType: 'product.price.update',
      sourceDevice: 'iPhone 15 · Quickli iOS 3.2.1 · Lagos',
    );
  }

  void deleteAccount() {
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
              // TODO: Implement account deletion
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
  }
}
