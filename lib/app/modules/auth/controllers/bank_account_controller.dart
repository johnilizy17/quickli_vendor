import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankAccountController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final accountNumberController = TextEditingController();
  final bvnController = TextEditingController();

  // Observable fields
  final selectedBank = ''.obs;
  final accountName = ''.obs;
  final accountType = 'savings'.obs;
  final isVerifying = false.obs;

  // Nigerian banks list
  final List<String> banks = [
    'Access Bank',
    'Citibank',
    'Ecobank Nigeria',
    'Fidelity Bank',
    'First Bank of Nigeria',
    'First City Monument Bank',
    'Guaranty Trust Bank',
    'Heritage Bank',
    'Keystone Bank',
    'Polaris Bank',
    'Providus Bank',
    'Stanbic IBTC Bank',
    'Standard Chartered Bank',
    'Sterling Bank',
    'Union Bank of Nigeria',
    'United Bank for Africa',
    'Unity Bank',
    'Wema Bank',
    'Zenith Bank',
  ];

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  @override
  void onClose() {
    accountNumberController.dispose();
    bvnController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    // TODO: Load from API or local storage
  }

  Future<void> verifyAccountNumber(String value) async {
    if (value.length == 10 && selectedBank.value.isNotEmpty) {
      isVerifying.value = true;
      accountName.value = '';

      try {
        // TODO: Call bank verification API
        await Future.delayed(const Duration(seconds: 2));
        
        // Mock response
        accountName.value = 'JOHN DOE ENTERPRISES LTD';
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to verify account number',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isVerifying.value = false;
      }
    } else {
      accountName.value = '';
    }
  }

  Future<void> saveBankAccount() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedBank.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a bank',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (accountName.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please wait for account verification',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // TODO: Save to API
      final data = {
        'bankName': selectedBank.value,
        'accountNumber': accountNumberController.text,
        'accountName': accountName.value,
        'accountType': accountType.value,
        'bvn': bvnController.text,
      };

      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Close loading dialog
      Get.back(); // Go back to registration screen

      Get.snackbar(
        'Success',
        'Bank account saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to save bank account',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
