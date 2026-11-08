import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/registration_api_service.dart';
import '../../../models/vendor_user.dart';

class BusinessRegistrationController extends GetxController {
  final _apiService = RegistrationApiService();
  
  // Step statuses: 'not_started' | 'in_progress' | 'completed' | 'pending_review'
  final businessInfoStatus = 'not_started'.obs;
  final ownerVerificationStatus = 'not_started'.obs;
  final businessDocsStatus = 'not_started'.obs;
  final bankAccountStatus = 'not_started'.obs;
  
  final isLoading = true.obs;
  final businessId = ''.obs;
  final agreedToTerms = false.obs;
  
  // Owner account data
  final ownerName = ''.obs;
  final ownerEmail = ''.obs;
  final ownerPhone = ''.obs;
  
  // Business information data
  final businessName = ''.obs;
  final businessType = ''.obs;
  final logoUploaded = false.obs;
  final coverUploaded = false.obs;
  
  // Business address data
  final businessAddress = ''.obs;
  final businessState = ''.obs;
  final businessCountry = ''.obs;
  
  // Owner verification data
  final ownerDob = ''.obs;
  final ownerIdType = ''.obs;
  final idFrontUploaded = false.obs;
  final idBackUploaded = false.obs;
  final selfieVerified = false.obs;
  
  // Documents data
  final cacUploaded = false.obs;
  final permitUploaded = false.obs;
  final tinUploaded = false.obs;
  
  // Bank account data
  final bankName = ''.obs;
  final accountNumber = ''.obs;
  final accountName = ''.obs;
  final accountVerified = false.obs;

  // Computed properties
  List<String> get completedSteps {
    final steps = <String>[];
    if (businessInfoStatus.value == 'completed') steps.add('business_info');
    if (ownerVerificationStatus.value == 'completed') steps.add('owner_verification');
    if (businessDocsStatus.value == 'completed') steps.add('business_docs');
    if (bankAccountStatus.value == 'completed') steps.add('bank_account');
    return steps;
  }

  int get progressPercentage => (completedSteps.length * 100 / 4).round();

  bool get canSubmit => completedSteps.length == 4;

  bool get canGoOnline {
    // All steps must be either completed or pending_review
    return [
      businessInfoStatus.value,
      ownerVerificationStatus.value,
      businessDocsStatus.value,
      bankAccountStatus.value,
    ].every((status) => status == 'completed' || status == 'pending_review');
  }

  @override
  void onInit() {
    super.onInit();
    loadRegistrationStatus();
  }

