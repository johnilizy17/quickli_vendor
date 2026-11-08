import 'package:get/get.dart';
import '../controllers/operating_hours_controller.dart';

class OperatingHoursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OperatingHoursController>(
      () => OperatingHoursController(),
    );
  }
}
