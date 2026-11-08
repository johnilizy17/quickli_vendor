import 'package:get/get.dart';
import '../controllers/business_documents_controller.dart';

class BusinessDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessDocumentsController>(() => BusinessDocumentsController());
  }
}
