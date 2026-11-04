import 'package:get/get.dart';
import '../../../models/vendor_user.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;

  String get fullname => VendorUser.userFullname.value;
  String get email    => VendorUser.userEmail.value;
  String get phone    => VendorUser.userPhone.value;
  String get outlet   => VendorUser.outletName.value;

  void signOut() {
    VendorUser.clear();
    // TODO: clear tokens and navigate to auth
  }
}
