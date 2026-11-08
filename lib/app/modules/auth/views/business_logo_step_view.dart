import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_info_controller.dart';

class BusinessLogoStepView extends GetView<BusinessInfoController> {
  const BusinessLogoStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.lightestGrey,
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
                  // Display selected business type
                  Obx(() => controller.selectedBusinessCategory.value.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.all(12.w),
                          margin: EdgeInsets.only(bottom: 20.h),
                          decoration: BoxDecoration(
                            color: ColorConstant.fadedPurpleAccent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: ColorConstant.brandColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: ColorConstant.brandColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  controller.selectedBusinessCategory.value == 'restaurant'
                                      ? Icons.restaurant_outlined
                                      : Icons.shopping_basket_outlined,
                                  color: ColorConstant.brandColor,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Business Type',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: ColorConstant.darkGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      controller.selectedBusinessCategory.value == 'restaurant'
                                          ? 'Restaurant'
                                          : 'Grocery / Supermarket',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant.brandColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: ColorConstant.brandColor,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),
                  Text(
                    'Add your logo business',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Logo preview
                  Center(
                    child: Obx(() {
                      final hasLogo = controller.logoFile.value != null || 
                                      controller.logoPath.value.isNotEmpty;
                      
                      return Container(
                        width: 200.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: hasLogo 
                                ? ColorConstant.brandColor
                                : Colors.grey.shade300,
                            width: hasLogo ? 2 : 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: hasLogo
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: controller.logoFile.value != null
                                    ? Image.file(
                                        controller.logoFile.value!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        controller.logoPath.value,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                ColorConstant.brandColor,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.broken_image_outlined,
                                                size: 48.sp,
                                                color: Colors.red.shade300,
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                'Failed to load',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.red.shade400,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 48.sp,
                                    color: ColorConstant.darkGrey.withOpacity(0.3),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Logo preview',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ColorConstant.darkGrey.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    }),
                  ),
                  SizedBox(height: 32.h),

                  // Action buttons
                  Obx(() {
                    final hasLogo = controller.logoFile.value != null || 
                                    controller.logoPath.value.isNotEmpty;
                    
                    return Column(
                      children: [
                        if (hasLogo)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.green,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Logo uploaded - Click below to replace',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.takePhotoForLogo(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 20.sp,
                                        color: ColorConstant.samantic,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Take Photo',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: ColorConstant.samantic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.pickLogo(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.brandColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.upload_outlined,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        hasLogo ? 'Replace Logo' : 'Upload Logo',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 24.h),

                  // Logo requirements
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Logo requirements:',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _RequirementItem('PNG, JPG or SVG format'),
                        _RequirementItem('Minimum 400 x 400 pixels'),
                        _RequirementItem('Square or circular works best'),
                        _RequirementItem('Max file size: 5 MB'),
                      ],
                    ),
                  ),

                  SizedBox(height: 80.h), // Space for buttons
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => GestureDetector(
              onTap: controller.isLoading.value || controller.isUploading.value
                  ? null
                  : () => controller.saveLogoAndContinue(),
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  color: controller.isLoading.value || controller.isUploading.value
                      ? ColorConstant.brandColor.withOpacity(0.6)
                      : ColorConstant.brandColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center,
                child: controller.isLoading.value || controller.isUploading.value
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
            )),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                // Skip logo and move to location step
                controller.moveToLocationStep();
              },
              child: Text(
                'Skip for now',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.samantic,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  const _RequirementItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorConstant.darkGrey,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: ColorConstant.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
