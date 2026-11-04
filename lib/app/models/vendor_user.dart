import 'package:get/get.dart';

/// Global reactive state for the signed-in vendor.
class VendorUser {
  static RxString userId       = ''.obs;
  static RxString userEmail    = ''.obs;
  static RxString userPhone    = ''.obs;
  static RxString userFullname = ''.obs;
  static RxString userRole     = ''.obs;
  static RxString outletId     = ''.obs;
  static RxString outletName   = ''.obs;
  static RxBool   isOnline     = false.obs;
  static RxString accessToken  = ''.obs;
  static RxString refreshToken = ''.obs;
  static RxDouble walletBalance= 0.0.obs;
  
  // Verification fields
  static RxString kycStatus = ''.obs; // 'pending' | 'unverified' | 'requested' | 'verified' | 'rejected'
  static RxBool isFullyVerified = false.obs;
  static RxList<String> verificationStepsCompleted = <String>[].obs;

  static void setUser(Map<String, dynamic> data) {
    userId.value       = data['_id']?.toString()         ?? '';
    userEmail.value    = data['email']?.toString()       ?? '';
    userPhone.value    = data['phone']?.toString()       ?? '';
    userFullname.value = data['fullname']?.toString()    ?? '';
    userRole.value     = data['role']?.toString()        ?? '';
    accessToken.value  = data['accessToken']?.toString() ?? '';
    refreshToken.value = data['refreshToken']?.toString()?? '';
    isOnline.value     = data['online']  as bool? ?? false;

    final outlet = data['outlet'];
    if (outlet is Map) {
      outletId.value   = outlet['_id']?.toString()  ?? '';
      outletName.value = outlet['name']?.toString() ?? '';
    }

    final wallet = data['wallet'];
    if (wallet is Map) {
      walletBalance.value = (wallet['balance'] as num?)?.toDouble() ?? 0.0;
    }
    
    // Parse verification data
    final verification = data['verification'];
    if (verification is Map) {
      kycStatus.value = verification['kycStatus']?.toString() ?? 'pending';
      isFullyVerified.value = verification['isFullyVerified'] as bool? ?? false;
      
      final steps = verification['verificationStepsCompleted'];
      if (steps is List) {
        verificationStepsCompleted.value = steps.map((e) => e.toString()).toList();
      }
    }
  }

  static void clear() {
    userId.value = userEmail.value = userPhone.value =
        userFullname.value = userRole.value =
        outletId.value = outletName.value =
        accessToken.value = refreshToken.value = '';
    isOnline.value    = false;
    walletBalance.value = 0.0;
    kycStatus.value = '';
    isFullyVerified.value = false;
    verificationStepsCompleted.clear();
  }
}
