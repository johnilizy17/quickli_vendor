import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/file_upload_service.dart';
import '../../../services/registration_api_service.dart';
import '../../auth/controllers/business_info_controller.dart';

class OwnerVerificationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _fileUploadService = FileUploadService();
  final _apiService = RegistrationApiService();

  // Store businessId
  final businessId = ''.obs;

  // Controllers
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final idNumberController = TextEditingController();
  final bvnController = TextEditingController();
  final ninController = TextEditingController();

  // Observable fields
  final idType = ''.obs;
  final idFrontPath = ''.obs;
  final idBackPath = ''.obs;
  final selfiePath = ''.obs;
  final idFrontFile = Rxn<File>();
  final idBackFile = Rxn<File>();
  final selfieFile = Rxn<File>();
  final isUploading = false.obs;
  final isLoading = false.obs; // Add loading state
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
    bvnController.dispose();
    ninController.dispose();
    super.onClose();
  }

  Future<void> loadSavedData() async {
    try {
      isLoading.value = true;
      print('[OWNER VERIFICATION] 🔄 Starting to load saved data...');
      
      // Try to get businessId from BusinessInfoController first
      try {
        final businessInfoController = Get.find<BusinessInfoController>();
        if (businessInfoController.businessId.value.isNotEmpty) {
          businessId.value = businessInfoController.businessId.value;
          print('[OWNER VERIFICATION] ✅ Loaded businessId from BusinessInfoController: ${businessId.value}');
        }
      } catch (e) {
        print('[OWNER VERIFICATION] ⚠️ BusinessInfoController not found, will try API...');
      }

      // Get vendor business from API to load all data
      print('[OWNER VERIFICATION] 📡 Fetching business data from API...');
      final response = await _apiService.getVendorBusiness();
      print('[OWNER VERIFICATION] 📥 API Response received: ${response != null ? "Success" : "Null"}');
      
      if (response == null) {
        print('[OWNER VERIFICATION] ⚠️ API returned null response');
        isLoading.value = false;
        return;
      }

      // Handle both response formats: { data: { _id: ... } } or { _id: ... }
      final business = response['data'] ?? response;
      print('[OWNER VERIFICATION] 📦 Business data structure keys: ${business.keys.toList()}');
      
      // Load businessId if not already loaded
      if (businessId.value.isEmpty) {
        if (business['_id'] != null) {
          businessId.value = business['_id'];
          print('[OWNER VERIFICATION] ✅ Loaded businessId from API: ${businessId.value}');
        } else if (business['id'] != null) {
          businessId.value = business['id'];
          print('[OWNER VERIFICATION] ✅ Loaded businessId from API (id field): ${businessId.value}');
        } else {
          print('[OWNER VERIFICATION] ❌ No business ID found in response');
        }
      }
      
      // Load saved identity verification data if it exists
      if (business['identityVerification'] != null) {
        final identity = business['identityVerification'];
        print('[OWNER VERIFICATION] 📋 Loading identity verification data...');
        print('[OWNER VERIFICATION] Identity keys: ${identity.keys.toList()}');
        
        // Load ID type
        if (identity['idType'] != null && identity['idType'].toString().isNotEmpty) {
          idType.value = identity['idType'];
          print('[OWNER VERIFICATION] ✅ ID Type: ${identity['idType']}');
        }
        
        // Load full name
        if (identity['fullName'] != null && 
            identity['fullName'].toString().isNotEmpty && 
            identity['fullName'] != 'Business Owner') {
          fullNameController.text = identity['fullName'];
          print('[OWNER VERIFICATION] ✅ Full Name: ${identity['fullName']}');
        }
        
        // Load ID number
        if (identity['idNumber'] != null && 
            identity['idNumber'].toString().isNotEmpty && 
            identity['idNumber'] != 'N/A') {
          idNumberController.text = identity['idNumber'];
          print('[OWNER VERIFICATION] ✅ ID Number: ${identity['idNumber']}');
        }
        
        // Load date of birth
        if (identity['dateOfBirth'] != null && identity['dateOfBirth'].toString().isNotEmpty) {
          try {
            selectedDob = DateTime.parse(identity['dateOfBirth']);
            dobController.text = DateFormat('dd MMM yyyy').format(selectedDob!);
            print('[OWNER VERIFICATION] ✅ DOB: ${dobController.text}');
          } catch (e) {
            print('[OWNER VERIFICATION] ⚠️ Failed to parse DOB: $e');
          }
        }
        
        // Load uploaded document URLs
        if (identity['idFrontUrl'] != null && identity['idFrontUrl'].toString().isNotEmpty) {
          idFrontPath.value = identity['idFrontUrl'];
          print('[OWNER VERIFICATION] ✅ ID Front URL: ${identity['idFrontUrl']}');
        }
        
        if (identity['idBackUrl'] != null && identity['idBackUrl'].toString().isNotEmpty) {
          idBackPath.value = identity['idBackUrl'];
          print('[OWNER VERIFICATION] ✅ ID Back URL: ${identity['idBackUrl']}');
        }
        
        if (identity['selfieUrl'] != null && identity['selfieUrl'].toString().isNotEmpty) {
          selfiePath.value = identity['selfieUrl'];
          print('[OWNER VERIFICATION] ✅ Selfie URL: ${identity['selfieUrl']}');
        }
        
        print('[OWNER VERIFICATION] ✅ Identity verification data loaded successfully');
      } else {
        print('[OWNER VERIFICATION] ⚠️ No identityVerification field in business data');
      }
      
      // Load BVN/NIN from documents if available
      if (business['documents'] != null) {
        final documents = business['documents'];
        print('[OWNER VERIFICATION] 📄 Loading documents...');
        
        if (documents['bvn'] != null && documents['bvn'].toString().isNotEmpty) {
          bvnController.text = documents['bvn'];
          print('[OWNER VERIFICATION] ✅ BVN loaded');
        }
        
        if (documents['nin'] != null && documents['nin'].toString().isNotEmpty) {
          ninController.text = documents['nin'];
          print('[OWNER VERIFICATION] ✅ NIN loaded');
        }
      } else {
        print('[OWNER VERIFICATION] ⚠️ No documents field in business data');
      }
      
      print('[OWNER VERIFICATION] ✅ Load saved data completed successfully');
    } catch (e, stackTrace) {
      print('[OWNER VERIFICATION] ❌ Error loading saved data: $e');
      print('[OWNER VERIFICATION] Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
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

    // Check if we have either new files OR existing URLs
    final hasIdFront = idFrontFile.value != null || idFrontPath.value.isNotEmpty;
    final hasIdBack = idBackFile.value != null || idBackPath.value.isNotEmpty;
    final hasSelfie = selfieFile.value != null || selfiePath.value.isNotEmpty;
    
    if (!hasIdFront || !hasIdBack || !hasSelfie) {
      Get.snackbar(
        'Error',
        'Please upload all required documents',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await submitOwnerVerification();
  }

  Future<void> submitOwnerVerification() async {
    try {
      print('[OWNER VERIFICATION] Starting submission...');
      isUploading.value = true;

      // Ensure businessId is loaded
      if (businessId.value.isEmpty) {
        print('[OWNER VERIFICATION] Business ID empty, loading...');
        await loadSavedData();
        
        if (businessId.value.isEmpty) {
          throw Exception('Business ID not found. Please complete business information first.');
        }
      }
      
      print('[OWNER VERIFICATION] Using businessId: ${businessId.value}');

      // Upload or use existing document URLs
      String? idFrontUrl;
      String? idBackUrl;
      String? selfieUrl;
      
      // Handle ID front - upload new file or use existing URL
      if (idFrontFile.value != null) {
        print('[OWNER VERIFICATION] Uploading new ID front...');
        idFrontUrl = await _apiService.uploadFile(
          idFrontFile.value!,
          folder: 'verification/id_front',
        );
        
        if (idFrontUrl == null) {
          throw Exception('Failed to upload ID front');
        }
        print('[OWNER VERIFICATION] ✅ ID front uploaded: $idFrontUrl');
      } else if (idFrontPath.value.isNotEmpty) {
        idFrontUrl = idFrontPath.value;
        print('[OWNER VERIFICATION] ✅ Using existing ID front URL: $idFrontUrl');
      } else {
        throw Exception('ID front image is required');
      }
      
      // Handle ID back - upload new file or use existing URL
      if (idBackFile.value != null) {
        print('[OWNER VERIFICATION] Uploading new ID back...');
        idBackUrl = await _apiService.uploadFile(
          idBackFile.value!,
          folder: 'verification/id_back',
        );
        
        if (idBackUrl == null) {
          throw Exception('Failed to upload ID back');
        }
        print('[OWNER VERIFICATION] ✅ ID back uploaded: $idBackUrl');
      } else if (idBackPath.value.isNotEmpty) {
        idBackUrl = idBackPath.value;
        print('[OWNER VERIFICATION] ✅ Using existing ID back URL: $idBackUrl');
      } else {
        throw Exception('ID back image is required');
      }
      
      // Handle selfie - upload new file or use existing URL
      if (selfieFile.value != null) {
        print('[OWNER VERIFICATION] Uploading new selfie...');
        selfieUrl = await _apiService.uploadFile(
          selfieFile.value!,
          folder: 'verification/selfie',
        );

        if (selfieUrl == null) {
          throw Exception('Failed to upload selfie');
        }
        print('[OWNER VERIFICATION] ✅ Selfie uploaded: $selfieUrl');
      } else if (selfiePath.value.isNotEmpty) {
        selfieUrl = selfiePath.value;
        print('[OWNER VERIFICATION] ✅ Using existing selfie URL: $selfieUrl');
      } else {
        throw Exception('Selfie image is required');
      }
      
      print('[OWNER VERIFICATION] ✅ All documents ready (uploaded or existing)');

      // Prepare data for KYC details (identity verification)
      final data = {
        'businessId': businessId.value,
        'documents': {
          if (bvnController.text.trim().isNotEmpty)
            'bvn': bvnController.text.trim(),
          if (ninController.text.trim().isNotEmpty)
            'nin': ninController.text.trim(),
        },
        'identityVerification': {
          'idType': idType.value,
          'idNumber': idNumberController.text.trim().isNotEmpty ? idNumberController.text.trim() : 'N/A',
          'fullName': fullNameController.text.trim().isNotEmpty ? fullNameController.text.trim() : 'Business Owner',
          if (selectedDob != null)
            'dateOfBirth': selectedDob?.toIso8601String(),
          'idFrontUrl': idFrontUrl,
          'idBackUrl': idBackUrl,
          'selfieUrl': selfieUrl,
        },
      };

      print('[OWNER VERIFICATION] Submitting data to API: ${data.toString()}');
      // Save to API using setupKycDetails
      final response = await _apiService.setupKycDetails(data);

      if (response != null) {
        print('[OWNER VERIFICATION] ✅ API submission successful: ${response.toString()}');
        
        // Mark step as complete
        print('[OWNER VERIFICATION] Marking verification step as complete...');
        await _apiService.updateVerificationStep({
          'businessId': businessId.value,
          'step': 'owner-verification',
        });
        
        print('[OWNER VERIFICATION] ✅ Verification step marked complete');
        
        isUploading.value = false;
        
        Get.snackbar(
          'Success',
          'Verification documents submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Navigate back to business docs view (close all 4 steps)
        await Future.delayed(Duration(seconds: 2));
        print('[OWNER VERIFICATION] Navigating back to business docs...');
        Get.close(4); // Close: Preview -> Capture -> Back -> Front
        
      } else {
        throw Exception('API returned null response');
      }
    } catch (e, stackTrace) {
      isUploading.value = false;
      print('[OWNER VERIFICATION] ❌ Submission failed: $e');
      print('[OWNER VERIFICATION] Stack trace: $stackTrace');
      
      Get.snackbar(
        'Error',
        'Failed to submit verification documents: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }
}
