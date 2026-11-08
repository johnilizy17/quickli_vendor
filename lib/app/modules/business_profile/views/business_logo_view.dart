import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_profile_controller.dart';

class BusinessLogoView extends GetView<BusinessProfileController> {
  const BusinessLogoView({super.key});

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
          'Business Logo',
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

            // Logo Preview
            Obx(() => Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    color: ColorConstant.brandColor,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: controller.logoUrl.value.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Image.network(
                            controller.logoUrl.value,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            controller.businessName.value
                                .split(' ')
                                .take(2)
                                .map((e) => e.isNotEmpty ? e[0] : '')
                                .join()
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 48.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                )),

            SizedBox(height: 16.h),

            // File Info
            Obx(() => controller.logoUrl.value.isNotEmpty
                ? Text(
                    'PNG · 512×512 · 84 KB',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade500,
                    ),
                  )
                : SizedBox.shrink()),

            SizedBox(height: 24.h),

            // Info Text
            Text(
              'Use a square image at least 512×512px. This appears next to your store name across Quickli.',
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
                onPressed: controller.uploadLogo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.brandColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Upload New Logo',
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
            Obx(() => controller.logoUrl.value.isNotEmpty
                ? TextButton(
                    onPressed: controller.removeLogo,
                    child: Text(
                      'Remove Logo',
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
