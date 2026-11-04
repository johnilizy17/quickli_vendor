import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color_constant.dart';

Widget customButton(
  VoidCallback onTap, {
  required String text,
  Color? bgColor,
  Color? textColor,
  double? fontSize,
  double? height,
  BorderRadius? borderRadius,
  bool isLoading = false,
}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: Container(
      height: height ?? 52.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isLoading
            ? (bgColor ?? ColorConstant.brandColor).withOpacity(0.7)
            : (bgColor ?? ColorConstant.brandColor),
        borderRadius: borderRadius ?? BorderRadius.circular(14.r),
      ),
      child: isLoading
          ? SizedBox(
              width: 22.w,
              height: 22.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
    ),
  );
}
