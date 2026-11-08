import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/image_constant.dart';
import '../controllers/password_reset_controller.dart';

class VerifyResetCodeView extends GetView<PasswordResetController> {
  const VerifyResetCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = controller.emailController.text;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.verifyBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top area with background
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
                          'Verify Code',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        
                        // Description
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: ColorConstant.darkGrey,
                            ),
                            children: [
                              const TextSpan(
                                text: 'We have sent a verification code to ',
                              ),
                              TextSpan(
                                text: email,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.samantic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        
                        // Change email link
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            'Change Email',
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
                          'Enter the 6-digit code sent to your email',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorConstant.black,
                          ),
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // OTP Input
                        Pinput(
                          length: 6,
                          controller: controller.resetCodeController,
                          focusNode: controller.resetCodeFocusNode,
                          defaultPinTheme: PinTheme(
                            width: 50.w,
                            height: 50.w,
                            textStyle: TextStyle(
                              fontSize: 20.sp,
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
                            width: 50.w,
                            height: 50.w,
                            textStyle: TextStyle(
                              fontSize: 20.sp,
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
                            width: 50.w,
                            height: 50.w,
                            textStyle: TextStyle(
                              fontSize: 20.sp,
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
                            width: 50.w,
                            height: 50.w,
                            textStyle: TextStyle(
                              fontSize: 20.sp,
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
                            // Auto-verify when all 6 digits are entered
                            controller.verifyResetCode();
                          },
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Resend code link
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorConstant.darkGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.resetCodeTimer.value == 0
                                  ? () => controller.resendResetCode()
                                  : null,
                              child: Text(
                                controller.resetCodeTimer.value == 0
                                    ? 'Resend Code'
                                    : 'Resend in ${controller.resetCodeTimer.value}s',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: controller.resetCodeTimer.value == 0
                                      ? ColorConstant.brandColor
                                      : ColorConstant.darkGrey,
                                ),
                              ),
                            ),
                          ],
                        )),
                        
                        SizedBox(height: 32.h),
                        
                        // Verify button
                        Obx(() => GestureDetector(
                          onTap: controller.isVerifyingCode.value
                              ? null
                              : () {
                                  final pin = controller.resetCodeController.text;
                                  if (pin.length == 6) {
                                    controller.verifyResetCode();
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Please enter the 6-digit code',
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
                              color: controller.isVerifyingCode.value
                                  ? ColorConstant.brandColor.withOpacity(0.6)
                                  : ColorConstant.brandColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            alignment: Alignment.center,
                            child: controller.isVerifyingCode.value
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
                                    'Verify Code',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )),
                        
                        SizedBox(height: 16.h),
                      ],
                    ),
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
