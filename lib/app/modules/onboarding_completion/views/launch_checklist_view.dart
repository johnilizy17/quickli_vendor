import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/onboarding_completion_controller.dart';

class LaunchChecklistView extends GetView<OnboardingCompletionController> {
  const LaunchChecklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                'Launch checklist',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.samantic,
                ),
              ),
              Text(
                'Complete these before going live',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.darkGrey,
                ),
              ),
            ],
          ),
        ),
        body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: ColorConstant.brandColor),
          );
        }
        
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshStatus,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      // Progress card
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(16.r),
                         border: Border.all(
                            color: ColorConstant.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Obx(() {
                          int completed = 0;
                          if (controller.agreementSigned.value) completed++;
                          if (controller.productsAdded.value >= 5) completed++;
                          if (controller.hoursConfigured.value) completed++;
                          final percentage = ((completed / 3) * 100).round();
                          
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$completed / 3 required tasks done',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConstant.samantic,
                                    ),
                                  ),
                                  Text(
                                    '$percentage%',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              // Progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: LinearProgressIndicator(
                                  value: completed / 3,
                                  backgroundColor: ColorConstant.lightestGrey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    completed == 3 
                                      ? Colors.green 
                                      : Colors.orange,
                                  ),
                                  minHeight: 8.h,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Checklist items in one card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: ColorConstant.lightGrey,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Obx(() => _ChecklistItemInCard(
                              emoji: '🕐',
                              title: 'Confirm operating hours',
                              subtitle: controller.hoursConfigured.value
                                ? 'Hours set Mon-Sat 08:00-22:00'
                                : 'Set your business operating hours',
                              isCompleted: controller.hoursConfigured.value,
                              isRequired: !controller.hoursConfigured.value,
                              onTap: () => Get.toNamed(Routes.OPERATING_HOURS),
                              showDivider: true,
                            )),
                            
                            Obx(() => _ChecklistItemInCard(
                              emoji: '📦',
                              title: 'Add at least 5 products',
                              subtitle: controller.productsAdded.value >= 5
                                ? '${controller.productsAdded.value} products added'
                                : 'Add a minimum of 5 products',
                              isCompleted: controller.productsAdded.value >= 5,
                              isRequired: controller.productsAdded.value < 5,
                              onTap: () => Get.toNamed(Routes.ADD_PRODUCT),
                              showDivider: true,
                            )),
                            
                            Obx(() => _ChecklistItemInCard(
                              emoji: '🤝',
                              title: 'Vendor Agreement',
                              subtitle: controller.agreementSigned.value
                                ? 'Signed and agreed'
                                : 'Must sign before you go live',
                              isCompleted: controller.agreementSigned.value,
                              isRequired: !controller.agreementSigned.value,
                              onTap: () {
                                // Open agreement modal or navigate to agreement view
                                _showAgreementDialog(context);
                              },
                              showDivider: false,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom button
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Obx(() {
                final allComplete = controller.agreementSigned.value &&
                    controller.productsAdded.value >= 5 &&
                    controller.hoursConfigured.value;
                
                if (allComplete) {
                  return GestureDetector(
                    onTap: controller.completeOnboarding,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: ColorConstant.brandColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          'Complete Setup',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                
                int remaining = 0;
                if (!controller.agreementSigned.value) remaining++;
                if (controller.productsAdded.value < 5) remaining++;
                if (!controller.hoursConfigured.value) remaining++;
                
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: ColorConstant.brandColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      '$remaining required item${remaining > 1 ? 's' : ''} remaining',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
      ),
    );
  }
  
  void _showAgreementDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ColorConstant.lightGrey),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vendor Agreement',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.samantic,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'Vendor Agreement Terms and Conditions\n\n'
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit...\n\n'
                  '1. Commission Structure\n'
                  'Lorem ipsum dolor sit amet...\n\n'
                  '2. Payment Terms\n'
                  'Lorem ipsum dolor sit amet...\n\n'
                  '3. Quality Standards\n'
                  'Lorem ipsum dolor sit amet...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstant.darkGrey,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: ColorConstant.lightGrey),
                ),
              ),
              child: Obx(() => GestureDetector(
                onTap: controller.isSigning.value 
                  ? null 
                  : () async {
                      await controller.signContract();
                      if (controller.agreementSigned.value) {
                        Get.back();
                      }
                    },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: controller.isSigning.value
                      ? ColorConstant.lightGrey
                      : ColorConstant.brandColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: controller.isSigning.value
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Sign Agreement',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItemInCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isRequired;
  final VoidCallback onTap;
  final bool showDivider;

  const _ChecklistItemInCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isRequired,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Emoji with status indicator
                Stack(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      child: Center(
                        child: Text(
                          emoji,
                          style: TextStyle(
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
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
                              title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.samantic,
                              ),
                            ),
                          ),
                          if (isRequired && !isCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'REQUIRED',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorConstant.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                
                // Arrow
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: ColorConstant.lightGrey,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: ColorConstant.lightGrey,
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isRequired;
  final VoidCallback onTap;

  const _ChecklistItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isRequired,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Icon with status indicator
            Stack(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: isCompleted
                      ? Colors.green.withValues(alpha: 0.1)
                      : ColorConstant.lightestGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: isCompleted
                      ? Colors.green
                      : ColorConstant.darkGrey,
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
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
                          title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                      ),
                      if (isRequired && !isCompleted)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'REQUIRED',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            
            // Arrow
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: ColorConstant.lightGrey,
            ),
          ],
        ),
      ),
    );
  }
}
