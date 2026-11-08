import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_profile_controller.dart';

class CoverImageView extends GetView<BusinessProfileController> {
  const CoverImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorConstant.samantic),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Cover Image',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),

            // Cover Preview
            Obx(() => Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF9B8FF5),
                        Color(0xFFE8A87C),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: controller.coverImageUrl.value.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.network(
                            controller.coverImageUrl.value,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Center(
                          child: Text(
                            controller.businessName.value,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                )),

            SizedBox(height: 24.h),

            // Info Text
            Text(
              'Recommended 1200×600px. Displayed as your storefront banner to customers.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            Spacer(),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: controller.uploadCover,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.brandColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Upload New Cover',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Remove Button
            Obx(() => controller.coverImageUrl.value.isNotEmpty
                ? TextButton(
                    onPressed: controller.removeCover,
                    child: Text(
                      'Remove Cover',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                  )
                : SizedBox.shrink()),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
