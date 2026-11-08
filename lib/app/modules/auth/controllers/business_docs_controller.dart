import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/file_upload_service.dart';
import '../../../services/registration_api_service.dart';
import '../../../routes/app_pages.dart';

class BusinessDocsController extends GetxController {
  final _fileUploadService = FileUploadService();
  final _apiService = RegistrationApiService();

  // Store businessId
  final businessId = ''.obs;
  
  // CAC Number controller
  final cacNumberController = TextEditingController();

  // Section statuses: 'not_started', 'in_progress', 'completed'
  final businessInfoStatus = 'not_started'.obs;
  final ownerVerificationStatus = 'not_started'.obs;
  final businessDocsStatus = 'not_started'.obs;
  final bankAccountStatus = 'not_started'.obs;

  // Progress tracking
  final completedSections = 0.obs;
  final progressPercentage = 0.obs;

  // Submission state
  final isSubmitting = false.obs;
  final canSubmit = false.obs;
  final isRefreshing = false.obs;

  // Observable fields for required documents (keeping for backward compatibility)
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
    calculateProgress();
  }
  
  @override
  void onReady() {
    super.onReady();
    // Refresh data when page becomes visible
    _checkVerificationStatus();
  }

  @override
  void onClose() {
    cacNumberController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    isRefreshing.value = true;
    print('[BusinessDocs] 🔄 Loading saved data...');
    
    // Check verification status
    await _checkVerificationStatus();
    
    isRefreshing.value = false;
    print('[BusinessDocs] ✅ Data refresh completed');
  }

  Future<void> _checkVerificationStatus() async {
    // Get vendor business and check verification status
    try {
      print('[BusinessDocs] Fetching verification status...');
      final response = await _apiService.getVendorBusiness();
      
      if (response == null) {
        print('[BusinessDocs] ⚠️ No response from API');
        return;
      }
      
      // Handle different response formats
      Map<String, dynamic>? business;
      
      if (response['data'] != null) {
        business = response['data'];
      } else if (response['_id'] != null) {
        business = response;
      }
      
      if (business == null) {
        print('[BusinessDocs] ⚠️ No business data in response');
        return;
      }
      
      print('[BusinessDocs] ✅ Business data loaded: ${business['_id']}');
      businessId.value = business['_id'];
      
      // Check verification steps completed
      final verification = business['verification'];
      print('[BusinessDocs] Verification data: $verification');
      
      if (verification != null) {
        final stepsCompleted = verification['verificationStepsCompleted'] as List?;
        print('[BusinessDocs] Steps completed: $stepsCompleted');
        
        if (stepsCompleted != null) {
          if (stepsCompleted.contains('business-information')) {
            print('[BusinessDocs] ✅ Business information completed');
            businessInfoStatus.value = 'completed';
          }
          if (stepsCompleted.contains('owner-verification')) {
            print('[BusinessDocs] ✅ Owner verification completed');
            ownerVerificationStatus.value = 'completed';
          }
          
          // Check kyc-upload step with additional validation
          if (stepsCompleted.contains('kyc-upload')) {
            // Validate that actual data exists before marking complete
            final documents = business['documents'];
            
            print('[BusinessDocs] ========== DOCUMENT VALIDATION ==========');
            print('[BusinessDocs] Full business object keys: ${business.keys.toList()}');
            print('[BusinessDocs] Documents object: $documents');
            print('[BusinessDocs] Documents type: ${documents.runtimeType}');
            
            bool hasTin = false;
            if (documents != null) {
              print('[BusinessDocs] Documents keys: ${documents.keys.toList()}');
              if (documents['tin'] != null) {
                final tinValue = documents['tin'].toString();
                print('[BusinessDocs] TIN value: "$tinValue"');
                hasTin = tinValue.isNotEmpty && tinValue != 'null';
              }
            }
            
            bool hasCacNumber = false;
            if (documents != null) {
              if (documents['cacNumber'] != null) {
                final cacValue = documents['cacNumber'].toString();
                print('[BusinessDocs] CAC Number value: "$cacValue"');
                hasCacNumber = cacValue.isNotEmpty && cacValue != 'null';
              }
            }
            
            print('[BusinessDocs] Final Check - Has TIN: $hasTin, Has CAC Number: $hasCacNumber');
            
            // Only mark complete if at least one document number exists
            if (hasTin || hasCacNumber) {
              print('[BusinessDocs] ✅ KYC upload (Business documents) COMPLETED');
              businessDocsStatus.value = 'completed';
            } else {
              print('[BusinessDocs] ⚠️ KYC step marked in API but no TIN/CAC data found');
              print('[BusinessDocs] Documents submitted but values are empty or null');
              businessDocsStatus.value = 'not_started';
            }
            print('[BusinessDocs] ==========================================');
          } else {
            print('[BusinessDocs] ⚠️ kyc-upload step NOT in completed steps');
            businessDocsStatus.value = 'not_started';
          }
          
          if (stepsCompleted.contains('bank-info-setup')) {
            print('[BusinessDocs] ✅ Bank info completed');
            bankAccountStatus.value = 'completed';
          }
        }
      }
    } catch (e) {
      print('[BusinessDocs] ❌ Error checking verification status: $e');
    }
    
    calculateProgress();
  }

  void calculateProgress() {
    int completed = 0;
    
    if (businessInfoStatus.value == 'completed') completed++;
    if (ownerVerificationStatus.value == 'completed') completed++;
    if (businessDocsStatus.value == 'completed') completed++;
    if (bankAccountStatus.value == 'completed') completed++;
    
    completedSections.value = completed;
    progressPercentage.value = ((completed / 4) * 100).round();
    
    // Enable submit when all 4 sections are completed
    canSubmit.value = completed == 4;
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
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
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

      // Note: foodSafety and businessPermit can be uploaded later if needed
      // For now, we only use CAC certificate and TIN for KYC

      isUploading.value = false;

      if (businessRegUrl == null || tinUrl == null) {
        throw Exception('Failed to upload required documents');
      }

      // Validate CAC number
      if (cacNumberController.text.trim().isEmpty) {
        Get.back(); // Close loading dialog
        Get.snackbar(
          'Error',
          'Please enter CAC registration number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Prepare data for KYC details
      final data = {
        'businessId': businessId.value,
        'documents': {
          'cacCertificateUrl': businessRegUrl,
          'cacNumber': cacNumberController.text.trim(),
          'tin': tinUrl,
        },
      };

      // Save KYC documents via setupKycDetails endpoint
      final response = await _apiService.setupKycDetails(data);

      Get.back(); // Close loading dialog

      if (response != null) {
        businessDocsStatus.value = 'completed';
        
        // Mark step as complete
        await _apiService.updateVerificationStep({
          'businessId': businessId.value,
          'step': 'kyc-upload',
        });
        
        calculateProgress();
        
        Get.back(); // Go back to registration screen
        Get.snackbar(
          'Success',
          'Business documents saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save business documents',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isUploading.value = false;
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to save business documents: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitApplication() async {
    print('[BusinessDocs] ========== RETURNING TO REGISTRATION ==========');
    print('[BusinessDocs] completedSections: ${completedSections.value}/4');
    print('[BusinessDocs] canSubmit: ${canSubmit.value}');
    print('[BusinessDocs] Current route: ${Get.currentRoute}');
    
    try {
      // Use offNamed to replace current route - most reliable for this use case
      print('[BusinessDocs] Navigating with Get.offNamed()...');
      await Get.offNamed(Routes.BUSINESS_REGISTRATION);
      
      print('[BusinessDocs] Navigation command sent');
      print('[BusinessDocs] New route should be: ${Get.currentRoute}');
      
      // Show appropriate message based on completion
      await Future.delayed(Duration(milliseconds: 300));
      
      if (completedSections.value == 4) {
        print('[BusinessDocs] ✅ All 4 sections complete!');
        Get.snackbar(
          'Success',
          'All sections completed! You can now submit your application.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        print('[BusinessDocs] ℹ️ ${completedSections.value}/4 sections complete');
        Get.snackbar(
          'Progress Saved',
          'Complete remaining sections to submit your application.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
      
      print('[BusinessDocs] ========== NAVIGATION COMPLETE ==========');
    } catch (e, stackTrace) {
      print('[BusinessDocs] ❌ Navigation Error: $e');
      print('[BusinessDocs] Stack: $stackTrace');
      Get.snackbar(
        'Error',
        'Navigation failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
