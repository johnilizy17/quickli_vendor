import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class BusinessRegistrationController extends GetxController {
  // Step statuses: 'not_started' | 'in_progress' | 'completed' | 'pending_review'
  final businessInfoStatus = 'not_started'.obs;
  final ownerVerificationStatus = 'not_started'.obs;
  final businessDocsStatus = 'not_started'.obs;
  final bankAccountStatus = 'not_started'.obs;
  final taxInfoStatus = 'not_started'.obs;

  // Computed properties
  List<String> get completedSteps {
    final steps = <String>[];
    if (businessInfoStatus.value == 'completed') steps.add('business_info');
    if (ownerVerificationStatus.value == 'completed') steps.add('owner_verification');
    if (businessDocsStatus.value == 'completed') steps.add('business_docs');
    if (bankAccountStatus.value == 'completed') steps.add('bank_account');
    if (taxInfoStatus.value == 'completed') steps.add('tax_info');
    return steps;
  }

  int get progressPercentage => (completedSteps.length * 100 / 5).round();

  bool get canSubmit => completedSteps.length == 5;

  bool get canGoOnline {
    // All steps must be either completed or pending_review
    return [
      businessInfoStatus.value,
      ownerVerificationStatus.value,
      businessDocsStatus.value,
      bankAccountStatus.value,
      taxInfoStatus.value,
    ].every((status) => status == 'completed' || status == 'pending_review');
  }

  @override
  void onInit() {
    super.onInit();
    loadRegistrationStatus();
  }

  Future<void> loadRegistrationStatus() async {
    // TODO: Load from API or local storage
    // For now, using dummy data
    businessInfoStatus.value = 'not_started';
    ownerVerificationStatus.value = 'not_started';
    businessDocsStatus.value = 'not_started';
    bankAccountStatus.value = 'not_started';
    taxInfoStatus.value = 'not_started';
  }

  void goToBusinessInfo() {
    Get.toNamed(Routes.BUSINESS_INFO);
  }

  void goToOwnerVerification() {
    Get.toNamed(Routes.OWNER_VERIFICATION);
  }

  void goToBusinessDocs() {
    Get.toNamed(Routes.BUSINESS_DOCS);
  }

  void goToBankAccount() {
    Get.toNamed(Routes.BANK_ACCOUNT);
  }

  void goToTaxInfo() {
    Get.toNamed(Routes.TAX_INFO);
  }

  Future<void> submitApplication() async {
    if (!canSubmit) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // TODO: Submit to API
      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Close loading dialog
      
      Get.snackbar(
        'Success',
        'Your application has been submitted for review',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to pending verification screen
      Get.offAllNamed('/verification-pending');
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to submit application. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
