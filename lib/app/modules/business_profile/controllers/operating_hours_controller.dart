import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../constants/api_route.dart';
import '../../../utils/app_logger.dart';
import '../../../models/vendor_user.dart';
import '../../onboarding_completion/controllers/onboarding_completion_controller.dart';
import '../../home/controllers/home_controller.dart';

class OperatingHoursController extends GetxController {
  final _apiService = ApiService.to;

  // Observable for loading state
  final isLoading = false.obs;
  final businessId = ''.obs;
  final outletId = ''.obs;

  // Days of the week
  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  // Operating hours for each day
  final operatingHours = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize with default hours
    for (var day in days) {
      operatingHours[day] = {
        'isOpen': day != 'Sun', // All days open except Sunday by default
        'openTime': '08:00 AM',
        'closeTime': '10:00 PM',
      };
    }
    
    // Load saved hours (this will also get businessId and outletId)
    loadOperatingHours();
  }

  @override
  void onReady() {
    super.onReady();
    // Reload when page becomes active
    loadOperatingHours();
  }

  Future<void> loadOperatingHours() async {
    try {
      appLog('[HOURS] Loading operating hours...');
      
      final response = await _apiService.get(ApiRoute.getVendorBusiness);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success' && data['data'] != null) {
          final businessData = data['data'];
          
          // Store business ID
          if (businessData['_id'] != null) {
            businessId.value = businessData['_id'];
            appLog('[HOURS] Business ID: ${businessId.value}');
          }

          // Load operating hours from outlets array (HQ outlet)
          if (businessData['outlets'] != null && businessData['outlets'] is List) {
            final outlets = businessData['outlets'] as List;
            if (outlets.isNotEmpty) {
              // Find HQ outlet or use first outlet
              final hqOutlet = outlets.firstWhere(
                (outlet) => outlet['isHq'] == true,
                orElse: () => outlets.first,
              );
              
              // Store outlet ID
              if (hqOutlet['_id'] != null) {
                outletId.value = hqOutlet['_id'];
                appLog('[HOURS] Outlet ID: ${outletId.value}');
              }
              
              // Load openingHours if available
              if (hqOutlet['openingHours'] != null && hqOutlet['openingHours'] is List) {
                final hours = hqOutlet['openingHours'] as List;
                
                appLog('[HOURS] Found opening hours data: $hours');
                
                // Convert from array format to map format
                for (var hourEntry in hours) {
                  final day = hourEntry['day'];
                  final dayShort = _getDayShortForm(day);
                  
                  if (dayShort != null && days.contains(dayShort)) {
                    operatingHours[dayShort] = {
                      'isOpen': hourEntry['isOpen'] ?? true,
                      'openTime': hourEntry['open'] ?? '08:00 AM',
                      'closeTime': hourEntry['close'] ?? '10:00 PM',
                    };
                  }
                }
                
                operatingHours.refresh();
                appLog('[HOURS] ✅ Operating hours loaded successfully');
              } else {
                appLog('[HOURS] ℹ️ No operating hours found, using defaults');
              }
            } else {
              appLog('[HOURS] ⚠️ No outlets found in business data');
            }
          } else {
            appLog('[HOURS] ⚠️ No outlets array in business data');
          }
        }
      }
    } catch (e) {
      appLog('[HOURS] ❌ Error loading hours: $e');
    }
  }
  
  String? _getDayShortForm(String fullDay) {
    const dayMap = {
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
      'Sunday': 'Sun',
    };
    return dayMap[fullDay];
  }
  
  String _getDayFullForm(String shortDay) {
    const dayMap = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };
    return dayMap[shortDay] ?? shortDay;
  }

  void toggleDay(String day) {
    final currentState = operatingHours[day]!['isOpen'];
    operatingHours[day]!['isOpen'] = !currentState;
    operatingHours.refresh();
  }

  Future<void> selectOpenTime(BuildContext context, String day) async {
    final currentTime = _parseTime(operatingHours[day]!['openTime']);
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      operatingHours[day]!['openTime'] = _formatTime(picked);
      operatingHours.refresh();
    }
  }

  Future<void> selectCloseTime(BuildContext context, String day) async {
    final currentTime = _parseTime(operatingHours[day]!['closeTime']);
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      operatingHours[day]!['closeTime'] = _formatTime(picked);
      operatingHours.refresh();
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1] == 'PM';

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> saveOperatingHours() async {
    if (businessId.value.isEmpty || outletId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Business or Outlet not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Convert to API format (array of day objects)
      final hoursArray = <Map<String, dynamic>>[];
      for (var day in days) {
        final dayFull = _getDayFullForm(day);
        hoursArray.add({
          'day': dayFull,
          'isOpen': operatingHours[day]!['isOpen'],
          'open': operatingHours[day]!['openTime'],
          'close': operatingHours[day]!['closeTime'],
        });
      }

      appLog('[HOURS] Saving operating hours for outlet: ${outletId.value}');
      appLog('[HOURS] Hours data: $hoursArray');
      
      final response = await _apiService.put(
        '/business/${businessId.value}/outlets/${outletId.value}',
        data: {
          'openingHours': hoursArray,
        },
      );

      if (response.statusCode == 200) {
        appLog('[HOURS] ✅ Operating hours saved successfully');
        appLog('[HOURS] Response: ${response.data}');

        // Refresh the onboarding completion controller if it exists
        try {
          final onboardingController = Get.find<OnboardingCompletionController>();
          await onboardingController.refreshStatus();
          appLog('[HOURS] Refreshed onboarding controller');
        } catch (e) {
          appLog('[HOURS] Onboarding controller not found, skipping refresh');
        }

        // Refresh the home controller if it exists
        try {
          final homeController = Get.find<HomeController>();
          await homeController.fetchDashboardData();
          appLog('[HOURS] Refreshed home controller');
        } catch (e) {
          appLog('[HOURS] Home controller not found, skipping refresh');
        }

        Get.snackbar(
          'Success',
          'Operating hours updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Go back
        Get.back();
      } else {
        throw Exception('Failed to save hours: ${response.statusCode}');
      }
    } catch (e) {
      appLog('[HOURS] ❌ Error saving hours: $e');
      Get.snackbar(
        'Error',
        'Failed to save operating hours: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
