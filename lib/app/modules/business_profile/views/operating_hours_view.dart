import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/operating_hours_controller.dart';

class OperatingHoursView extends GetView<OperatingHoursController> {
  const OperatingHoursView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.sp,
            color: ColorConstant.samantic,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Operating Hours',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.loadOperatingHours,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: ColorConstant.borderColor, width: 1),
                  ),
                  child: Column(
                    children: controller.days.asMap().entries.map((entry) {
                      final index = entry.key;
                      final day = entry.value;
                      final isLastDay = index == controller.days.length - 1;

                      return Obx(() {
                        final isOpen = controller.operatingHours[day]!['isOpen'];
                        final openTime = controller.operatingHours[day]!['openTime'];
                        final closeTime = controller.operatingHours[day]!['closeTime'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day header with toggle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.samantic,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    value: isOpen,
                                    onChanged: (value) =>
                                        controller.toggleDay(day),
                                    activeColor: Colors.white,
                                    activeTrackColor: ColorConstant.brandColor,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            // Time selectors (only show if day is open)
                            if (isOpen)
                              Row(
                                children: [
                                  // Open time
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          controller.selectOpenTime(context, day),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 14.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorConstant.greyCard,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: ColorConstant.greyLight,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              openTime,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: ColorConstant.blackTin,
                                              ),
                                            ),
                                            Icon(
                                              Icons.access_time,
                                              size: 18.sp,
                                              color: ColorConstant.blackTin,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    child: Text(
                                      'to',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorConstant.lighengrey,
                                      ),
                                    ),
                                  ),

                                  // Close time
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => controller.selectCloseTime(
                                        context,
                                        day,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 14.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorConstant.greyCard,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: ColorConstant.greyLight,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              closeTime,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: ColorConstant.blackTin,
                                              ),
                                            ),
                                            Icon(
                                              Icons.access_time,
                                              size: 18.sp,
                                              color: ColorConstant.blackTin,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              // Closed text
                              Text(
                                'Closed',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),

                            // Add spacing between days, but not after the last day
                            if (!isLastDay) SizedBox(height: 20.h),
                          ],
                        );
                      });
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // Save button at bottom
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Obx(
                () => GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : () => controller.saveOperatingHours(),
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: controller.isLoading.value
                          ? ColorConstant.brandColor.withOpacity(0.6)
                          : ColorConstant.brandColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.center,
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Save Hours',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
