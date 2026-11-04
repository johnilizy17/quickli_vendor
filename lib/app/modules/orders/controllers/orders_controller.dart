import 'package:get/get.dart';

class OrdersController extends GetxController {
  final orders    = [].obs;
  final isLoading = true.obs;
  final filter    = 'all'.obs; // all | pending | accepted | ready | completed | canceled

  @override
  void onInit() {
    super.onInit();
    // TODO: fetch orders
  }
}
