import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/api_route.dart';
import '../../../models/vendor_user.dart';
import '../../../services/api_service.dart';
import '../../../utils/app_logger.dart';

enum NotificationFilter { all, unread, orders, payouts, reviews, system }

class NotificationsController extends GetxController {
  final _apiService = ApiService.to;
  
  final notifications = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final unreadCount = 0.obs;
  final currentFilter = NotificationFilter.all.obs;
  
  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final hasMore = false.obs;
  
  // IDs
  final businessId = ''.obs;
  final outletId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeIds();
    fetchNotifications();
  }
  
  void _initializeIds() {
    // Get business and outlet IDs from vendor profile
    // We need to fetch the business profile first to get the correct IDs
    _fetchBusinessProfile();
  }
  
  Future<void> _fetchBusinessProfile() async {
    try {
      final response = await _apiService.get(ApiRoute.getVendorBusiness);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          final business = data['data'];
          businessId.value = business['_id'] ?? '';
          
          // Try to get outlet ID from the business data or use VendorUser
          outletId.value = VendorUser.outletId.value;
          
          appLog('NotificationsController: businessId=$businessId, outletId=$outletId');
        }
      }
    } catch (e) {
      appLog('NotificationsController: Error fetching business profile: $e');
      // Fallback to VendorUser data
      businessId.value = VendorUser.userId.value;
      outletId.value = VendorUser.outletId.value;
    }
  }
  
  Future<void> fetchNotifications({bool loadMore = false}) async {
    try {
      // Make sure we have businessId and outletId
      if (businessId.value.isEmpty || outletId.value.isEmpty) {
        await _fetchBusinessProfile();
        if (businessId.value.isEmpty || outletId.value.isEmpty) {
          appLog('NotificationsController: Missing businessId or outletId');
          isLoading.value = false;
          return;
        }
      }
      
      if (loadMore) {
        if (!hasMore.value) return;
        isLoadingMore.value = true;
        currentPage.value++;
      } else {
        isLoading.value = true;
        currentPage.value = 1;
        notifications.clear();
      }
      
      // Build query parameters
      final params = {
        'page': currentPage.value.toString(),
        'limit': '20',
      };
      
      // Add filter if not 'all'
      switch (currentFilter.value) {
        case NotificationFilter.unread:
          params['read'] = 'false';
          break;
        case NotificationFilter.orders:
          params['activityType'] = 'order';
          break;
        case NotificationFilter.payouts:
          params['activityType'] = 'payout';
          break;
        case NotificationFilter.reviews:
          params['activityType'] = 'review';
          break;
        case NotificationFilter.system:
          params['activityType'] = 'system_alert';
          break;
        default:
          break;
      }
      
      // Build URL with query string
      final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
      final url = '${ApiRoute.getNotifications(businessId.value, outletId.value)}?$queryString';
      
      appLog('NotificationsController: Fetching from $url');
      
      final response = await _apiService.get(url);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' || data['success'] == true) {
          final responseData = data['data'];
          
          // Handle paginated response
          if (responseData is Map && responseData['docs'] != null) {
            final docs = responseData['docs'] as List? ?? [];
            
            if (loadMore) {
              notifications.addAll(docs.map((e) => Map<String, dynamic>.from(e)).toList());
            } else {
              notifications.value = docs.map((e) => Map<String, dynamic>.from(e)).toList();
            }
            
            totalPages.value = responseData['totalPages'] ?? 1;
            hasMore.value = responseData['hasNextPage'] ?? false;
          } else if (responseData is List) {
            // Handle direct array response
            if (loadMore) {
              notifications.addAll(responseData.map((e) => Map<String, dynamic>.from(e)).toList());
            } else {
              notifications.value = responseData.map((e) => Map<String, dynamic>.from(e)).toList();
            }
            hasMore.value = false;
          }
          
          // Count unread
          _countUnread();
          
          appLog('NotificationsController: Loaded ${notifications.length} notifications');
        }
      }
      
      isLoading.value = false;
      isLoadingMore.value = false;
    } catch (e, stackTrace) {
      isLoading.value = false;
      isLoadingMore.value = false;
      appLog('NotificationsController: Error fetching notifications: $e');
      appLog('NotificationsController: StackTrace: $stackTrace');
      
      // Show error only if not loading more
      if (!loadMore) {
        Get.snackbar('Error', 'Failed to load notifications');
      }
    }
  }
  
  void _countUnread() {
    unreadCount.value = notifications.where((n) => n['read'] == false).length;
  }
  
  void changeFilter(NotificationFilter filter) {
    if (currentFilter.value != filter) {
      currentFilter.value = filter;
      fetchNotifications();
    }
  }
  
  Future<void> markAsRead(String notificationId) async {
    try {
      // Make sure we have IDs
      if (businessId.value.isEmpty || outletId.value.isEmpty) {
        return;
      }
      
      // Optimistic update
      final index = notifications.indexWhere((n) => n['_id'] == notificationId);
      if (index != -1 && notifications[index]['read'] == false) {
        notifications[index]['read'] = true;
        notifications.refresh();
        _countUnread();
      }
      
      // Call API
      await _apiService.post(
        ApiRoute.markNotificationsRead(businessId.value, outletId.value),
        data: {'ids': [notificationId]},
      );
      
      appLog('NotificationsController: Marked notification as read');
    } catch (e) {
      appLog('NotificationsController: Error marking as read: $e');
    }
  }
  
  Future<void> markAllAsRead() async {
    try {
      // Make sure we have IDs
      if (businessId.value.isEmpty || outletId.value.isEmpty) {
        return;
      }
      
      // Optimistic update
      for (var notification in notifications) {
        notification['read'] = true;
      }
      notifications.refresh();
      unreadCount.value = 0;
      
      // Call API
      await _apiService.post(
        ApiRoute.markNotificationsRead(businessId.value, outletId.value),
      );
      
      Get.snackbar('Success', 'All notifications marked as read');
      appLog('NotificationsController: Marked all as read');
    } catch (e) {
      appLog('NotificationsController: Error marking all as read: $e');
      Get.snackbar('Error', 'Failed to mark all as read');
      // Revert on error
      fetchNotifications();
    }
  }
  
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
  
  void loadMore() {
    if (!isLoadingMore.value && hasMore.value) {
      fetchNotifications(loadMore: true);
    }
  }
  
  // Get icon and color based on activity type
  Map<String, dynamic> getNotificationStyle(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'order':
        return {
          'icon': Icons.shopping_bag_outlined,
          'color': Colors.blue,
          'bgColor': Colors.blue.shade50,
        };
      case 'payout':
        return {
          'icon': Icons.payments_outlined,
          'color': Colors.green,
          'bgColor': Colors.green.shade50,
        };
      case 'review':
        return {
          'icon': Icons.star_outline,
          'color': Colors.orange,
          'bgColor': Colors.orange.shade50,
        };
      case 'account':
        return {
          'icon': Icons.person_outline,
          'color': Colors.purple,
          'bgColor': Colors.purple.shade50,
        };
      case 'document':
        return {
          'icon': Icons.description_outlined,
          'color': Colors.indigo,
          'bgColor': Colors.indigo.shade50,
        };
      case 'promotion':
        return {
          'icon': Icons.local_offer_outlined,
          'color': Colors.pink,
          'bgColor': Colors.pink.shade50,
        };
      case 'system_alert':
        return {
          'icon': Icons.notifications_outlined,
          'color': Colors.red,
          'bgColor': Colors.red.shade50,
        };
      default:
        return {
          'icon': Icons.notifications_outlined,
          'color': Colors.grey,
          'bgColor': Colors.grey.shade50,
        };
    }
  }
  
  String getTimeAgo(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(date);
      
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
      return '${(diff.inDays / 30).floor()}mo ago';
    } catch (e) {
      return '';
    }
  }
}
