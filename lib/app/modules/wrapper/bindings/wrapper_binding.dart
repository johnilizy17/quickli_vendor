import 'package:get/get.dart';
import '../controllers/wrapper_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../products/controllers/products_controller.dart';
import '../../earnings/controllers/earnings_controller.dart';
import '../../menu/controllers/menu_controller.dart';

class WrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WrapperController>(() => WrapperController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<ProductsController>(() => ProductsController());
    Get.lazyPut<EarningsController>(() => EarningsController());
    Get.lazyPut<VendorMenuController>(() => VendorMenuController());
  }
}
