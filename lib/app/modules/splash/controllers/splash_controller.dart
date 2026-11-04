import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constants/api_route.dart';
import '../../../models/vendor_user.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_service.dart';
import '../../../services/main_storage.dart';
import '../../../utils/app_logger.dart';

class SplashController extends GetxController {
  final isLoading = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    appLog('SplashController: onInit called');
    _setupNavigation();
  }
  
  @override
  void onReady() {
    super.onReady();
    appLog('SplashController: onReady called');
  }
  
  Future<void> _setupNavigation() async {
    try {
      appLog('SplashController: _setupNavigation started');
      
      // Wait for splash screen display
      await Future.delayed(const Duration(milliseconds: 1500));
      appLog('SplashController: Delay completed');
      
      // Load tokens from storage
      final tokens = await ApiService.to.loadTokens();
      appLog('SplashController: tokens=${tokens != null}');

      if (tokens == null || tokens.isEmpty) {
        // No tokens found - redirect to auth
        appLog('SplashController: No tokens found, navigating to AUTH');
        Get.offAllNamed(Routes.AUTH);
        return;
      }

      // Tokens exist - verify authentication and check vendor profile
      appLog('SplashController: Tokens found, checking vendor profile');
      await _checkVendorProfileAndNavigate();
      
    } catch (e, stackTrace) {
      appLog('SplashController: Error during navigation setup: $e');
      appLog('SplashController: StackTrace: $stackTrace');
      // On error, clear tokens and redirect to auth
      ApiService.to.clearTokens();
      Get.offAllNamed(Routes.AUTH);
    }
  }

  Future<void> _checkVendorProfileAndNavigate() async {
    try {
      appLog('SplashController: Fetching vendor profile...');
      // Fetch vendor profile to check verification status
      final response = await ApiService.to.get(ApiRoute.userProfile);
      
      appLog('SplashController: Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        appLog('SplashController: Profile fetch successful');
        appLog('SplashController: Response data: $data');
        
        if (data['status'] == 'success' && data['data'] != null) {
          final vendor = data['data'];
          
          // Extract verification info
          final verification = vendor['verification'];
          final kycStatus = verification?['kycStatus'] ?? 'pending';
          final isFullyVerified = verification?['isFullyVerified'] ?? false;
          final verificationSteps = verification?['verificationStepsCompleted'] as List? ?? [];
          
          appLog('SplashController: kycStatus=$kycStatus, isFullyVerified=$isFullyVerified');
          appLog('SplashController: verificationSteps=$verificationSteps');
          
          // Check if all onboarding steps are completed
          final hasBusinessInfo = verificationSteps.contains('business-information');
          final hasKycUpload = verificationSteps.contains('kyc-upload');
          final hasBankInfo = verificationSteps.contains('bank-info-setup');
          final allStepsCompleted = hasBusinessInfo && hasKycUpload && hasBankInfo;
          
          appLog('SplashController: allStepsCompleted=$allStepsCompleted');
          
          // Set vendor user data
          VendorUser.setUser(vendor);
          
          // Mark onboarding as completed if tokens exist
          if (!MainStorage.getIsOnboarded) {
            MainStorage.saveOnboardingCompleted(true);
          }
          
          // Navigate based on verification status
          if (isFullyVerified || kycStatus == 'verified') {
            // Fully verified - go to main app
            appLog('SplashController: Vendor verified - navigating to wrapper');
            Get.offAllNamed(Routes.WRAPPER);
          } else if (kycStatus == 'requested' && allStepsCompleted) {
            // Pending verification - all steps done, waiting for admin approval
            appLog('SplashController: Verification pending - navigating to verification pending view');
            Get.offAllNamed(Routes.VERIFICATION_PENDING);
          } else {
            // Incomplete onboarding or rejected - needs to complete registration
            appLog('SplashController: Onboarding incomplete - navigating to auth');
            Get.offAllNamed(Routes.AUTH);
          }
        } else {
          // Invalid response - redirect to auth
          appLog('SplashController: Invalid response format, navigating to auth');
          Get.offAllNamed(Routes.AUTH);
        }
      } else {
        // Failed to fetch profile - clear tokens and redirect to auth
        appLog('SplashController: Profile fetch failed with status ${response.statusCode}');
        ApiService.to.clearTokens();
        Get.offAllNamed(Routes.AUTH);
      }
    } catch (e, stackTrace) {
      appLog('SplashController: Error fetching profile: $e');
      appLog('SplashController: StackTrace: $stackTrace');
      // On error, clear tokens and redirect to auth
      ApiService.to.clearTokens();
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
