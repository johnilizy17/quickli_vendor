import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickli_vendor/app/constants/image_constant.dart';
import '../../../constants/color_constant.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    print('🚀 SplashView: build called');
    // Ensure controller is instantiated
    Get.find<SplashController>();
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorConstant.gradientStart,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1257, 0.8492],
              colors: [ColorConstant.gradientStart, ColorConstant.gradientEnd],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Image.asset(
                              ImageConstant.full_logo,
                              height: 65,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom label
              Positioned(
                bottom: 63.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: Text(
                      'For Quickli Vendor Operations',
                      style: TextStyle(
                        color: ColorConstant.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
