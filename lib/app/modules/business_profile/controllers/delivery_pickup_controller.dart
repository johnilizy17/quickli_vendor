import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/registration_api_service.dart';

class DeliveryPickupController extends GetxController {
  final _apiService = RegistrationApiService();

  final isLoading = false.obs;
  final businessId = ''.obs;

  // Settings
  final deliveryEnabled = true.obs;
  final pickupEnabled = true.obs;
  final deliveryRadius = 8.obs; // km
  final minimumOrder = 2000.0.obs; // ₦
  final prepBuffer = 5.obs; // minutes
  final pickupLeadTime = 15.obs; // minutes

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      print('[DELIVERY] Loading delivery settings...');
      final response = await _apiService.getVendorBusiness();

      if (response == null) {
        print('[DELIVERY] ⚠️ No response from API');
        return;
      }

      // Handle different response formats
      Map<String, dynamic>? businessData;

      if (response['data'] != null) {
        businessData = response['data'];
      } else if (response['_id'] != null) {
        businessData = response;
      }

      if (businessData == null) {
        print('[DELIVERY] ⚠️ No business data in response');
        return;
      }

      // Store business ID
      if (businessData['_id'] != null) {
        businessId.value = businessData['_id'];
      }

      // Load delivery settings if available
      if (businessData['deliverySettings'] != null) {
        final settings = businessData['deliverySettings'] as Map<String, dynamic>;

        if (settings['deliveryEnabled'] != null) {
          deliveryEnabled.value = settings['deliveryEnabled'];
        }

        if (settings['pickupEnabled'] != null) {
          pickupEnabled.value = settings['pickupEnabled'];
        }

        if (settings['deliveryRadius'] != null) {
          deliveryRadius.value = (settings['deliveryRadius'] as num).toInt();
        }

        if (settings['minimumOrder'] != null) {
          minimumOrder.value = (settings['minimumOrder'] as num).toDouble();
        }

        if (settings['prepBuffer'] != null) {
          prepBuffer.value = (settings['prepBuffer'] as num).toInt();
        }

        if (settings['pickupLeadTime'] != null) {
          pickupLeadTime.value = (settings['pickupLeadTime'] as num).toInt();
        }

        print('[DELIVERY] ✅ Delivery settings loaded');
      }
    } catch (e) {
      print('[DELIVERY] ❌ Error loading settings: $e');
    }
  }

  void toggleDelivery(bool value) {
    deliveryEnabled.value = value;
  }

  void togglePickup(bool value) {
    pickupEnabled.value = value;
  }

  Future<void> saveSettings() async {
    if (businessId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Business not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final settingsData = {
        'deliveryEnabled': deliveryEnabled.value,
        'pickupEnabled': pickupEnabled.value,
        'deliveryRadius': deliveryRadius.value,
        'minimumOrder': minimumOrder.value,
        'prepBuffer': prepBuffer.value,
        'pickupLeadTime': pickupLeadTime.value,
      };

      print('[DELIVERY] Saving delivery settings...');
      await _apiService.updateBusinessDetails(businessId.value, {
        'deliverySettings': settingsData,
      });

      print('[DELIVERY] ✅ Delivery settings saved successfully');

      Get.snackbar(
        'Success',
        'Delivery settings updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Go back
      Get.back();
    } catch (e) {
      print('[DELIVERY] ❌ Error saving settings: $e');
      Get.snackbar(
        'Error',
        'Failed to save delivery settings: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
