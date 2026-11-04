import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/auth_controller.dart';

class VerificationView extends GetView<AuthController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios, size: 20.sp, color: ColorConstant.samantic)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text('Enter verification code', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
              SizedBox(height: 8.h),
              Text('We sent a code to your number', style: TextStyle(fontSize: 14.sp, color: ColorConstant.darkGrey)),
              SizedBox(height: 40.h),
              // TODO: Pinput widget
              Container(
                height: 56.h,
                decoration: BoxDecoration(color: ColorConstant.lightestGrey, borderRadius: BorderRadius.circular(12.r)),
                alignment: Alignment.center,
                child: Text('— — — — — —', style: TextStyle(fontSize: 22.sp, letterSpacing: 8, color: ColorConstant.darkGrey)),
              ),
              SizedBox(height: 32.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 52.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: ColorConstant.brandColor, borderRadius: BorderRadius.circular(14.r)),
                  child: Text('Verify', style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
