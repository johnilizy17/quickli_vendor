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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios, size: 20.sp, color: ColorConstant.samantic)),
        title: Text('Notifications', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.notifications.isEmpty) return Center(
          child: Text('No notifications', style: TextStyle(fontSize: 14.sp, color: ColorConstant.darkGrey)),
        );
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.notifications.length,
          itemBuilder: (_, i) => _NotificationCard(item: controller.notifications[i]),
        );
      }),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final dynamic item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: ColorConstant.fadedPurpleAccent,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(children: [
      Container(
        width: 40.w, height: 40.w,
        decoration: BoxDecoration(color: ColorConstant.brandColor, borderRadius: BorderRadius.circular(10.r)),
        child: Icon(Icons.notifications_rounded, color: Colors.white, size: 20.sp),
      ),
      SizedBox(width: 12.w),
      Expanded(child: Text('Notification title', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ColorConstant.samantic))),
    ]),
  );
}
