import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_info_controller.dart';
import 'dart:io';

class BusinessEvidenceStepView extends GetView<BusinessInfoController> {
  const BusinessEvidenceStepView({super.key});

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
                    'Evidence Collection',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Upload photos for each required category. Click any card to upload a photo.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ColorConstant.darkGrey,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Progress indicator
                  Obx(() => Text(
                    '${controller.uploadedPhotosCount.value} of 3 required photos uploaded',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.brandColor,
                    ),
                  )),
                  SizedBox(height: 20.h),

                  // Building Exterior
                  Center(
                    child: Obx(() => _PhotoUploadCard(
                      title: 'Building Exterior',
                      subtitle: 'Click to upload photo',
                      imageFile: controller.buildingExteriorPhoto.value,
                      imageUrl: controller.buildingExteriorUrl.value,
                      onTap: () => controller.uploadBuildingExterior(),
                      onReplace: () => controller.uploadBuildingExterior(),
                    )),
                  ),
                  SizedBox(height: 12.h),

                  // Store Signage
                  Center(
                    child: Obx(() => _PhotoUploadCard(
                      title: 'Store Signage',
                      subtitle: 'Click to upload photo',
                      imageFile: controller.storeSignagePhoto.value,
                      imageUrl: controller.storeSignageUrl.value,
                      onTap: () => controller.uploadStoreSignage(),
                      onReplace: () => controller.uploadStoreSignage(),
                    )),
                  ),
                  SizedBox(height: 12.h),

                  // Inside Store
                  Center(
                    child: Obx(() => _PhotoUploadCard(
                      title: 'Inside Store',
                      subtitle: 'Click to upload photo',
                      imageFile: controller.insideStorePhoto.value,
                      imageUrl: controller.insideStoreUrl.value,
                      onTap: () => controller.uploadInsideStore(),
                      onReplace: () => controller.uploadInsideStore(),
                    )),
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
          child: Obx(() => GestureDetector(
            onTap: controller.uploadedPhotosCount.value >= 3
                ? () {
                    // Submit all business information
                    controller.submitBusinessInformation();
                  }
                : null,
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: controller.uploadedPhotosCount.value >= 3
                    ? ColorConstant.brandColor
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: controller.isSubmitting.value
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Submit',
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

class _PhotoUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final File? imageFile;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onReplace;

  const _PhotoUploadCard({
    required this.title,
    required this.subtitle,
    required this.imageFile,
    required this.imageUrl,
    required this.onTap,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageFile != null || imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: hasImage ? onReplace : onTap,
      child: Container(
        width: 214.w,
        height: hasImage ? null : 200.h, // Fixed height for empty state, auto for image
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: hasImage? ColorConstant.lighterGreen : ColorConstant.greyLighter,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasImage ? Colors.green : Colors.grey.shade200,
            width: hasImage ? 2 : 1,
          ),
        ),
        child: hasImage
            ? Column(
                children: [
                  // Image preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            width: double.infinity,
                            height: 120.h,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 120.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: double.infinity,
                                height: 120.h,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 120.h,
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_outlined,
                                      size: 48.sp,
                                      color: Colors.grey.shade400,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  SizedBox(height: 12.h),
                  // Success indicator
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Click to replace photo',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Camera icon with background card
                  Container(
                    width: 188.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: ColorConstant.greythickness,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 28.sp,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
