import 'package:get/get.dart';
import '../controllers/owner_verification_controller.dart';

class OwnerVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerVerificationController>(
      () => OwnerVerificationController(),
    );
  }
}
