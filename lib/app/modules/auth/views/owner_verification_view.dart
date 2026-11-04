import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/owner_verification_controller.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class OwnerVerificationView extends GetView<OwnerVerificationController> {
  const OwnerVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConstant.samantic),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Owner Verification',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.samantic,
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info banner
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.fadedPurpleAccent,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ColorConstant.brandColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'We need to verify your identity. Please provide valid government-issued ID documents.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorConstant.samantic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Full Name
                    CustomTextField(
                      controller: controller.fullNameController,
                      label: 'Full Name (as on ID)',
                      hint: 'Enter your full name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Date of Birth
                    GestureDetector(
                      onTap: () => controller.selectDateOfBirth(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: controller.dobController,
                          label: 'Date of Birth',
                          hint: 'Select date of birth',
                          suffixIcon: Icons.calendar_today_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select date of birth';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ID Type
                    Text(
                      'ID Type',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.borderColor),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.idType.value.isEmpty
                                ? null
                                : controller.idType.value,
                            hint: Text(
                              'Select ID type',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorConstant.darkGrey,
                              ),
                            ),
                            isExpanded: true,
                            items: [
                              'National ID',
                              'Driver\'s License',
                              'Passport',
                              'Voter\'s Card',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.idType.value = value;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ID Number
                    CustomTextField(
                      controller: controller.idNumberController,
                      label: 'ID Number',
                      hint: 'Enter ID number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ID number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Document Uploads
                    Text(
                      'Upload Documents',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ID Front
                    _DocumentUploadCard(
                      title: 'ID Front',
                      subtitle: 'Upload the front of your ID',
                      iconData: Icons.badge_outlined,
                      imagePath: controller.idFrontPath,
                      onTap: controller.uploadIdFront,
                    ),
                    SizedBox(height: 12.h),

                    // ID Back
                    _DocumentUploadCard(
                      title: 'ID Back',
                      subtitle: 'Upload the back of your ID',
                      iconData: Icons.badge_outlined,
                      imagePath: controller.idBackPath,
                      onTap: controller.uploadIdBack,
                    ),
                    SizedBox(height: 12.h),

                    // Selfie
                    _DocumentUploadCard(
                      title: 'Selfie',
                      subtitle: 'Upload a clear selfie holding your ID',
                      iconData: Icons.camera_alt_outlined,
                      imagePath: controller.selfiePath,
                      onTap: controller.uploadSelfie,
                    ),
                    SizedBox(height: 24.h),

                    // Tips
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.lightGreen,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.tips_and_updates_outlined,
                                color: ColorConstant.green,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Tips for better verification',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _TipItem('Ensure all text is clearly visible'),
                          _TipItem('Use good lighting'),
                          _TipItem('Avoid glare or shadows'),
                          _TipItem('Keep documents flat and in frame'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CustomButton(
                text: 'Save & Continue',
                onPressed: controller.saveVerification,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final RxString imagePath;
  final VoidCallback onTap;

  const _DocumentUploadCard({
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: imagePath.value.isEmpty
                  ? ColorConstant.borderColor
                  : ColorConstant.green,
              width: imagePath.value.isEmpty ? 1 : 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: imagePath.value.isEmpty
                      ? ColorConstant.lightestGrey
                      : ColorConstant.lightGreen,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  imagePath.value.isEmpty ? iconData : Icons.check_circle,
                  color: imagePath.value.isEmpty
                      ? ColorConstant.darkGrey
                      : ColorConstant.green,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
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
                      imagePath.value.isEmpty ? subtitle : 'Uploaded',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: imagePath.value.isEmpty
                            ? ColorConstant.darkGrey
                            : ColorConstant.green,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                imagePath.value.isEmpty ? Icons.upload_outlined : Icons.edit,
                color: ColorConstant.brandColor,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: ColorConstant.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorConstant.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
