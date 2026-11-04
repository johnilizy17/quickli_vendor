import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/business_registration_controller.dart';
import '../controllers/business_info_controller.dart';
import '../controllers/owner_verification_controller.dart';
import '../controllers/business_docs_controller.dart';
import '../controllers/bank_account_controller.dart';
import '../controllers/tax_info_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<BusinessRegistrationController>(() => BusinessRegistrationController());
    Get.lazyPut<BusinessInfoController>(() => BusinessInfoController());
    Get.lazyPut<OwnerVerificationController>(() => OwnerVerificationController());
    Get.lazyPut<BusinessDocsController>(() => BusinessDocsController());
    Get.lazyPut<BankAccountController>(() => BankAccountController());
    Get.lazyPut<TaxInfoController>(() => TaxInfoController());
  }
}
