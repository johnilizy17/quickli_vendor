import 'package:get/get.dart';
import '../../../constants/api_route.dart';
import '../../../models/vendor_user.dart';
import '../../../services/api_service.dart';
import '../../../utils/app_logger.dart';

class HomeController extends GetxController {
  final _apiService = ApiService.to;
  
  // Profile
  final businessName = ''.obs;
  final businessId = ''.obs;
  final outletId = ''.obs;
  final businessLogo = ''.obs; // URL to business logo
  final hasNewNotifications = false.obs;
  
  // Availability
  final isAvailable = true.obs;
  
  // Stats
  final todayRevenue = RxDouble(0.0);
  final revenueChangePercent = RxDouble(0.0);
  final ordersToday = RxInt(0);
  final orderChange = RxInt(0);
  final avgRating = RxDouble(0.0);
  final ratingChange = RxDouble(0.0);
  final completionRate = RxDouble(0.0);
  final completionRateChange = RxDouble(0.0);
  
  // Orders
  final newOrders = <Map<String, dynamic>>[].obs;
  final recentActivities = <Map<String, dynamic>>[].obs;
  
  // Banners - Conditional based on data completeness
  final showContractBanner = false.obs;
  final showProfileCompletionBanner = false.obs;
  final showDocumentsBanner = false.obs;
  final contractCreatedAt = ''.obs;
  final productsAdded = RxInt(0);
  final hoursConfigured = false.obs;
  
  // Loading
  final isLoading = true.obs;
  final isRefreshing = false.obs;

  // Computed greeting with actual user name
  String get greetingText {
    final hour = DateTime.now().hour;
    final name = VendorUser.userFullname.value.split(' ').first;
    final greeting = hour < 12 
      ? 'Good morning' 
      : hour < 17 
        ? 'Good afternoon' 
        : 'Good evening';
    
    return name.isNotEmpty ? '$greeting, $name' : greeting;
  }
  
  // Check if vendor needs to complete onboarding
  RxBool get needsOnboarding {
    final contractNotSigned = showContractBanner.value;
    final notEnoughProducts = productsAdded.value < 5;
    final hoursNotConfigured = !hoursConfigured.value;
    
    return (contractNotSigned || notEnoughProducts || hoursNotConfigured).obs;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    fetchDashboardData();
  }
  
  void _initializeData() {
    // Load data from VendorUser
    businessName.value = VendorUser.outletName.value;
    outletId.value = VendorUser.outletId.value;
    appLog('HomeController: businessName=${businessName.value}, outletId=${outletId.value}');
  }
  
  void toggleAvailability(bool value) async {
    try {
      isAvailable.value = value;
      // Call API to update availability status
      await _apiService.post(ApiRoute.toggleOutletOnline, data: {
        'online': value,
      });
      Get.snackbar(
        'Success',
        value ? 'You are now online and accepting orders' : 'You are now offline',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Revert on error
      isAvailable.value = !value;
      appLog('HomeController: Error toggling availability: $e');
      Get.snackbar('Error', 'Failed to update availability');
    }
  }
  
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      
      // Fetch profile and business data
      await _fetchProfileData();
      
      // Fetch metrics if we have businessId
      if (businessId.value.isNotEmpty) {
        await _fetchMetrics();
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      appLog('HomeController: Error fetching dashboard data: $e');
      Get.snackbar('Error', 'Failed to load dashboard data');
    }
  }
  
  Future<void> _fetchProfileData() async {
    try {
      final response = await _apiService.get(ApiRoute.userProfile);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          final vendor = data['data'];
          
          // Update vendor user
          VendorUser.setUser(vendor);
          
          businessName.value = VendorUser.outletName.value;
          outletId.value = VendorUser.outletId.value;
          
          // Check for banners
          _checkBannerConditions(vendor);
        }
      }
      
