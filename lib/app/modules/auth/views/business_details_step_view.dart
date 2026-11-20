import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_info_controller.dart';

class BusinessDetailsStepView extends GetView<BusinessInfoController> {
  const BusinessDetailsStepView({super.key});

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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Tell customers about your business',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstant.black,
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
                  // Display selected business type 
                  Text(
                    'Tell us about your business?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Business name
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.samantic,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: 'Business name '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.businessNameController,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.samantic,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Harbour Food',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.darkGrey.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.brandColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'This is the name customers will see',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Business description
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.samantic,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: 'Business description '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.descriptionController,
                    maxLines: 4,
                    maxLength: 300,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.samantic,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Best food around here',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.darkGrey.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.brandColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Business email
                  Text(
                    'Business email',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.samantic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.businessEmailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.samantic,
                    ),
                    decoration: InputDecoration(
                      hintText: 'info@habour.com',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.darkGrey.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.brandColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'For customer inquiries and receipts',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Website (optional)
                  Text(
                    'Website (optional)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.samantic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.websiteController,
                    keyboardType: TextInputType.url,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.samantic,
                    ),
                    decoration: InputDecoration(
                      hintText: 'habour.ng.com',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.darkGrey.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.language,
                        color: ColorConstant.brandColor,
                        size: 20.sp,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.lightGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: ColorConstant.brandColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Info banner
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF4E5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Color(0xFFD97706),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Your business name will be shown to customers. Choose something clear and recognizable.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFFD97706),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
        child: Obx(() {
          final isValid = controller.isBusinessDetailsValid.value;
          final isLoading = controller.isLoading.value;
          final isDisabled = !isValid || isLoading;
          
          print('[BUTTON] isValid: $isValid, isLoading: $isLoading, isDisabled: $isDisabled');
          
          return GestureDetector(
            onTap: isDisabled
                ? null
                : () => controller.saveBusinessDetailsAndContinue(),
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: isDisabled
                    ? const Color(0xFF9FA0B0)
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
          );
        }),
        ),
      ),
    );
  }
}
