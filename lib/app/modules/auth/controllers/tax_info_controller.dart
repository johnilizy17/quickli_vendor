import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/registration_api_service.dart';

class TaxInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _apiService = RegistrationApiService();

  // Store businessId
  final businessId = ''.obs;

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
    // Get vendor business
    try {
      final business = await _apiService.getVendorBusiness();
      if (business != null && business['_id'] != null) {
        businessId.value = business['_id'];
        
        // Pre-fill if documents exist
        final documents = business['documents'];
        if (documents != null) {
          tinController.text = documents['tin'] ?? '';
        }
      }
    } catch (e) {
      print('Error loading business: $e');
    }
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

      // Update business with tax info using setupKycDetails
      final data = {
        'businessId': businessId.value,
        'documents': {
          'tin': tinController.text,
        },
      };

      final response = await _apiService.setupKycDetails(data);

      Get.back(); // Close loading dialog

      if (response != null) {
        // Mark step as complete
        await _apiService.updateVerificationStep({
          'businessId': businessId.value,
          'step': 'tax-info',
        });

        Get.back(); // Go back to registration screen

        Get.snackbar(
          'Success',
          'Tax information saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save tax information',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to save tax information: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
