import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../utils/app_logger.dart';

class OnboardingCompletionController extends GetxController {
  final _apiService = ApiService.to;
  
  // Current step (0: Agreement, 1: Products, 2: Hours)
  final currentStep = 0.obs;
  final totalSteps = 3;
  
  // Step completion status
  final agreementSigned = false.obs;
  final productsAdded = 0.obs;
  final hoursConfigured = false.obs;
  
  // Loading states
  final isLoading = false.obs;
  final isSigning = false.obs;
  
  // Contract data
  final contractText = ''.obs;
  final businessId = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkCompletionStatus();
  }
  
  // Check which steps are already completed
  Future<void> _checkCompletionStatus() async {
    try {
      isLoading.value = true;
      
      // Fetch business profile to check contract status
      final response = await _apiService.get('/business');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          final business = data['data'];
          businessId.value = business['_id'] ?? '';
          
          // Check contract
          final contract = business['contract'];
          if (contract != null && contract['signed'] == true) {
            agreementSigned.value = true;
          } else {
            agreementSigned.value = false;
          }
          
          // Check products count
          final products = business['productsCount'] ?? 0;
          productsAdded.value = products;
          
          // Check operating hours
          final hours = business['operatingHours'];
          if (hours != null && hours is Map && hours.isNotEmpty) {
            // Check if at least one day is configured and open
            bool hasConfiguredDay = false;
            for (var entry in hours.entries) {
              if (entry.value is Map && entry.value['isOpen'] == true) {
                hasConfiguredDay = true;
                break;
              }
            }
            hoursConfigured.value = hasConfiguredDay;
          } else {
            hoursConfigured.value = false;
          }
          
          appLog('OnboardingCompletionController: Status loaded - Agreement: ${agreementSigned.value}, Products: ${productsAdded.value}, Hours: ${hoursConfigured.value}');
        }
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      appLog('OnboardingCompletionController: Error checking status: $e');
    }
  }
  
  // Refresh status from API
  Future<void> refreshStatus() async {
    await _checkCompletionStatus();
  }
  
  // Calculate completion percentage
  int get completionPercentage {
    int completed = 0;
    if (agreementSigned.value) completed++;
    if (productsAdded.value >= 5) completed++;
    if (hoursConfigured.value) completed++;
    return ((completed / totalSteps) * 100).round();
  }
  
  // Get completion text
  String get completionText {
    int completed = 0;
    if (agreementSigned.value) completed++;
    if (productsAdded.value >= 5) completed++;
    if (hoursConfigured.value) completed++;
    return '$completed / $totalSteps required tasks done';
  }
  
  // Navigate to next step
  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }
  
  // Navigate to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
  
  // Go to specific step
  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      currentStep.value = step;
    }
  }
  
  // Sign contract
  Future<void> signContract() async {
    try {
      isSigning.value = true;
      
      final response = await _apiService.post('/business/sign-contract');
      
      if (response.statusCode == 200) {
        agreementSigned.value = true;
        Get.snackbar('Success', 'Contract signed successfully');
        nextStep();
      } else {
        Get.snackbar('Error', 'Failed to sign contract');
      }
      
      isSigning.value = false;
    } catch (e) {
      isSigning.value = false;
      appLog('OnboardingCompletionController: Error signing contract: $e');
      Get.snackbar('Error', 'Failed to sign contract');
    }
  }
  
  // Skip to add products
  void skipToProducts() {
    Get.toNamed('/products/add');
  }
  
  // Skip to operating hours
  void skipToHours() {
    Get.toNamed('/business-profile/operating-hours');
  }
  
  // Complete onboarding
  void completeOnboarding() {
    if (agreementSigned.value && productsAdded.value >= 5 && hoursConfigured.value) {
      Get.offAllNamed('/wrapper');
    } else {
      Get.snackbar('Incomplete', 'Please complete all required steps');
    }
  }
}
