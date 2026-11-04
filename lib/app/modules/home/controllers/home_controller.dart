import 'package:get/get.dart';

class HomeController extends GetxController {
  final isOnline         = false.obs;
  final pendingCount     = 0.obs;
  final todayOrderCount  = 0.obs;
  final todayRevenue     = 0.0.obs;
  final isLoading        = true.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO: fetch dashboard summary
  }
}
