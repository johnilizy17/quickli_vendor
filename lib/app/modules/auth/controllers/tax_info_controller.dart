import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final tinController = TextEditingController();
  final vatNumberController = TextEditingController();
  final businessRegNumberController = TextEditingController();
  final taxOfficeController = TextEditingController();

  // Observable fields
  final isVatRegistered = false.obs;
  final taxCertificatePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  @override
  void onClose() {
    tinController.dispose();
    vatNumberController.dispose();
    businessRegNumberController.dispose();
    taxOfficeController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    // TODO: Load from API or local storage
  }

  Future<void> uploadTaxCertificate() async {
    // TODO: Implement file picker
    taxCertificatePath.value = 'https://example.com/tax_cert.pdf'; // Mock
    Get.snackbar(
      'Success',
      'Tax certificate uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> saveTaxInfo() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // TODO: Save to API
      final data = {
        'tin': tinController.text,
        'vatNumber': vatNumberController.text,
        'businessRegNumber': businessRegNumberController.text,
        'taxOffice': taxOfficeController.text,
        'isVatRegistered': isVatRegistered.value,
        'taxCertificate': taxCertificatePath.value,
      };

      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Close loading dialog
      Get.back(); // Go back to registration screen

      Get.snackbar(
        'Success',
        'Tax information saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to save tax information',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