  Future<void> loadRegistrationStatus() async {
    try {
      isLoading.value = true;
      print('[BusinessRegistration] Loading verification status...');
      
      final response = await _apiService.getVendorBusinessForReview();
      print('[BusinessRegistration] Response: $response');
      
      if (response == null) {
        print('[BusinessRegistration] ⚠️ API returned null response');
        isLoading.value = false;
        return;
      }

      final business = response['data'] ?? response;
      print('[BusinessRegistration] 📦 Full business object: ${business.toString()}');
        
      if (business['_id'] != null) {
        businessId.value = business['_id'];
        print('[BusinessRegistration] Loaded businessId: ${businessId.value}');
      }
        
      // Load owner account data from VendorUser (logged in user)
      ownerName.value = VendorUser.userFullname.value;
      ownerEmail.value = VendorUser.userEmail.value;
      ownerPhone.value = VendorUser.userPhone.value;
      print('[BusinessRegistration] ✅ Owner data from VendorUser: ${ownerName.value}, ${ownerEmail.value}, ${ownerPhone.value}');
      
      // Also try to get from API response as fallback
      if (ownerName.value.isEmpty && business['owner'] != null) {
        print('[BusinessRegistration] 📋 Trying owner field from API...');
        final owner = business['owner'];
        ownerName.value = owner['name'] ?? owner['fullname'] ?? owner['fullName'] ?? '';
        ownerEmail.value = owner['email'] ?? '';
        ownerPhone.value = owner['phone'] ?? '';
      } else if (ownerName.value.isEmpty && business['user'] != null) {
        print('[BusinessRegistration] 📋 Trying user field from API...');
        final user = business['user'];
        ownerName.value = user['name'] ?? user['fullname'] ?? user['fullName'] ?? '';
        ownerEmail.value = user['email'] ?? '';
        ownerPhone.value = user['phone'] ?? '';
      } else if (ownerName.value.isEmpty && business['vendor'] != null) {
        print('[BusinessRegistration] 📋 Trying vendor field from API...');
        final vendor = business['vendor'];
        ownerName.value = vendor['name'] ?? vendor['fullname'] ?? vendor['fullName'] ?? '';
        ownerEmail.value = vendor['email'] ?? '';
        ownerPhone.value = vendor['phone'] ?? '';
      }
        
      // Load business information
      businessName.value = business['name'] ?? '';
      businessType.value = business['businessType'] ?? business['businessCategory'] ?? '';
      
      // Check for logo - handle both direct URL and nested structure
      if (business['logo'] != null && business['logo'].toString().isNotEmpty) {
        logoUploaded.value = true;
        print('[BusinessRegistration] ✅ Logo: ${business['logo']}');
      } else if (business['logoUrl'] != null && business['logoUrl'].toString().isNotEmpty) {
        logoUploaded.value = true;
        print('[BusinessRegistration] ✅ Logo from logoUrl: ${business['logoUrl']}');
      } else {
        logoUploaded.value = false;
        print('[BusinessRegistration] ⚠️ No logo found');
      }
      
      // Check for cover image - try multiple field names
      if (business['coverImage'] != null && business['coverImage'].toString().isNotEmpty) {
        coverUploaded.value = true;
        print('[BusinessRegistration] ✅ Cover: ${business['coverImage']}');
      } else if (business['banner'] != null && business['banner'].toString().isNotEmpty) {
        coverUploaded.value = true;
        print('[BusinessRegistration] ✅ Cover from banner: ${business['banner']}');
      } else if (business['bannerUrl'] != null && business['bannerUrl'].toString().isNotEmpty) {
        coverUploaded.value = true;
        print('[BusinessRegistration] ✅ Cover from bannerUrl: ${business['bannerUrl']}');
      } else if (business['bannerApproval'] != null) {
        final bannerApproval = business['bannerApproval'];
        if (bannerApproval['pendingBannerUrl'] != null && bannerApproval['pendingBannerUrl'].toString().isNotEmpty) {
          coverUploaded.value = true;
          print('[BusinessRegistration] ✅ Cover from pendingBannerUrl: ${bannerApproval['pendingBannerUrl']}');
        }
      } else {
        coverUploaded.value = false;
        print('[BusinessRegistration] ⚠️ No cover image found');
      }
      
      print('[BusinessRegistration] ✅ Business info: ${businessName.value}, ${businessType.value}, Logo: ${logoUploaded.value}, Cover: ${coverUploaded.value}');
        
      // Load business address - get formatted address and coordinates
      if (business['address'] != null) {
        final address = business['address'];
        
        // Build formatted address from available fields
        final addressParts = <String>[];
        if (address['street'] != null && address['street'].toString().isNotEmpty) {
          addressParts.add(address['street']);
        }
        if (address['city'] != null && address['city'].toString().isNotEmpty) {
          addressParts.add(address['city']);
        }
        if (address['state'] != null && address['state'].toString().isNotEmpty) {
          addressParts.add(address['state']);
        }
        
        // Use the formatted address or fallback to individual parts
        businessAddress.value = address['formattedAddress']?.toString() ?? 
                                address['address']?.toString() ?? 
                                addressParts.join(', ');
        
        businessState.value = address['state'] ?? '';
        businessCountry.value = address['country'] ?? '';
        
        print('[BusinessRegistration] ✅ Address from address field: ${businessAddress.value}');
      }
      
      // Also check top-level location field (from Business.location)
      if (business['location'] != null) {
        final location = business['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        
        if (lat != null && lng != null) {
          print('[BusinessRegistration] ✅ Business location coordinates: $lat, $lng');
          
          // If address is empty, try to use formatted address from location
          if (businessAddress.value.isEmpty && location['address'] != null) {
            businessAddress.value = location['address'].toString();
            print('[BusinessRegistration] ✅ Using address from location field');
          }
        }
      }
      
      // Fallback to country field if not in address
      if (businessCountry.value.isEmpty && business['country'] != null) {
        businessCountry.value = business['country'];
      }
      
      // Additional check for locationVerification (from business verification)
      if (business['locationVerification'] != null) {
        final locVerif = business['locationVerification'];
        if (locVerif['coordinates'] != null) {
          final coords = locVerif['coordinates'];
          final lat = coords['latitude'];
          final lng = coords['longitude'];
          if (lat != null && lng != null) {
            print('[BusinessRegistration] ✅ Verification coordinates: $lat, $lng');
          }
        }
        
        // Use registered address if main address is empty
        if (businessAddress.value.isEmpty && locVerif['registeredAddress'] != null) {
          businessAddress.value = locVerif['registeredAddress'].toString();
          print('[BusinessRegistration] ✅ Using registeredAddress from locationVerification');
        }
      }
      
      print('[BusinessRegistration] ✅ Final Address: ${businessAddress.value}');
      print('[BusinessRegistration] ✅ State: ${businessState.value}, Country: ${businessCountry.value}');
        
      // Load owner verification data
      if (business['identityVerification'] != null) {
        final identity = business['identityVerification'];
        ownerDob.value = identity['dateOfBirth'] ?? '';
        ownerIdType.value = identity['idType'] ?? '';
        idFrontUploaded.value = (identity['idFrontUrl'] != null && identity['idFrontUrl'].toString().isNotEmpty);
        idBackUploaded.value = (identity['idBackUrl'] != null && identity['idBackUrl'].toString().isNotEmpty);
        selfieVerified.value = (identity['selfieUrl'] != null && identity['selfieUrl'].toString().isNotEmpty);
        print('[BusinessRegistration] ✅ Identity verification loaded');
      }
        
      // Load documents
      if (business['documents'] != null) {
        final documents = business['documents'];
        cacUploaded.value = (documents['cacCertificateUrl'] != null && documents['cacCertificateUrl'].toString().isNotEmpty);
        permitUploaded.value = (documents['foodPermitUrl'] != null && documents['foodPermitUrl'].toString().isNotEmpty);
        tinUploaded.value = (documents['tin'] != null && documents['tin'].toString().isNotEmpty);
        print('[BusinessRegistration] ✅ Documents loaded');
      }
        
      // Load bank account - check both bankDetails and bankInfo
      if (business['bankDetails'] != null) {
        print('[BusinessRegistration] 📋 Using bankDetails field');
        final bank = business['bankDetails'];
        bankName.value = bank['bankName'] ?? '';
        accountNumber.value = bank['accountNumber'] ?? '';
        accountName.value = bank['accountName'] ?? '';
        accountVerified.value = bank['isVerified'] == true;
        print('[BusinessRegistration] ✅ Bank details loaded from bankDetails');
      } else if (business['bankInfo'] != null) {
        print('[BusinessRegistration] 📋 Using bankInfo field instead');
        final bank = business['bankInfo'];
        bankName.value = bank['bankName'] ?? '';
        accountNumber.value = bank['accountNumber'] ?? '';
        accountName.value = bank['accountName'] ?? '';
        accountVerified.value = bank['isVerified'] == true;
        print('[BusinessRegistration] ✅ Bank details loaded from bankInfo');
      }
        
      // Check verification steps completed
      final verification = business['verification'];
      final verificationSteps = verification?['verificationStepsCompleted'] as List? ?? [];
        
      print('[BusinessRegistration] Verification steps: $verificationSteps');
        
      // Map backend steps to UI statuses
      businessInfoStatus.value = verificationSteps.contains('business-information') ? 'completed' : 'not_started';
      ownerVerificationStatus.value = verificationSteps.contains('kyc-upload') ? 'completed' : 'not_started';
      businessDocsStatus.value = verificationSteps.contains('kyc-upload') ? 'completed' : 'not_started';
      bankAccountStatus.value = verificationSteps.contains('bank-info-setup') ? 'completed' : 'not_started';
        
      print('[BusinessRegistration] ✅ Business info: ${businessInfoStatus.value}');
      print('[BusinessRegistration] ✅ Owner verification: ${ownerVerificationStatus.value}');
      print('[BusinessRegistration] ✅ Business docs: ${businessDocsStatus.value}');
      print('[BusinessRegistration] ✅ Bank account: ${bankAccountStatus.value}');
    } catch (e, stackTrace) {
      print('[BusinessRegistration] ❌ Error loading status: $e');
      print('[BusinessRegistration] Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  void goToBusinessInfo() {
    Get.toNamed(Routes.BUSINESS_DOCS);
  }

  void goToOwnerVerification() {
    // Owner verification is now accessed through Business Docs view
    Get.toNamed(Routes.BUSINESS_DOCS);
  }

  void goToBusinessDocs() {
    Get.toNamed(Routes.BUSINESS_DOCS);
  }

  void goToBankAccount() {
    Get.toNamed(Routes.BUSINESS_DOCS);
  }

  Future<void> submitApplication() async {
    print('[BusinessRegistration] ========== SUBMIT CLICKED ==========');
    print('[BusinessRegistration] canSubmit: $canSubmit');
    print('[BusinessRegistration] completedSteps: ${completedSteps.length}/4');
    
    if (!canSubmit) {
      print('[BusinessRegistration] ❌ Cannot submit - steps incomplete');
      Get.snackbar(
        'Incomplete',
        'Please complete all 4 registration steps before submitting',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Show loading dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Submitting your application...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      print('[BusinessRegistration] 📤 Submitting application to API...');

      // Call API to mark application as submitted
      final response = await _apiService.updateVerificationStep({
        'businessId': businessId.value,
        'step': 'application-submitted',
      });

      // Close loading dialog
      Get.back();

      if (response != null) {
        print('[BusinessRegistration] ✅ Application submitted successfully');
        
        // Navigate to application status page
        Get.offNamed(Routes.APPLICATION_STATUS);
      } else {
        print('[BusinessRegistration] ⚠️ Submission response was null, navigating anyway...');
        // Still navigate even if API fails - user can see status page
        Get.offNamed(Routes.APPLICATION_STATUS);
      }

    } catch (e, stackTrace) {
      print('[BusinessRegistration] ❌ Submission error: $e');
      print('[BusinessRegistration] Stack: $stackTrace');
      
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error but still allow navigation to status page
      Get.snackbar(
        'Submission Notice',
        'Your application data has been saved. You can check status now.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Navigate to status page anyway
      await Future.delayed(Duration(seconds: 1));
      Get.offNamed(Routes.APPLICATION_STATUS);
    }
  }
}
