import 'package:get/get.dart';
import '../controllers/onboarding_completion_controller.dart';

class OnboardingCompletionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingCompletionController>(
      () => OnboardingCompletionController(),
    );
  }
}
