import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/color_constant.dart';

class LoadingOverlay {
  static void show({String? message}) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black54,
      context: navigatorKey.currentContext!,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.brandColor),
                ),
                if (message != null) ...[
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.samantic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide() {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pop();
    }
  }
}

// Global navigator key (add this to your main.dart)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
