import 'package:flutter/material.dart';
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
                                onChanged: (value) {
                                  // Clear error when user types
                                  if (controller.firstNameError.value.isNotEmpty) {
                                    controller.firstNameError.value = '';
                                  }
                                },
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
                                ),
                              ),
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
                      keyboardType: TextInputType.phone,
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
                    SizedBox(height: 6.h),
                    Text(
                      'Too weak',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                    
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
              child: GestureDetector(
                onTap: () {
                  // TODO: Handle signup
                  Get.snackbar(
                    'Sign Up',
                    'Sign up functionality coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: ColorConstant.brandColor,
                    colorText: Colors.white,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: ColorConstant.brandColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
