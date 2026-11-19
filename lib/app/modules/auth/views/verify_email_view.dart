import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/image_constant.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailView extends GetView<AuthController> {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get email from arguments or controller
    final String email = Get.arguments?['email'] ?? 
                         controller.emailController.text;
    
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
              SizedBox(height: 180.h),
              
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
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        
                        // Description
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: ColorConstant.black,
                            ),
                            children: [
                              TextSpan(
                                text: email,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.black,
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
                              color: ColorConstant.gradientStart,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Instruction text
                        Text(
                          'Enter the 6-digit code sent to your email',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorConstant.black,
                          ),
                        ),
                        
                        SizedBox(height: 8.h),
                        
                        // OTP Input
                        Pinput(
                          length: 6,
                          controller: controller.emailOtpController,
                          focusNode: controller.emailOtpFocusNode,
                          defaultPinTheme: PinTheme(
                            width: 50.w,
                            height: 50.w,
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.samantic,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ColorConstant.whiteSnow,
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
                            controller.verifyEmail(pin);
                          },
                        ),
                        
                        SizedBox(height: 4.h),
                        
                        // Resend code link
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                             !controller.canResendEmailOtp.value?
                                     "Resend code in ":"",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorConstant.greyDark,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.canResendEmailOtp.value
                                  ? () => controller.resendEmailOtp()
                                  : null,
                              child: Text(
                                controller.canResendEmailOtp.value
                                    ? 'Resend Code'
                                    : '${controller.resendEmailTimer.value}s',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color:  ColorConstant.gradientStart
                                ),
                              ),
                            ),
                          ],
                        )),
                        
                        SizedBox(height: 32.h),
                        
                        // Verify button
                        Obx(() {
                          final isDisabled = !controller.isEmailOtpValid.value || 
                                           controller.isLoading.value;
                          
                          return GestureDetector(
                            onTap: isDisabled
                                ? null
                                : () {
                                    final pin = controller.emailOtpController.text;
                                    controller.verifyEmail(pin);
                                  },
                            child: Container(
                              width: double.infinity,
                              height: 56.h,
                              decoration: BoxDecoration(
                                color: isDisabled
                                    ? ColorConstant.brandColor.withOpacity(0.4)
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
                                      'Verify Email',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        }),
                        
                        SizedBox(height: 16.h),
                        
                        // Terms text
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorConstant.deepGrey,
                              ),
                              children: [
                                const TextSpan(text: 'By continuing, you agree to our ',  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )),
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
      ),
    );
  }
}
