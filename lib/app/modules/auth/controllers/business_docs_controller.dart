import 'package:get/get.dart';

class BusinessDocsController extends GetxController {
  // Observable fields for required documents
  final businessRegPath = ''.obs;
  final tinPath = ''.obs;
  final foodSafetyCertPath = ''.obs;
  final businessPermitPath = ''.obs;

  // Additional documents
  final additionalDocs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    // TODO: Load from API or local storage
  }

  Future<void> uploadBusinessReg() async {
    // TODO: Implement file picker
    businessRegPath.value = 'https://example.com/business_reg.pdf'; // Mock
    Get.snackbar(
      'Success',
      'Business registration certificate uploaded',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> uploadTin() async {
    // TODO: Implement file picker
    tinPath.value = 'https://example.com/tin.pdf'; // Mock
    Get.snackbar(
      'Success',
      'TIN document uploaded',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> uploadFoodSafetyCert() async {
    // TODO: Implement file picker
    foodSafetyCertPath.value = 'https://example.com/food_cert.pdf'; // Mock
    Get.snackbar(
      'Success',
      'Food safety certificate uploaded',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> uploadBusinessPermit() async {
    // TODO: Implement file picker
    businessPermitPath.value = 'https://example.com/permit.pdf'; // Mock
    Get.snackbar(
      'Success',
      'Business permit uploaded',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> addAdditionalDoc() async {
    // TODO: Implement file picker
    final doc = {
      'name': 'Additional_Document_${additionalDocs.length + 1}.pdf',
      'path': 'https://example.com/additional_${additionalDocs.length + 1}.pdf',
    };
    additionalDocs.add(doc);
    Get.snackbar(
      'Success',
      'Additional document uploaded',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeAdditionalDoc(Map<String, dynamic> doc) {
    additionalDocs.remove(doc);
  }

  Future<void> saveDocuments() async {
    // Validate required documents
    if (businessRegPath.value.isEmpty || tinPath.value.isEmpty) {
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
        'businessRegistration': businessRegPath.value,
        'tin': tinPath.value,
        'foodSafetyCert': foodSafetyCertPath.value,
        'businessPermit': businessPermitPath.value,
        'additionalDocuments': additionalDocs.toList(),
      };

      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Close loading dialog
      Get.back(); // Go back to registration screen

      Get.snackbar(
        'Success',
        'Business documents saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to save business documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
