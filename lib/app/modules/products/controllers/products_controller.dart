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

  // Stats
  final revenue = 'N2732k'.obs;
  final revenueChange = '↑ 12% vs last week'.obs;
  final ordersCount = '1,018'.obs;
  final ordersChange = '↑ 8% vs last week'.obs;

  // Product status counts
  final activeProductsCount = 9.obs;
  final inactiveProductsCount = 1.obs;
  final outOfStockCount = 1.obs;
  final allProductsCount = 11.obs;

  // Top products this week
  final topProducts = <Map<String, dynamic>>[
    {
      'name': 'Fried Plantain (Dodo)',
      'orders': '230 orders',
      'revenue': '₦184k',
      'status': 'Active',
      'image': '',
    },
    {
      'name': 'Puff Puff (6 pcs)',
      'orders': '175 orders',
      'revenue': '₦105k',
      'status': 'Active',
      'image': '',
    },
    {
      'name': 'Jollof Rice & Chicken',
      'orders': '142 orders',
      'revenue': '₦539k',
      'status': 'Active',
      'image': '',
    },
    {
      'name': 'Suya Platter',
      'orders': '115 orders',
      'revenue': '₦437k',
      'status': 'Active',
      'image': '',
    },
    {
      'name': 'Egusi Soup & Pounded Yam',
      'orders': '98 orders',
      'revenue': '₦510k',
      'status': 'Active',
      'image': '',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    // TODO: Load from API
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }

  void manageCategory() {
    Get.snackbar('Manage Category', 'Feature coming soon',
        snackPosition: SnackPosition.BOTTOM);
  }

  void addNewProduct() {
    // Get.toNamed(Routes.ADD_PRODUCT);
    Get.snackbar('Add Product', 'Feature coming soon',
        snackPosition: SnackPosition.BOTTOM);
  }

  void viewAllProducts() {
    Get.snackbar('View All Products', 'Feature coming soon',
        snackPosition: SnackPosition.BOTTOM);
  }

  // TODO: createProduct, updateProduct, deleteProduct, uploadImage

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
