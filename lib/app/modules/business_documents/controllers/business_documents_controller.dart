import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/file_upload_service.dart';
import '../../../services/registration_api_service.dart';
import '../../auth/controllers/business_info_controller.dart';

class BusinessDocumentsController extends GetxController {
  final _fileUploadService = FileUploadService();
  final _apiService = RegistrationApiService();

  // Store businessId
  final businessId = ''.obs;

  // Controllers
  final cacNumberController = TextEditingController();
  final tinController = TextEditingController();

  // Observable fields for document uploads
  final cacCertificatePath = ''.obs;
  final tinCertificatePath = ''.obs;
  final cacCertificateFile = Rxn<File>();
  final tinCertificateFile = Rxn<File>();
  final isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
  }

  @override
  void onClose() {
    cacNumberController.dispose();
    tinController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    // Try to get businessId from BusinessInfoController first
    try {
      final businessInfoController = Get.find<BusinessInfoController>();
      if (businessInfoController.businessId.value.isNotEmpty) {
        businessId.value = businessInfoController.businessId.value;
        print('[BUSINESS DOCUMENTS] Loaded businessId from BusinessInfoController: ${businessId.value}');
      }
    } catch (e) {
      print('[BUSINESS DOCUMENTS] BusinessInfoController not found, trying API...');
    }

    // Get vendor business from API to load all data
    try {
      final response = await _apiService.getVendorBusiness();
      print('[BUSINESS DOCUMENTS] API Response: $response');
      
      if (response != null) {
        // Handle both response formats: { data: { _id: ... } } or { _id: ... }
        final business = response['data'] ?? response;
        
        // Load businessId if not already loaded
        if (businessId.value.isEmpty) {
          if (business['_id'] != null) {
            businessId.value = business['_id'];
            print('[BUSINESS DOCUMENTS] Loaded businessId from API: ${businessId.value}');
          } else if (business['id'] != null) {
            businessId.value = business['id'];
            print('[BUSINESS DOCUMENTS] Loaded businessId from API (id field): ${businessId.value}');
          }
        }
        
        // Load saved business documents data if it exists
        if (business['documents'] != null) {
          final documents = business['documents'];
          print('[BUSINESS DOCUMENTS] Loading saved documents data...');
          
          // Load CAC Number (RC/BN)
          if (documents['cacNumber'] != null && documents['cacNumber'].toString().isNotEmpty) {
            cacNumberController.text = documents['cacNumber'];
            print('[BUSINESS DOCUMENTS] ✅ CAC Number: ${documents['cacNumber']}');
          }
          
          // Load TIN
          if (documents['tin'] != null && documents['tin'].toString().isNotEmpty) {
            tinController.text = documents['tin'];
            print('[BUSINESS DOCUMENTS] ✅ TIN: ${documents['tin']}');
          }
          
          // Load CAC Certificate URL if exists
          if (documents['cacCertificateUrl'] != null && documents['cacCertificateUrl'].toString().isNotEmpty) {
            cacCertificatePath.value = documents['cacCertificateUrl'];
            print('[BUSINESS DOCUMENTS] ✅ CAC Certificate URL: ${documents['cacCertificateUrl']}');
          }
          
          // Load TIN Certificate URL if exists
          if (documents['tinCertificateUrl'] != null && documents['tinCertificateUrl'].toString().isNotEmpty) {
            tinCertificatePath.value = documents['tinCertificateUrl'];
            print('[BUSINESS DOCUMENTS] ✅ TIN Certificate URL: ${documents['tinCertificateUrl']}');
          }
        } else {
          print('[BUSINESS DOCUMENTS] ⚠️ No documents object in business data');
        }
        
      } else {
        print('[BUSINESS DOCUMENTS] ⚠️ API returned null response');
      }
    } catch (e) {
      print('[BUSINESS DOCUMENTS] ❌ Error loading saved data: $e');
    }
  }

  Future<void> uploadCacCertificate() async {
    final file = await _fileUploadService.pickImageWithOptions(crop: false);
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 15)) {
        cacCertificateFile.value = file;
        cacCertificatePath.value = file.path;
        Get.snackbar(
          'Success',
          'CAC Certificate selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> uploadTinCertificate() async {
    final file = await _fileUploadService.pickImageWithOptions(crop: false);
    if (file != null) {
      if (_fileUploadService.validateFileSize(file, maxSizeMB: 15)) {
        tinCertificateFile.value = file;
        tinCertificatePath.value = file.path;
        Get.snackbar(
          'Success',
          'TIN Certificate selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> submitBusinessDocuments() async {
    print('[BUSINESS DOCUMENTS] ========== SUBMIT STARTED ==========');
    try {
      isUploading.value = true;

      // Ensure businessId is loaded
      if (businessId.value.isEmpty) {
        print('[BUSINESS DOCUMENTS] Business ID empty, loading...');
        await loadSavedData();
        
        if (businessId.value.isEmpty) {
          throw Exception('Business ID not found. Please complete business information first.');
        }
      }
      
      print('[BUSINESS DOCUMENTS] Using businessId: ${businessId.value}');

      // Validate inputs - At least TIN or RC/BN Number must be provided
      final hasCacNumber = cacNumberController.text.trim().isNotEmpty;
      final hasTin = tinController.text.trim().isNotEmpty;
      
      print('[BUSINESS DOCUMENTS] Has CAC Number: $hasCacNumber');
      print('[BUSINESS DOCUMENTS] Has TIN: $hasTin');
      
      if (!hasCacNumber && !hasTin) {
        isUploading.value = false;
        Get.snackbar(
          'Validation Error',
          'Please provide at least TIN or RC/BN Number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // If RC/BN Number is provided, CAC Certificate is required (either new file or existing URL)
      if (hasCacNumber && cacCertificateFile.value == null && cacCertificatePath.value.isEmpty) {
        isUploading.value = false;
        Get.snackbar(
          'Validation Error',
          'CAC Certificate document is required when RC/BN Number is provided',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      print('[BUSINESS DOCUMENTS] Validation passed ✅');

      // Upload CAC Certificate if provided
      String? cacUrl;
      if (cacCertificateFile.value != null) {
        print('[BUSINESS DOCUMENTS] Uploading CAC Certificate...');
        cacUrl = await _apiService.uploadFile(
          cacCertificateFile.value!,
          folder: 'documents/cac_certificate',
        );
        
        if (cacUrl == null) {
          throw Exception('Failed to upload CAC Certificate');
        }
        print('[BUSINESS DOCUMENTS] ✅ CAC Certificate uploaded: $cacUrl');
      }

      // Upload TIN Certificate if provided
      String? tinUrl;
      if (tinCertificateFile.value != null) {
        print('[BUSINESS DOCUMENTS] Uploading TIN Certificate...');
        tinUrl = await _apiService.uploadFile(
          tinCertificateFile.value!,
          folder: 'documents/tin_certificate',
        );
        
        if (tinUrl != null) {
          print('[BUSINESS DOCUMENTS] ✅ TIN Certificate uploaded: $tinUrl');
        }
      }

      print('[BUSINESS DOCUMENTS] ✅ All file uploads completed');

      // Prepare data for KYC details
      final documentsData = <String, dynamic>{};
      
      // Add CAC Certificate and number if provided
      if (cacNumberController.text.trim().isNotEmpty) {
        documentsData['cacNumber'] = cacNumberController.text.trim();
        
        // Add CAC Certificate URL (either newly uploaded or existing)
        if (cacUrl != null) {
          documentsData['cacCertificateUrl'] = cacUrl;
        } else if (cacCertificatePath.value.isNotEmpty) {
          // Use existing URL if no new upload
          documentsData['cacCertificateUrl'] = cacCertificatePath.value;
        }
      }
      
      // Add TIN and certificate if provided
      if (tinController.text.trim().isNotEmpty) {
        documentsData['tin'] = tinController.text.trim();
      }
      if (tinUrl != null) {
        documentsData['tinCertificateUrl'] = tinUrl;
      } else if (tinCertificatePath.value.isNotEmpty) {
        // Use existing URL if no new upload
        documentsData['tinCertificateUrl'] = tinCertificatePath.value;
      }

      final data = {
        'businessId': businessId.value,
        'documents': documentsData,
      };

      print('[BUSINESS DOCUMENTS] Submitting data to API: ${data.toString()}');
      
      // Try approach 1: setupKycDetails endpoint
      print('[BUSINESS DOCUMENTS] 📤 Attempt 1: /business/onboarding/setup-kyc-details');
      var response = await _apiService.setupKycDetails(data);
      print('[BUSINESS DOCUMENTS] Response 1: $response');

      // If null or failed, try approach 2: business-documents endpoint
      if (response == null || (response['data'] == null && response['success'] != true)) {
        print('[BUSINESS DOCUMENTS] 📤 Attempt 2: /vendors/business-documents');
        
        final altData = {
          'businessId': businessId.value,
          'tin': documentsData['tin'],
          'cacNumber': documentsData['cacNumber'],
          'cacCertificateUrl': documentsData['cacCertificateUrl'],
          'tinCertificateUrl': documentsData['tinCertificateUrl'],
        };
        
        response = await _apiService.saveBusinessDocuments(altData);
        print('[BUSINESS DOCUMENTS] Response 2: $response');
      }

      // If still null, try approach 3: direct PATCH to business
      if (response == null || (response['data'] == null && response['success'] != true)) {
        print('[BUSINESS DOCUMENTS] 📤 Attempt 3: PATCH /business/{businessId}');
        
        response = await _apiService.updateBusinessDocuments(
          businessId.value,
          documentsData,
        );
        print('[BUSINESS DOCUMENTS] Response 3: $response');
      }

      if (response != null) {
        print('[BUSINESS DOCUMENTS] ✅ API submission successful');
        
        // Mark step as complete
        try {
          print('[BUSINESS DOCUMENTS] Marking verification step as complete...');
          await _apiService.updateVerificationStep({
            'businessId': businessId.value,
            'step': 'kyc-upload',
          });
          print('[BUSINESS DOCUMENTS] ✅ Verification step marked complete');
        } catch (stepError) {
          print('[BUSINESS DOCUMENTS] ⚠️ Failed to mark step complete (continuing anyway): $stepError');
        }
        
        isUploading.value = false;
        print('[BUSINESS DOCUMENTS] Set isUploading to false');
        
        print('[BUSINESS DOCUMENTS] About to navigate back...');
        print('[BUSINESS DOCUMENTS] Current route: ${Get.currentRoute}');
        
        // Navigate back immediately
        Get.back();
        
        // Show success message AFTER navigation
        Get.snackbar(
          'Success',
          'Business documents submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        
        print('[BUSINESS DOCUMENTS] ✅ Navigation completed');
        print('[BUSINESS DOCUMENTS] ========== SUBMIT COMPLETED ==========');
        
      } else {
        isUploading.value = false;
        print('[BUSINESS DOCUMENTS] ❌ API returned null response');
        throw Exception('API returned null response');
      }
    } catch (e, stackTrace) {
      isUploading.value = false;
      print('[BUSINESS DOCUMENTS] ========== SUBMIT FAILED ==========');
      print('[BUSINESS DOCUMENTS] ❌ Error: $e');
      print('[BUSINESS DOCUMENTS] Stack trace: $stackTrace');
      
      Get.snackbar(
        'Error',
        'Failed to submit business documents: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }
}
