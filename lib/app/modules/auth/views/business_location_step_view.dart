import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_info_controller.dart';

class BusinessLocationStepView extends GetView<BusinessInfoController> {
  const BusinessLocationStepView({super.key});

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
                    'Confirm your location',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Drag the pin to your exact entrance',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Current GPS
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current GPS',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorConstant.darkGrey,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Captured automatically',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Obx(() => Text(
                          controller.currentGPS.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Registered Address
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registered Address',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: ColorConstant.darkGrey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Obx(() => Text(
                          controller.registeredAddress.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        )),
                        SizedBox(height: 4.h),
                        Obx(() => Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14.sp,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Distance: ${controller.distanceFromGPS.value}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Interactive Google Map
                  Obx(() => Container(
                    width: double.infinity,
                    height: 300.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              controller.currentLat.value,
                              controller.currentLng.value,
                            ),
                            zoom: 16.0,
                          ),
                          onMapCreated: controller.onMapCreated,
                          onTap: controller.onMapTap,
                          markers: controller.markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          compassEnabled: true,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                        ),
                        // My Location Button (top right)
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(8.r),
                            child: InkWell(
                              onTap: controller.getCurrentLocation,
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: controller.isLoadingLocation.value
                                    ? Center(
                                        child: SizedBox(
                                          width: 20.w,
                                          height: 20.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              ColorConstant.brandColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        Icons.my_location,
                                        size: 20.sp,
                                        color: ColorConstant.brandColor,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        // Instructions overlay (bottom)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  size: 18.sp,
                                  color: ColorConstant.brandColor,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Tap anywhere on the map to set your business location',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: ColorConstant.samantic,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
          onTap: controller.isLoading.value 
              ? null 
              : () => controller.saveLocationAndContinue(),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Use This Location',
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
