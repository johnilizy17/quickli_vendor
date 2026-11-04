import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../constants/color_constant.dart';
import '../controllers/auth_controller.dart';

class VerifyPhoneView extends GetView<AuthController> {
  const VerifyPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get phone number from arguments or controller
    final String phoneNumber = Get.arguments?['phone'] ?? 
                               controller.phoneNumberController.text;
    
    return Scaffold(
      backgroundColor: ColorConstant.brandColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top gradient area (empty for design)
            SizedBox(height: 100.h),
            
            // White rounded container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      
                      // Title
                      Text(
                        'Verification code sent to',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.samantic,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      
                      // Phone number
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.samantic,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      
                      // Change number link
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'Change Number',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.brandColor,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 32.h),
                      
                      // Instruction text
                      Text(
                        'Enter the 4-digit code sent to your phone',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.darkGrey,
                        ),
                      ),
                      
                      SizedBox(height: 24.h),
                      
                      // OTP Input
                      Pinput(
                        length: 4,
                        controller: controller.otpController,
                        focusNode: controller.otpFocusNode,
                        defaultPinTheme: PinTheme(
                          width: 70.w,
                          height: 70.w,
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstant.lightestGrey,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 70.w,
                          height: 70.w,
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: ColorConstant.brandColor,
                              width: 2,
                            ),
                          ),
                        ),
                        submittedPinTheme: PinTheme(
                          width: 70.w,
                          height: 70.w,
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstant.lightestGrey,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                        errorPinTheme: PinTheme(
                          width: 70.w,
                          height: 70.w,
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        onCompleted: (pin) {
                          // Auto-verify when all 4 digits are entered
                          controller.verifyPhone(pin);
                        },
                      ),
                      
                      SizedBox(height: 24.h),
                      
                      // Resend code link
                      Obx(() => GestureDetector(
                        onTap: controller.canResendOtp.value
                            ? () => controller.resendOtp()
                            : null,
                        child: Text(
                          controller.canResendOtp.value
                              ? 'Resend code'
                              : 'Resend code in ${controller.resendTimer.value}s',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: controller.canResendOtp.value
                                ? ColorConstant.brandColor
                                : ColorConstant.darkGrey,
                          ),
                        ),
                      )),
                      
                      SizedBox(height: 32.h),
                      
                      // Verify button
                      Obx(() => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () {
                                final pin = controller.otpController.text;
                                if (pin.length == 4) {
                                  controller.verifyPhone(pin);
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter the 4-digit code',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
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
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Verify Phone',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      )),
                      
                      SizedBox(height: 16.h),
                      
                      // Terms text
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorConstant.darkGrey,
                            ),
                            children: [
                              const TextSpan(text: 'By continuing, you agree to our '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: ColorConstant.brandColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
