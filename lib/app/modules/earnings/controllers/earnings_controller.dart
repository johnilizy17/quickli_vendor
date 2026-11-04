import 'package:get/get.dart';

class EarningsController extends GetxController {
  final totalEarnings   = 0.0.obs;
  final todayEarnings   = 0.0.obs;
  final weekEarnings    = 0.0.obs;
  final monthEarnings   = 0.0.obs;
  final transactions    = [].obs;
  final isLoading       = true.obs;
  final selectedPeriod  = 'week'.obs; // today | week | month | all

  // TODO: fetch earnings summary, transactions
}
