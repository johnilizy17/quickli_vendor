import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/file_upload_service.dart';
import '../../../services/registration_api_service.dart';

class OwnerVerificationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _fileUploadService = FileUploadService();
  final _apiService = RegistrationApiService();

  // Controllers
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final idNumberController = TextEditingController();

  // Observable fields
  final idType = ''.obs;
  final idFrontPath = ''.obs;
  final idBackPath = ''.obs;
  final selfiePath = ''.obs;
  final idFrontFile = Rxn<File>();
  final idBackFile = Rxn<File>();
  final selfieFile = Rxn<File>();
  final isUploading = false.obs;
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
    final file = await _fileUploadService.pickImageWithOptions(crop: false);
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        idFrontFile.value = file;
        idFrontPath.value = file.path;
        Get.snackbar(
          'Success',
          'ID front selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> uploadIdBack() async {
    final file = await _fileUploadService.pickImageWithOptions(crop: false);
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        idBackFile.value = file;
        idBackPath.value = file.path;
        Get.snackbar(
          'Success',
          'ID back selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> uploadSelfie() async {
    final file = await _fileUploadService.pickImageWithOptions(crop: false);
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        selfieFile.value = file;
        selfiePath.value = file.path;
        Get.snackbar(
          'Success',
          'Selfie selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
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

    if (idFrontFile.value == null ||
        idBackFile.value == null ||
        selfieFile.value == null) {
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

      isUploading.value = true;

      // Upload documents
      final idFrontUrl = await _apiService.uploadFile(
        idFrontFile.value!,
        folder: 'verification/id_front',
      );
      final idBackUrl = await _apiService.uploadFile(
        idBackFile.value!,
        folder: 'verification/id_back',
      );
      final selfieUrl = await _apiService.uploadFile(
        selfieFile.value!,
        folder: 'verification/selfie',
      );

      isUploading.value = false;

      if (idFrontUrl == null || idBackUrl == null || selfieUrl == null) {
        throw Exception('Failed to upload documents');
      }

      // Prepare data
      final data = {
        'fullName': fullNameController.text,
        'dateOfBirth': selectedDob?.toIso8601String(),
        'idType': idType.value,
        'idNumber': idNumberController.text,
        'documents': {
          'idFront': idFrontUrl,
          'idBack': idBackUrl,
          'selfie': selfieUrl,
        },
      };

      // Save to API
      final response = await _apiService.saveOwnerVerification(data);

      Get.back(); // Close loading dialog

      if (response != null) {
        Get.back(); // Go back to registration screen
        Get.snackbar(
          'Success',
          'Verification documents submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit verification documents',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isUploading.value = false;
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to submit verification documents: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
