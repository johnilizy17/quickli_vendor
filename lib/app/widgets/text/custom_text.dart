import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color_constant.dart';

Widget customText({
  required String text,
  double? fontSize,
  FontWeight? fontWeight,
  Color? textColor,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? textOverflow,
  double? height,
  double? letterSpacing,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: textOverflow,
    style: TextStyle(
      fontSize: fontSize ?? 14.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: textColor ?? ColorConstant.samantic,
      height: height,
      letterSpacing: letterSpacing,
    ),
  );
}
