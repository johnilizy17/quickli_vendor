import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorConstant.samantic),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: ColorConstant.samantic,
              ),
            ),
            Obx(() => controller.unreadCount.value > 0
              ? Text(
                  '${controller.unreadCount.value} unread',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorConstant.darkGrey,
                  ),
                )
              : SizedBox.shrink()),
          ],
        ),
        actions: [
          Obx(() => controller.unreadCount.value > 0
            ? TextButton(
                onPressed: controller.markAllAsRead,
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.brandColor,
                  ),
                ),
              )
            : SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() => Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: controller.currentFilter.value == NotificationFilter.all,
                    onTap: () => controller.changeFilter(NotificationFilter.all),
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: 'Unread',
                    isSelected: controller.currentFilter.value == NotificationFilter.unread,
                    onTap: () => controller.changeFilter(NotificationFilter.unread),
                    count: controller.unreadCount.value,
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: 'Orders',
                    isSelected: controller.currentFilter.value == NotificationFilter.orders,
                    onTap: () => controller.changeFilter(NotificationFilter.orders),
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: 'Payouts',
                    isSelected: controller.currentFilter.value == NotificationFilter.payouts,
                    onTap: () => controller.changeFilter(NotificationFilter.payouts),
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: 'Reviews',
                    isSelected: controller.currentFilter.value == NotificationFilter.reviews,
                    onTap: () => controller.changeFilter(NotificationFilter.reviews),
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: 'System',
                    isSelected: controller.currentFilter.value == NotificationFilter.system,
                    onTap: () => controller.changeFilter(NotificationFilter.system),
                  ),
                ],
              )),
            ),
          ),
          
          // Notifications list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: ColorConstant.brandColor),
                );
              }
              
              if (controller.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none_outlined,
                        size: 64.sp,
                        color: ColorConstant.lightGrey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No notifications',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.samantic,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'You\'re all caught up!',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.darkGrey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                color: ColorConstant.brandColor,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: controller.notifications.length + (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Load more indicator
                    if (index == controller.notifications.length) {
                      if (controller.hasMore.value) {
                        controller.loadMore();
                        return Padding(
                          padding: EdgeInsets.all(16.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorConstant.brandColor,
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }
                    
                    final notification = controller.notifications[index];
                    return _NotificationCard(
                      notification: notification,
                      onTap: () {
                        controller.markAsRead(notification['_id']);
                        // TODO: Navigate to relevant screen based on notification type
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstant.brandColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? ColorConstant.brandColor : ColorConstant.lightGrey,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : ColorConstant.samantic,
              ),
            ),
            if (count != null && count! > 0) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : ColorConstant.brandColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? ColorConstant.brandColor : Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    final isUnread = notification['read'] == false;
    final activityType = notification['activityType'] ?? '';
    final style = controller.getNotificationStyle(activityType);
    final timeAgo = controller.getTimeAgo(notification['createdAt'] ?? '');
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: isUnread 
            ? Border.all(color: ColorConstant.brandColor.withValues(alpha: 0.3), width: 2)
            : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: style['bgColor'],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                style['icon'],
                color: style['color'],
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'] ?? 'Notification',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.samantic,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: ColorConstant.brandColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification['message'] ?? '',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ColorConstant.darkGrey,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (timeAgo.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: ColorConstant.lightGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
