import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/onboarding_completion_controller.dart';

class AgreementStepView extends GetView<OnboardingCompletionController> {
  const AgreementStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: ColorConstant.brandColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Agreement',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.samantic,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                
                // Description
                Text(
                  'Please review and sign the vendor agreement to continue. This agreement outlines the terms and conditions for operating on the Quickli platform.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstant.darkGrey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Contract preview card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorConstant.lightestGrey,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorConstant.lightGrey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 24.sp,
                            color: ColorConstant.brandColor,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vendor Agreement',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.samantic,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Terms and Conditions',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: ColorConstant.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      
                      // Contract highlights
                      _buildHighlightItem(
                        '✓ Commission structure and payment terms',
                      ),
                      _buildHighlightItem(
                        '✓ Quality standards and customer service requirements',
                      ),
                      _buildHighlightItem(
                        '✓ Delivery and fulfillment obligations',
                      ),
                      _buildHighlightItem(
                        '✓ Platform usage guidelines',
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // View full document button
                      GestureDetector(
                        onTap: () {
                          // TODO: Open full contract PDF/modal
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: ColorConstant.brandColor),
                          ),
                          child: Center(
                            child: Text(
                              'View Full Agreement',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.brandColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Important notes
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20.sp,
                        color: Colors.orange.shade700,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Important Note',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.samantic,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'By signing this agreement, you confirm that you have read and understood all terms and conditions.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorConstant.darkGrey,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Bottom action button
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: ColorConstant.lightGrey, width: 1),
            ),
          ),
          child: Obx(() => controller.agreementSigned.value
            ? _buildCompletedButton()
            : _buildSignButton(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildHighlightItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          color: ColorConstant.samantic,
          height: 1.4,
        ),
      ),
    );
  }
  
  Widget _buildSignButton() {
    return Obx(() => GestureDetector(
      onTap: controller.isSigning.value ? null : controller.signContract,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: controller.isSigning.value 
            ? ColorConstant.lightGrey 
            : ColorConstant.brandColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: controller.isSigning.value
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Sign Agreement',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
        ),
      ),
    ));
  }
  
  Widget _buildCompletedButton() {
    return GestureDetector(
      onTap: controller.nextStep,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Completed - Continue',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
