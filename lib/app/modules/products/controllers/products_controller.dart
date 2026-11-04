import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  final nameController        = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController       = TextEditingController();
  final isLoading             = false.obs;
  final selectedCategory      = ''.obs;
  final inStock               = true.obs;
  final images                = <String>[].obs;

  // TODO: createProduct, updateProduct, deleteProduct, uploadImage

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
