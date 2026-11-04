import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: ColorConstant.samantic),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create your account',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    
                    // First name and Last name row
                    Row(
                      children: [
                        // First name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorConstant.samantic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: const [
                                    TextSpan(text: 'First name '),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: controller.firstNameController,
                                decoration: InputDecoration(
                                  hintText: 'Lena',
                                  hintStyle: TextStyle(
                                    color: ColorConstant.darkGrey.withOpacity(0.5),
                                    fontSize: 14.sp,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: ColorConstant.lightGrey,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: ColorConstant.lightGrey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: ColorConstant.brandColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() => controller.firstNameError.value.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 4.h, left: 4.w),
                                      child: Text(
                                        controller.firstNameError.value,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Last name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorConstant.samantic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Last name '),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: controller.lastNameController,
                                decoration: InputDecoration(
                                  hintText: 'Okonkwo',
                                  hintStyle: TextStyle(
                                    color: ColorConstant.darkGrey.withOpacity(0.5),
                                    fontSize: 14.sp,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: ColorConstant.lightGrey,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: ColorConstant.lightGrey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: ColorConstant.brandColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() => controller.lastNameError.value.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 4.h, left: 4.w),
                                      child: Text(
                                        controller.lastNameError.value,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Email address
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.samantic,
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(text: 'Email address '),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'lena@harbourtown.ng',
                        hintStyle: TextStyle(
                          color: ColorConstant.darkGrey.withOpacity(0.5),
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        suffixIcon: Obx(() {
                          if (controller.isCheckingEmail.value) {
                            return Padding(
                              padding: EdgeInsets.all(12.w),
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
                            );
                          } else if (controller.emailController.text.isNotEmpty &&
                              GetUtils.isEmail(controller.emailController.text.trim())) {
                            return Icon(
                              controller.emailAvailable.value
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: controller.emailAvailable.value
                                  ? const Color(0xFF00C853)
                                  : Colors.red,
                              size: 20.sp,
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.lightGrey,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.lightGrey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.brandColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Use the email you want for business notifications',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorConstant.darkGrey,
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Phone number
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.samantic,
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(text: 'Phone number '),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ],
                      decoration: InputDecoration(
                        hintText: '+2348123456789',
                        hintStyle: TextStyle(
                          color: ColorConstant.darkGrey.withOpacity(0.5),
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.lightGrey,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.lightGrey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.brandColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Must be able to receive SMS',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorConstant.darkGrey,
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Password
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.samantic,
                          fontWeight: FontWeight.w500,
                        ),
                        children: const [
                          TextSpan(text: 'Password '),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      decoration: InputDecoration(
                        hintText: 'Inlook',
                        hintStyle: TextStyle(
                          color: ColorConstant.darkGrey.withOpacity(0.5),
                          fontSize: 14.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: ColorConstant.darkGrey,
                            size: 20.sp,
                          ),
                          onPressed: () {
                            controller.obscurePassword.value = 
                                !controller.obscurePassword.value;
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.lightGrey,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.lightGrey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: ColorConstant.brandColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    )),
                    // Password strength indicator
                    Obx(() {
                      if (controller.passwordStrength.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      
                      int activeLines = 0;
                      Color barColor = Colors.transparent;
                      
                      if (controller.passwordStrength.value == 'Too weak') {
                        activeLines = 1;
                        barColor = Colors.red;
                      } else if (controller.passwordStrength.value == 'Weak') {
                        activeLines = 2;
                        barColor = const Color(0xFFFFA500); // Orange
                      } else if (controller.passwordStrength.value == 'Good') {
                        activeLines = 3;
                        barColor = const Color(0xFF90EE90); // Light green
                      } else if (controller.passwordStrength.value == 'Strong') {
                        activeLines = 4;
                        barColor = const Color(0xFF00C853); // Green
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          // Four strength bars
                          Row(
                            children: List.generate(4, (index) {
                              return Expanded(
                                child: Container(
                                  height: 4.h,
                                  margin: EdgeInsets.only(
                                    right: index < 3 ? 6.w : 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index < activeLines 
                                        ? barColor 
                                        : ColorConstant.lightestGrey,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            controller.passwordStrength.value,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: controller.passwordStrengthColor.value,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }),
                    // Password error
                    Obx(() => controller.passwordError.value.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 4.h, left: 4.w),
                            child: Text(
                              controller.passwordError.value,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : const SizedBox.shrink()),
                    
                    SizedBox(height: 6.h),
                    
                    // Terms and Privacy
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorConstant.darkGrey,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'By creating an account you agree to our '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: ColorConstant.brandColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: ColorConstant.brandColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
            
            // Continue Button (Fixed at bottom)
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Obx(() => GestureDetector(
                onTap: controller.isLoading.value ? null : () {
                  // Validate and submit form
                  controller.signup();
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
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
