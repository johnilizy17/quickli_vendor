import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/password_reset_controller.dart';

class CreateNewPasswordView extends GetView<PasswordResetController> {
  const CreateNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18.sp,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create new password',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.samantic,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Choose a strong password for your account',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorConstant.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // New Password field
                    Text(
                      'New password *',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.darkColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => TextField(
                        controller: controller.newPasswordController,
                        obscureText: controller.obscureNewPassword.value,
                        onChanged: (value) => controller.checkPasswordStrength(value),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.samantic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Minimum 8 characters',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: ColorConstant.lightGrey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => controller.obscureNewPassword.value =
                                !controller.obscureNewPassword.value,
                            child: Icon(
                              controller.obscureNewPassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: ColorConstant.darkGrey,
                              size: 20.sp,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: ColorConstant.lightGrey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: ColorConstant.lightGrey.withOpacity(0.3),
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
                    ),

                    SizedBox(height: 16.h),

                    // Password strength indicator
                    Obx(() {
                      final strength = controller.passwordStrength.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 4 strength bars
                          Row(
                            children: List.generate(
                              4,
                              (index) => Expanded(
                                child: Container(
                                  height: 4.h,
                                  margin: EdgeInsets.only(
                                    right: index < 3 ? 8.w : 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStrengthColor(strength, index),
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _getStrengthLabel(strength),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: _getStrengthColor(strength, 0),
                            ),
                          ),
                        ],
                      );
                    }),

                    SizedBox(height: 20.h),

                    // Password criteria
                    Obx(() => Column(
                      children: [
                        _buildCriteriaItem(
                          '8+ characters',
                          controller.has8Characters.value,
                        ),
                        SizedBox(height: 8.h),
                        _buildCriteriaItem(
                          'Upper & lowercase letters',
                          controller.hasUpperLower.value,
                        ),
                        SizedBox(height: 8.h),
                        _buildCriteriaItem(
                          'At least one number',
                          controller.hasNumber.value,
                        ),
                      ],
                    )),

                    SizedBox(height: 24.h),

                    // Confirm Password field
                    Text(
                      'Confirm new password *',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.darkColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: controller.obscureConfirmPassword.value,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.samantic,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Re-enter your new password',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: ColorConstant.lightGrey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => controller.obscureConfirmPassword.value =
                                !controller.obscureConfirmPassword.value,
                            child: Icon(
                              controller.obscureConfirmPassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: ColorConstant.darkGrey,
                              size: 20.sp,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: controller.confirmPasswordError.value.isNotEmpty
                                  ? Colors.red
                                  : ColorConstant.lightGrey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: controller.confirmPasswordError.value.isNotEmpty
                                  ? Colors.red
                                  : ColorConstant.lightGrey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: controller.confirmPasswordError.value.isNotEmpty
                                  ? Colors.red
                                  : ColorConstant.brandColor,
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
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.confirmPasswordError.value.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                controller.confirmPasswordError.value,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Obx(
                () => GestureDetector(
                  onTap: controller.isUpdatingPassword.value
                      ? null
                      : () => controller.updatePassword(),
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: controller.isUpdatingPassword.value
                          ? ColorConstant.brandColor.withOpacity(0.6)
                          : ColorConstant.brandColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.center,
                    child: controller.isUpdatingPassword.value
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
                            'Update Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildCriteriaItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          size: 16.sp,
          color: isValid ? Colors.green : ColorConstant.lightGrey,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: isValid ? Colors.green : ColorConstant.grey,
          ),
        ),
      ],
    );
  }

  Color _getStrengthColor(int strength, int barIndex) {
    if (barIndex >= strength) {
      return ColorConstant.lightGrey.withOpacity(0.3);
    }
    
    switch (strength) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.green;
      default:
        return ColorConstant.lightGrey.withOpacity(0.3);
    }
  }

  String _getStrengthLabel(int strength) {
    switch (strength) {
      case 1:
        return 'Too weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }
}
