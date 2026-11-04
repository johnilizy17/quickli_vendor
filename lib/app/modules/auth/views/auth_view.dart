import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/image_constant.dart';
import '../controllers/auth_controller.dart';
import 'signup_view.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔐 AuthView: build called');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Hero Section with gradient background
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(20.w),
                padding: EdgeInsets.only(
                  top: 48.h,
                  left: 26.w,
                  right: 48.w,
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  image: const DecorationImage(
                    image: AssetImage(ImageConstant.authBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Quickli',
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 0,
                      ),
                    ),
                    Text(
                      'Business',
                      style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Subtitle
                    Text(
                      'Manage your business,\norders, and growth, all in\none place.',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.softwhite,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Bottom Action Section
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),

                    // Login Button
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to login
                        Get.snackbar(
                          'Login',
                          'Login functionality coming soon',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: ColorConstant.brandColor,
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ColorConstant.PurpleLught,
                            width: 0.75,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'I have an account — Log in',
                          style: TextStyle(
                            color: ColorConstant.gradientStart,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Register Button
                    GestureDetector(
                      onTap: () {
                        // Navigate to signup
                        Get.to(() => const SignupView());
                      },
                      child: Container(
                        width: double.infinity,
                        height: 53.h,
                        decoration: BoxDecoration(
                          color: ColorConstant.gradientStart,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Register my business',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Terms text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorConstant.darkGrey,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                            text: 'By continuing, you agree to our ',
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: ColorConstant.gradientStart,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCard({
    required String name,
    required String location,
    Color? color,
    double rotation = 0,
  }) {
    return Transform.rotate(
      angle: rotation * 0.0174533, // Convert degrees to radians
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Vendor icon/image placeholder
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: ColorConstant.lightestGrey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('🍕', style: TextStyle(fontSize: 16.sp)),
              ),
            ),
            SizedBox(width: 8.w),
            // Vendor info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: color != null
                        ? Colors.black
                        : ColorConstant.samantic,
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