      // Fetch business profile to get businessId and more details
      final businessResponse = await _apiService.get(ApiRoute.getVendorBusiness);
      if (businessResponse.statusCode == 200) {
        final businessData = businessResponse.data;
        if (businessData['status'] == 'success' && businessData['data'] != null) {
          final business = businessData['data'];
          businessId.value = business['_id'] ?? '';
          
          // Get business logo
          businessLogo.value = business['logo'] ?? business['logoUrl'] ?? '';
          
          // Check contract status
          final contract = business['contract'];
          if (contract != null && contract['signed'] == false) {
            showContractBanner.value = true;
            contractCreatedAt.value = business['createdAt'] ?? '';
          }
          
          // Check products count from business data
          if (business['productsCount'] != null) {
            productsAdded.value = business['productsCount'];
          }
          
          // Check operating hours from business data
          final hours = business['operatingHours'];
          if (hours != null && hours is Map && hours.isNotEmpty) {
            // Check if at least one day is configured
            bool hasConfiguredDay = false;
            for (var entry in hours.entries) {
              if (entry.value is Map && entry.value['isOpen'] == true) {
                hasConfiguredDay = true;
                break;
              }
            }
            hoursConfigured.value = hasConfiguredDay;
          } else {
            hoursConfigured.value = false;
          }
        }
      }
    } catch (e) {
      appLog('HomeController: Error fetching profile data: $e');
    }
  }
  
  Future<void> _fetchMetrics() async {
    try {
      final url = ApiRoute.businessOutletsMetrics(businessId.value);
      final response = await _apiService.get(url);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          final metrics = data['data'];
          
          // Parse stats with safe casting
          todayRevenue.value = _parseDouble(metrics['todayRevenue']);
          revenueChangePercent.value = _parseDouble(metrics['revenueChange']);
          ordersToday.value = _parseInt(metrics['ordersToday']);
          orderChange.value = _parseInt(metrics['orderChange']);
          avgRating.value = _parseDouble(metrics['avgRating']);
          ratingChange.value = _parseDouble(metrics['ratingChange']);
          completionRate.value = _parseDouble(metrics['completionRate']);
          completionRateChange.value = _parseDouble(metrics['completionRateChange']);
          
          // Parse recent activities
          if (metrics['recentActivity'] is List) {
            recentActivities.value = List<Map<String, dynamic>>.from(
              (metrics['recentActivity'] as List).map((item) => Map<String, dynamic>.from(item))
            );
          }
          
          // Parse new orders (pending orders)
          if (metrics['pendingOrders'] is List) {
            newOrders.value = List<Map<String, dynamic>>.from(
              (metrics['pendingOrders'] as List).map((item) => Map<String, dynamic>.from(item))
            );
          }
          
          appLog('HomeController: Metrics loaded successfully');
        }
      }
    } catch (e) {
      appLog('HomeController: Error fetching metrics: $e');
    }
  }
  
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
  
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  
  void _checkBannerConditions(Map<String, dynamic> vendor) {
    // Check if profile is incomplete
    final verification = vendor['verification'];
    if (verification != null) {
      final stepsData = verification['verificationStepsCompleted'];
      List<String> steps = [];
      
      if (stepsData is List) {
        steps = stepsData.map((e) => e.toString()).toList();
      } else if (stepsData is String) {
        steps = [stepsData];
      }
      
      if (steps.length < 3) {
        showProfileCompletionBanner.value = true;
      }
    }
    
    // Check if documents are missing
    final documents = vendor['documents'];
    if (documents == null || (documents is Map && documents.isEmpty)) {
      showDocumentsBanner.value = true;
    }
    
    // Check products count
    productsAdded.value = vendor['productsCount'] ?? 0;
    
    // Check operating hours
    final hours = vendor['operatingHours'];
    if (hours != null && hours is Map && hours.isNotEmpty) {
      hoursConfigured.value = true;
    }
  }
  
  Future<void> refreshData() async {
    isRefreshing.value = true;
    await fetchDashboardData();
    isRefreshing.value = false;
  }
  
  void acceptOrder(String orderId) async {
    try {
      await _apiService.post(ApiRoute.acceptOrder(orderId));
      newOrders.removeWhere((order) => order['_id'] == orderId);
      Get.snackbar('Success', 'Order accepted');
    } catch (e) {
      appLog('HomeController: Error accepting order: $e');
      Get.snackbar('Error', 'Failed to accept order');
    }
  }
  
  void rejectOrder(String orderId) async {
    try {
      await _apiService.post(ApiRoute.rejectOrder(orderId));
      newOrders.removeWhere((order) => order['_id'] == orderId);
      Get.snackbar('Success', 'Order rejected');
    } catch (e) {
      appLog('HomeController: Error rejecting order: $e');
      Get.snackbar('Error', 'Failed to reject order');
    }
  }
  
  void goToOrders() {
    Get.toNamed('/orders');
  }
  
  void goToProducts() {
    Get.toNamed('/products');
  }
  
  void goToNotifications() {
    Get.toNamed('/notifications');
  }
  
  void goToBusinessProfile() {
    Get.toNamed('/business-profile');
  }
}
