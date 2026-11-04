import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final businessNameController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessEmailController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final descriptionController = TextEditingController();

  // Observable fields
  final businessType = ''.obs;
  final logoPath = ''.obs;
  final openTime = '09:00 AM'.obs;
  final closeTime = '09:00 PM'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessPhoneController.dispose();
    businessEmailController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    // TODO: Load from API or local storage
  }

  Future<void> pickLogo() async {
    // TODO: Implement image picker
    Get.snackbar(
      'Info',
      'Image picker not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> selectOpenTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      openTime.value = picked.format(context);
    }
  }

  Future<void> selectCloseTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      closeTime.value = picked.format(context);
    }
  }

  Future<void> saveBusinessInfo() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (businessType.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a business type',
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
        'businessType': businessType.value,
        'businessName': businessNameController.text,
        'businessPhone': businessPhoneController.text,
        'businessEmail': businessEmailController.text,
        'address': {
          'street': streetAddressController.text,
          'city': cityController.text,
          'state': stateController.text,
          'postalCode': postalCodeController.text,
        },
        'description': descriptionController.text,
        'operatingHours': {
          'open': openTime.value,
          'close': closeTime.value,
        },
        'logo': logoPath.value,
      };

      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Close loading dialog
      Get.back(); // Go back to registration screen
      
      Get.snackbar(
        'Success',
        'Business information saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to save business information',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
