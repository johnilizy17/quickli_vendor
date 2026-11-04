import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final storeName       = TextEditingController();
  final storePhone      = TextEditingController();
  final storeEmail      = TextEditingController();
  final storeAddress    = TextEditingController();
  final isLoading       = false.obs;
  final notificationsOn = true.obs;

  // TODO: fetch outlet info, updateOutlet, updateOpeningHours

  @override
  void onClose() {
    storeName.dispose();
    storePhone.dispose();
    storeEmail.dispose();
    storeAddress.dispose();
    super.onClose();
  }
}
