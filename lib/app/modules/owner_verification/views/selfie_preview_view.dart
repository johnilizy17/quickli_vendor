import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/owner_verification_controller.dart';

class SelfiePreviewView extends GetView<OwnerVerificationController> {
  const SelfiePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
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
                          'Owner information',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Your personal details as the business owner',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstant.deepGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Take a selfie to verify your identity',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Selfie preview
                    Obx(() {
                      if (controller.selfieFile.value != null) {
                        return Column(
                          children: [
                            Container(
                              width: 200.w,
                              height: 200.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorConstant.brandColor,
                                  width: 4,
                                ),
                                image: DecorationImage(
                                  image: FileImage(controller.selfieFile.value!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Selfie Verified!',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.samantic,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Your selfie has been accepted. Continuing to\nbusiness documents.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorConstant.deepGrey,
                                height: 1.4,
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Container(
                            width: 200.w,
                            height: 200.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 80.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Selfie preview',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.samantic,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Make sure your face is clear and well-lit',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: ColorConstant.deepGrey,
                            ),
                          ),
                        ],
                      );
                    }),
                    
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Buttons
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => ElevatedButton(
                onPressed: controller.selfieFile.value != null && !controller.isUploading.value
                    ? () => controller.submitOwnerVerification()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.brandColor,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: controller.isUploading.value
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Submit This Selfie',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.white,
                        ),
                      ),
              )),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Retake',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.deepGrey,
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
