import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/badge_controller.dart';

class BadgeView extends GetView<BadgeController> {
  const BadgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.lightestGrey,
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
          'Badge Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Badge Details',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Scale the ranks of Quickli Vendors. Higher badges unlock more commissions, Higher visibility, and exclusive growth tools.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Points Breakdown Link
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to points breakdown
                    },
                    child: Row(
                      children: [
                        Text(
                          'Points breakdown',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.brandColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12.sp,
                          color: ColorConstant.brandColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Current Badge Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Badge Icon
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Obx(() => Text(
                        controller.currentBadge.value[0],
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey.shade600,
                        ),
                      )),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  // Badge Name
                  Obx(() => Text(
                    controller.currentBadge.value,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                  )),
                  SizedBox(height: 4.h),
                  
                  // Points Display
                  Obx(() => Text(
                    '${controller.currentPoints.value} of ${controller.nextBadgePoints.value} Points',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  )),
                  SizedBox(height: 16.h),
                  
                  // Progress Bar
                  Obx(() => Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: LinearProgressIndicator(
                          value: controller.progressPercentage,
                          minHeight: 8.h,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstant.brandColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${controller.pointsRemaining} points to next badge',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // How to earn points
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'How to earn points',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.samantic,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Points List
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildPointItem('✓', 'Get 10 Offline to Online Milestone'),
                  SizedBox(height: 12.h),
                  _buildPointItem('✓', '100 Fulfilled Store Milestones'),
                  SizedBox(height: 12.h),
                  _buildPointItem('✓', '100 Fulfilled Order Milestones'),
                  SizedBox(height: 12.h),
                  _buildPointItem('✓', '5 Share Listing'),
                  SizedBox(height: 12.h),
                  _buildPointItem('✓', 'Below 4 Digit Rating'),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Progression Pathway
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Progression Pathway',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.samantic,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Badge Tiers List
            Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.badges.length,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemBuilder: (context, index) {
                final badge = controller.badges[index];
                return _buildBadgeTile(badge);
              },
            )),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPointItem(String icon, String text) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              icon,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorConstant.samantic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeTile(Map<String, dynamic> badge) {
    final isLocked = badge['status'] == 'LOCKED';
    final isCurrent = badge['status'] == 'CURRENT';
    final isInProgress = badge['status'] == 'IN PROGRESS';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCurrent 
              ? ColorConstant.brandColor 
              : Colors.grey.shade200,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Badge Icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Color(badge['color']).withOpacity(isLocked ? 0.3 : 1.0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badge['icon'],
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              
              // Badge Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          badge['name'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        if (isCurrent) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.brandColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'CURRENT',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        if (isInProgress) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'IN PROGRESS',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      badge['description'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Lock Icon
              if (isLocked)
                Icon(
                  Icons.lock_outline,
                  size: 20.sp,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Benefits List
          ...badge['benefits'].map<Widget>((benefit) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Icon(
                      Icons.check_circle,
                      size: 16.sp,
                      color: isLocked 
                          ? Colors.grey.shade400 
                          : Colors.green,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      benefit,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isLocked 
                            ? Colors.grey.shade500 
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
