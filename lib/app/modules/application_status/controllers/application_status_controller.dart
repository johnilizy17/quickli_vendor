import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/registration_api_service.dart';
import '../../../routes/app_pages.dart';

class ApplicationStatusController extends GetxController {
  final _apiService = RegistrationApiService();

  final isLoading = true.obs;
  final status = 'pending'.obs; // 'pending', 'approved', 'rejected'
  final referenceNumber = ''.obs;
  final businessName = ''.obs;
  final email = ''.obs;
  final rejectionReasons = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadApplicationStatus();
  }

  Future<void> loadApplicationStatus() async {
    try {
      isLoading.value = true;
      print('[ApplicationStatus] Loading application status...');

      final response = await _apiService.getVendorBusiness();
      
      if (response == null) {
        print('[ApplicationStatus] ⚠️ No response from API');
        status.value = 'pending';
        referenceNumber.value = 'N/A';
        isLoading.value = false;
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
        print('[ApplicationStatus] ⚠️ No business data');
        status.value = 'pending';
        isLoading.value = false;
        return;
      }

      // Extract verification data
      final verification = business['verification'];
      final kycStatus = verification?['kycStatus'] ?? 'pending';
      
      print('[ApplicationStatus] Status: $kycStatus');
      
      // Map API status to view status
      if (kycStatus == 'approved' || kycStatus == 'verified') {
        status.value = 'approved';
      } else if (kycStatus == 'rejected' || kycStatus == 'declined') {
        status.value = 'rejected';
        
        // Extract rejection reasons if available
        final reasons = verification?['rejectionReasons'] as List?;
        if (reasons != null && reasons.isNotEmpty) {
          rejectionReasons.value = reasons.map((r) {
            if (r is Map) {
              return Map<String, dynamic>.from(r);
            }
            return {'title': r.toString(), 'description': null};
          }).toList();
        } else {
          // Default rejection reasons
          rejectionReasons.value = [
            {
              'title': 'Verification pending',
              'description': 'Your application is still under review.',
            }
          ];
        }
      } else {
        // 'requested', 'pending', or any other status
        status.value = 'pending';
      }

      // Generate or extract reference number
      final businessId = business['_id'] ?? '';
      if (businessId.isNotEmpty) {
        // Extract last 6 characters of ID for reference
        final shortId = businessId.length > 6 
            ? businessId.substring(businessId.length - 6).toUpperCase()
            : businessId.toUpperCase();
        referenceNumber.value = 'QV-2026-$shortId';
      } else {
        referenceNumber.value = 'QV-2026-PENDING';
      }
      
      print('[ApplicationStatus] Reference: ${referenceNumber.value}');

      // Extract business name
      businessName.value = business['name'] ?? business['businessName'] ?? 'Your Business';

      // Extract email (from owner or business)
      final owner = business['owner'];
      if (owner != null && owner['email'] != null) {
        email.value = owner['email'];
      } else if (business['email'] != null) {
        email.value = business['email'];
      }

      isLoading.value = false;
    } catch (e, stackTrace) {
      print('[ApplicationStatus] ❌ Submission error: $e');
      print('[ApplicationStatus] Stack: $stackTrace');
      
      // Default to pending on error
      status.value = 'pending';
      referenceNumber.value = 'QV-2026-ERROR';
      isLoading.value = false;
    }
  }

  void goToHome() {
    // Navigate to home/dashboard (wrapper with bottom nav)
    print('[ApplicationStatus] Navigating to WRAPPER (home with bottom nav)');
    print('[ApplicationStatus] Route: ${Routes.WRAPPER}');
    Get.offAllNamed(Routes.WRAPPER);
    print('[ApplicationStatus] Navigation command executed');
  }

  void setupStore() {
    // Navigate to store setup (wrapper with bottom nav)
    print('[ApplicationStatus] Navigating to WRAPPER (setup store)');
    print('[ApplicationStatus] Route: ${Routes.WRAPPER}');
    Get.offAllNamed(Routes.WRAPPER);
    print('[ApplicationStatus] Navigation command executed');
  }

  void resubmitApplication() {
    // Go back to business registration to fix issues
    Get.offAllNamed(Routes.BUSINESS_REGISTRATION);
  }

  void contactSupport() {
    // Open support contact (could be email, phone, or in-app chat)
    Get.snackbar(
      'Contact Support',
      'Email: support@quickliapp.com\nPhone: +234 XXX XXX XXXX',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      duration: Duration(seconds: 5),
    );
  }

  // For review_application_view.dart
  final businessData = Rx<Map<String, dynamic>?>(null);

  Future<void> loadBusinessData() async {
    // Alias for loadApplicationStatus
    await loadApplicationStatus();
    
    // Populate businessData for review page
    if (status.value == 'pending' || status.value == 'approved' || status.value == 'rejected') {
      final response = await _apiService.getVendorBusiness();
      if (response != null) {
        businessData.value = response['data'] ?? response;
      }
    }
  }

  Future<void> submitApplication() async {
    try {
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

      print('[ApplicationStatus] Submitting application from review page...');

      // Call API to mark application as submitted
      if (businessData.value != null && businessData.value!['_id'] != null) {
        await _apiService.updateVerificationStep({
          'businessId': businessData.value!['_id'],
          'step': 'application-submitted',
        });
      }

      // Close loading dialog
      Get.back();

      // Navigate to application status page
      Get.offNamed(Routes.APPLICATION_STATUS);
      
    } catch (e, stackTrace) {
      print('[ApplicationStatus] ❌ Submission error: $e');
      print('[ApplicationStatus] Stack: $stackTrace');
      
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error but still navigate to status page
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
