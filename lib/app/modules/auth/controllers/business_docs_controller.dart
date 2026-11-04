import 'dart:io';
import 'package:get/get.dart';
import '../../../services/file_upload_service.dart';
import '../../../services/registration_api_service.dart';

class BusinessDocsController extends GetxController {
  final _fileUploadService = FileUploadService();
  final _apiService = RegistrationApiService();

  // Observable fields for required documents
  final businessRegPath = ''.obs;
  final tinPath = ''.obs;
  final foodSafetyCertPath = ''.obs;
  final businessPermitPath = ''.obs;

  // File objects
  final businessRegFile = Rxn<File>();
  final tinFile = Rxn<File>();
  final foodSafetyCertFile = Rxn<File>();
  final businessPermitFile = Rxn<File>();

  // Additional documents
  final additionalDocs = <Map<String, dynamic>>[].obs;
  final isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    // TODO: Load from API or local storage
  }

  Future<void> uploadBusinessReg() async {
    final file = await _fileUploadService.pickDocument();
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        businessRegFile.value = file;
        businessRegPath.value = file.path;
        Get.snackbar(
          'Success',
          'Business registration document selected',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> uploadTin() async {
    final file = await _fileUploadService.pickDocument();
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        tinFile.value = file;
        tinPath.value = file.path;
        Get.snackbar(
          'Success',
          'TIN document selected',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> uploadFoodSafetyCert() async {
    final file = await _fileUploadService.pickDocument();
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        foodSafetyCertFile.value = file;
        foodSafetyCertPath.value = file.path;
        Get.snackbar(
          'Success',
          'Food safety certificate selected',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> uploadBusinessPermit() async {
    final file = await _fileUploadService.pickDocument();
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        businessPermitFile.value = file;
        businessPermitPath.value = file.path;
        Get.snackbar(
          'Success',
          'Business permit selected',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> addAdditionalDoc() async {
    final file = await _fileUploadService.pickDocument();
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 10)) {
        final fileName = file.path.split('/').last;
        final doc = {
          'name': fileName,
          'file': file,
          'path': file.path,
        };
        additionalDocs.add(doc);
        Get.snackbar(
          'Success',
          'Additional document added',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void removeAdditionalDoc(Map<String, dynamic> doc) {
    additionalDocs.remove(doc);
  }

  Future<void> saveDocuments() async {
    // Validate required documents
    if (businessRegFile.value == null || tinFile.value == null) {
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

      // Upload required documents
      final businessRegUrl = await _apiService.uploadFile(
        businessRegFile.value!,
        folder: 'documents/business_reg',
      );
      final tinUrl = await _apiService.uploadFile(
        tinFile.value!,
        folder: 'documents/tin',
      );

      // Upload optional documents
      String? foodSafetyCertUrl;
      if (foodSafetyCertFile.value != null) {
        foodSafetyCertUrl = await _apiService.uploadFile(
          foodSafetyCertFile.value!,
          folder: 'documents/food_safety',
        );
      }

      String? businessPermitUrl;
      if (businessPermitFile.value != null) {
        businessPermitUrl = await _apiService.uploadFile(
          businessPermitFile.value!,
          folder: 'documents/permits',
        );
      }

      // Upload additional documents
      final additionalUrls = <String>[];
      for (var doc in additionalDocs) {
        final file = doc['file'] as File;
        final url = await _apiService.uploadFile(
          file,
          folder: 'documents/additional',
        );
        if (url != null) {
          additionalUrls.add(url);
        }
      }

      isUploading.value = false;

      if (businessRegUrl == null || tinUrl == null) {
        throw Exception('Failed to upload required documents');
      }

      // Prepare data
      final data = {
        'businessRegistration': businessRegUrl,
        'tin': tinUrl,
        if (foodSafetyCertUrl != null) 'foodSafetyCert': foodSafetyCertUrl,
        if (businessPermitUrl != null) 'businessPermit': businessPermitUrl,
        'additionalDocuments': additionalUrls,
      };

      // Save to API
      final response = await _apiService.saveBusinessDocuments(data);

      Get.back(); // Close loading dialog

      if (response != null) {
        Get.back(); // Go back to registration screen
        Get.snackbar(
          'Success',
          'Business documents saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save business documents',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isUploading.value = false;
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to save business documents: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
