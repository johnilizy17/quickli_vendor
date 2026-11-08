import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../services/registration_api_service.dart';

class BusinessProfileController extends GetxController {
  final _apiService = RegistrationApiService();
  final _imagePicker = ImagePicker();

  final businessNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final supportEmailController = TextEditingController();

  final isLoading = false.obs;
  final isUploadingLogo = false.obs;
  final isUploadingCover = false.obs;
  final businessId = ''.obs;
  final businessName = ''.obs;
  final description = ''.obs;
  final contactPhone = ''.obs;
  final supportEmail = ''.obs;
  final businessCategory = ''.obs;
  final logoUrl = ''.obs;
  final coverImageUrl = ''.obs;
  final location = 'Lagos, Nigeria'.obs;

  @override
  void onInit() {
    super.onInit();
    loadBusinessProfile();
  }

  @override
  void onClose() {
    businessNameController.dispose();
    descriptionController.dispose();
    contactPhoneController.dispose();
    supportEmailController.dispose();
    super.onClose();
  }

  Future<void> loadBusinessProfile() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getVendorBusiness();
      
      if (response != null) {
        final business = response['data'] ?? response;
        businessId.value = business['_id'] ?? '';
        businessName.value = business['name'] ?? '';
        description.value = business['description'] ?? '';
        contactPhone.value = business['phone'] ?? '';
        supportEmail.value = business['email'] ?? '';
        businessCategory.value = business['category'] ?? 'Restaurant';
        logoUrl.value = business['logo'] ?? '';
        coverImageUrl.value = business['coverImage'] ?? '';

        // Set text controllers
        businessNameController.text = businessName.value;
        descriptionController.text = description.value;
        contactPhoneController.text = contactPhone.value;
        supportEmailController.text = supportEmail.value;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load business profile',
          snackPosition: SnackPosition.BOTTOM);
      print('Error loading business profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;

      if (businessId.value.isEmpty) {
        Get.snackbar('Error', 'Business ID not found',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final response = await _apiService.updateBusinessDetails(
        businessId.value,
        {
          'name': businessNameController.text,
          'description': descriptionController.text,
          'phone': contactPhoneController.text,
          'email': supportEmailController.text,
        },
      );

      if (response != null) {
        Get.snackbar('Success', 'Business profile updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100);
        Get.back();
        await loadBusinessProfile();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update business profile',
          snackPosition: SnackPosition.BOTTOM);
      print('Error updating business profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToEditProfile() {
    Get.toNamed('/business-profile/edit');
  }

  void goToBadgeDetails() {
    Get.snackbar('Badge Details', 'Coming soon',
        snackPosition: SnackPosition.BOTTOM);
  }

  void goToOperatingHours() {
    Get.toNamed('/business-profile/operating-hours');
  }

  void goToDeliveryPickup() {
    Get.toNamed('/business-profile/delivery-pickup');
  }

  void goToBusinessLogo() {
    Get.toNamed('/business-profile/logo');
  }

  void goToCoverImage() {
    Get.toNamed('/business-profile/cover');
  }

  Future<void> uploadLogo() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      isUploadingLogo.value = true;

      // Upload image to server
      final uploadedUrl = await _apiService.uploadFile(
        File(image.path),
        folder: 'business/logos',
      );

      if (uploadedUrl != null && businessId.value.isNotEmpty) {
        // Update business with new logo
        final response = await _apiService.updateBusinessDetails(
          businessId.value,
          {'logo': uploadedUrl},
        );

        if (response != null) {
          logoUrl.value = uploadedUrl;
          Get.snackbar('Success', 'Logo updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade100);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload logo',
          snackPosition: SnackPosition.BOTTOM);
      print('Error uploading logo: $e');
    } finally {
      isUploadingLogo.value = false;
    }
  }

  Future<void> removeLogo() async {
    try {
      if (businessId.value.isEmpty) return;

      isUploadingLogo.value = true;

      final response = await _apiService.updateBusinessDetails(
        businessId.value,
        {'logo': ''},
      );

      if (response != null) {
        logoUrl.value = '';
        Get.snackbar('Success', 'Logo removed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove logo',
          snackPosition: SnackPosition.BOTTOM);
      print('Error removing logo: $e');
    } finally {
      isUploadingLogo.value = false;
    }
  }

  Future<void> uploadCover() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      isUploadingCover.value = true;

      // Upload image to server
      final uploadedUrl = await _apiService.uploadFile(
        File(image.path),
        folder: 'business/covers',
      );

      if (uploadedUrl != null && businessId.value.isNotEmpty) {
        // Update business with new cover image
        final response = await _apiService.updateBusinessDetails(
          businessId.value,
          {'coverImage': uploadedUrl},
        );

        if (response != null) {
          coverImageUrl.value = uploadedUrl;
          Get.snackbar('Success', 'Cover image updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade100);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload cover image',
          snackPosition: SnackPosition.BOTTOM);
      print('Error uploading cover: $e');
    } finally {
      isUploadingCover.value = false;
    }
  }

  Future<void> removeCover() async {
    try {
      if (businessId.value.isEmpty) return;

      isUploadingCover.value = true;

      final response = await _apiService.updateBusinessDetails(
        businessId.value,
        {'coverImage': ''},
      );

      if (response != null) {
        coverImageUrl.value = '';
        Get.snackbar('Success', 'Cover image removed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove cover image',
          snackPosition: SnackPosition.BOTTOM);
      print('Error removing cover: $e');
    } finally {
      isUploadingCover.value = false;
    }
  }
}
