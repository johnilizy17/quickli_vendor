import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/owner_verification_controller.dart';
import 'selfie_capture_view.dart';

class IdBackUploadView extends GetView<OwnerVerificationController> {
  const IdBackUploadView({super.key});

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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Your personal details as the business owner',
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'ID — Back side',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Upload area or uploaded confirmation
                    Obx(() {
                      // Show success card if file is selected OR URL is loaded
                      final hasFile = controller.idBackFile.value != null;
                      final hasUrl = controller.idBackPath.value.isNotEmpty;
                      
                      if (hasFile || hasUrl) {
                        return _UploadedSuccessCard(
                          label: 'Back of ID',
                          imageFile: controller.idBackFile.value,
                          imageUrl: controller.idBackPath.value,
                          onRemove: () {
                            controller.idBackFile.value = null;
                            controller.idBackPath.value = '';
                          },
                        );
                      }
                      return _UploadArea(
                        label: 'Back of ID',
                        onTap: () => controller.uploadIdBack(),
                      );
                    }),

                    SizedBox(height: 20.h),

                    // Photo tips
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.greyCard,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Photo tips:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.samantic,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _PhotoTip(text: 'Lay the ID on a flat, well-lit surface'),
                          _PhotoTip(text: 'Ensure all 4 corners are visible'),
                          _PhotoTip(text: 'No glare or shadows on the ID'),
                          _PhotoTip(text: 'Photo must be clear and in focus'),
                        ],
                      ),
                    ),
                    
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
              Obx(() {
                final hasIdBack = controller.idBackFile.value != null || 
                                 controller.idBackPath.value.isNotEmpty;
                
                return ElevatedButton(
                  onPressed: hasIdBack
                      ? () {
                          Get.to(() => const SelfCaptureView());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.brandColor,
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: Text(
                    'Continue to Selfie',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.white,
                    ),
                  ),
                );
              }),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () {
                  Get.to(() => const SelfCaptureView());
                },
                child: Text(
                  'Skip for now',
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

class _UploadArea extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _UploadArea({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: ColorConstant.brandColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 32.sp,
                  color: ColorConstant.brandColor,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.samantic,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'JPG or PNG · Max 10 MB · Minimum 1MB',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorConstant.deepGrey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  label: Text(
                    '📷 Take Photo',
                    style: TextStyle(
                      color: ColorConstant.samantic,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  label: Text(
                    '📁 Upload File',
                    style: TextStyle(
                      color: ColorConstant.samantic,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  }
}

class _UploadedSuccessCard extends StatelessWidget {
  final String label;
  final File? imageFile;
  final String imageUrl;
  final VoidCallback onRemove;

  const _UploadedSuccessCard({
    required this.label,
    required this.imageFile,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 180.h,
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
                        height: 180.h,
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
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    Text(
                      'Uploaded successfully',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: Icon(
                  Icons.close,
                  color: ColorConstant.deepGrey,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoTip extends StatelessWidget {
  final String text;

  const _PhotoTip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorConstant.deepGrey,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorConstant.deepGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
