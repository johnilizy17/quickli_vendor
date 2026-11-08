import 'package:get/get.dart';
import '../controllers/ratings_reviews_controller.dart';

class RatingsReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingsReviewsController>(() => RatingsReviewsController());
  }
}
