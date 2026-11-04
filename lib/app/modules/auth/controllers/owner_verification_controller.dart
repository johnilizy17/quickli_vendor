import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OwnerVerificationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final idNumberController = TextEditingController();

  // Observable fields
  final idType = ''.obs;
  final idFrontPath = ''.obs;
  final idBackPath = ''.obs;
  final selfiePath = ''.obs;
  DateTime? selectedDob;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    dobController.dispose();
    idNumberController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    // TODO: Load from API or local storage
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (picked != null) {
      selectedDob = picked;
      dobController.text = DateFormat('dd MMM yyyy').format(picked);
    }
  }

  Future<void> uploadIdFront() async {
    // TODO: Implement image picker
    idFrontPath.value = 'https://example.com/id_front.jpg'; // Mock
    Get.snackbar(
      'Success',
      'ID front uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> uploadIdBack() async {
    // TODO: Implement image picker
    idBackPath.value = 'https://example.com/id_back.jpg'; // Mock
    Get.snackbar(
      'Success',
      'ID back uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> uploadSelfie() async {
    // TODO: Implement camera or image picker
    selfiePath.value = 'https://example.com/selfie.jpg'; // Mock
    Get.snackbar(
      'Success',
      'Selfie uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> saveVerification() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (idType.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an ID type',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (idFrontPath.value.isEmpty ||
        idBackPath.value.isEmpty ||
        selfiePath.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please upload all required documents',
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
        'fullName': fullNameController.text,
        'dateOfBirth': selectedDob?.toIso8601String(),
        'idType': idType.value,
        'idNumber': idNumberController.text,
        'documents': {
          'idFront': idFrontPath.value,
          'idBack': idBackPath.value,
          'selfie': selfiePath.value,
        },
      };

      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Close loading dialog
      Get.back(); // Go back to registration screen

      Get.snackbar(
        'Success',
        'Verification documents submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to submit verification documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
