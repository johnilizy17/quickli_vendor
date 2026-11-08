import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/image_constant.dart';
import '../controllers/business_profile_controller.dart';

class BusinessProfileView extends GetView<BusinessProfileController> {
  const BusinessProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ColorConstant.samantic, size: 20.sp),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Business Profile',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Business Info Card (Logo, Name, Category)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Logo
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: ColorConstant.brandColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: controller.logoUrl.value.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
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
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),

                      SizedBox(width: 16.w),

                      // Business Name and Category
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.businessName.value,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.samantic,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${controller.businessCategory.value} · ${controller.location.value}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Badge Details Button (Centered in white card)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: controller.goToBadgeDetails,
                      icon: SvgPicture.asset(
                        ImageConstant.badgeIcon,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          ColorConstant.brandColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: Text(
                        'Badge Details',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.brandColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Business Details Card
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoField('Business name', controller.businessName.value),
                      SizedBox(height: 20.h),
                      _buildInfoField('Description', controller.description.value),
                      SizedBox(height: 20.h),
                      _buildInfoField('Contact phone', controller.contactPhone.value),
                      SizedBox(height: 20.h),
                      _buildInfoField('Support email', controller.supportEmail.value),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Operating Hours Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: controller.goToOperatingHours,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: ColorConstant.brandColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Operating Hours',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.brandColor,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Delivery & Pickup Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: controller.goToDeliveryPickup,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: ColorConstant.brandColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Delivery & Pickup',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.brandColor,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Edit Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: controller.goToEditProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.brandColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Edit Business Profile',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 100.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value.isEmpty ? 'Not set' : value,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
