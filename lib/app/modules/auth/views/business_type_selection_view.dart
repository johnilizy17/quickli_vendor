import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/image_constant.dart';
import '../controllers/business_info_controller.dart';

class BusinessTypeSelectionView extends GetView<BusinessInfoController> {
  const BusinessTypeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: Column(
        children: [
          // Header with SafeArea
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 20.sp,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business information',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Tell customers about your business',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: ColorConstant.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What type of business?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Restaurant option
                  Obx(() => _BusinessTypeCard(
                    image: ImageConstant.plate,
                    title: 'Restaurant',
                    subtitle: 'Full-service or quick-service dining',
                    isSelected: controller.selectedBusinessType.value == 'restaurant',
                    onTap: () {
                      controller.selectBusinessType('restaurant');
                    },
                  )),
                  SizedBox(height: 16.h),

                  // Grocery / Supermarket option
                  Obx(() => _BusinessTypeCard(
                    image: ImageConstant.basket,
                    title: 'Grocery / Supermarket',
                    subtitle: 'Fresh produce and household items',
                    isSelected: controller.selectedBusinessType.value == 'grocery',
                    onTap: () {
                      controller.selectBusinessType('grocery');
                    },
                  )),

                  SizedBox(height: 80.h), // Space for button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
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
          child: Obx(() => GestureDetector(
            onTap: controller.selectedBusinessType.value.isNotEmpty && !controller.isLoading.value
                ? () {
                    controller.saveBusinessTypeAndContinue();
                  }
                : null,
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: controller.selectedBusinessType.value.isNotEmpty && !controller.isLoading.value
                    ? ColorConstant.brandColor
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          )),
        ),
      ),
    );
  }
}

class _BusinessTypeCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _BusinessTypeCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isSelected,
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
          border: Border.all(
            color: isSelected
                ? ColorConstant.brandColor
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 24.w,
              height: 24.w,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 2.h),
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
            SizedBox(width: 12.w),
            // Radio indicator
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? ColorConstant.brandColor
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected
                    ? ColorConstant.brandColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
