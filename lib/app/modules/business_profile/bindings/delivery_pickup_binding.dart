import 'package:get/get.dart';
import '../controllers/delivery_pickup_controller.dart';

class DeliveryPickupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryPickupController>(
      () => DeliveryPickupController(),
    );
  }
}
