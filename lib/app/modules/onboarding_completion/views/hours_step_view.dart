import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/onboarding_completion_controller.dart';

class HoursStepView extends GetView<OnboardingCompletionController> {
  const HoursStepView({super.key});

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
                          '3',
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
                      'Operating Hours',
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
                  'Set your business hours so customers know when you\'re available to accept orders.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstant.darkGrey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Status card
                Obx(() => Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: controller.hoursConfigured.value
                        ? [
                            Colors.green.withValues(alpha: 0.1),
                            Colors.green.withValues(alpha: 0.05),
                          ]
                        : [
                            ColorConstant.brandColor.withValues(alpha: 0.1),
                            ColorConstant.brandColor.withValues(alpha: 0.05),
                          ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: controller.hoursConfigured.value
                        ? Colors.green.withValues(alpha: 0.3)
                        : ColorConstant.brandColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        controller.hoursConfigured.value
                          ? Icons.check_circle_outline
                          : Icons.access_time_outlined,
                        size: 48.sp,
                        color: controller.hoursConfigured.value
                          ? Colors.green
                          : ColorConstant.brandColor,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        controller.hoursConfigured.value
                          ? 'Hours Configured'
                          : 'Hours Not Set',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: controller.hoursConfigured.value
                            ? Colors.green
                            : ColorConstant.samantic,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.hoursConfigured.value
                          ? 'Your operating hours are set up and ready'
                          : 'Configure when you\'re open for business',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.darkGrey,
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 24.h),
                
                // Hours importance
                Text(
                  'Why set operating hours?',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.samantic,
                  ),
                ),
                SizedBox(height: 12.h),
                
                _buildBenefitItem(
                  Icons.visibility_outlined,
                  'Customers see when you\'re available',
                ),
                _buildBenefitItem(
                  Icons.notifications_off_outlined,
                  'No orders outside your hours',
                ),
                _buildBenefitItem(
                  Icons.schedule_outlined,
                  'Better work-life balance',
                ),
                _buildBenefitItem(
                  Icons.trending_up_outlined,
                  'Manage peak hours efficiently',
                ),
                SizedBox(height: 24.h),
                
                // Example hours card
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
                            Icons.calendar_today_outlined,
                            size: 18.sp,
                            color: ColorConstant.brandColor,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Example Hours',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.samantic,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      _buildExampleHour('Monday - Friday', '9:00 AM - 10:00 PM'),
                      _buildExampleHour('Saturday', '10:00 AM - 11:00 PM'),
                      _buildExampleHour('Sunday', '11:00 AM - 9:00 PM'),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Info note
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20.sp,
                        color: Colors.blue.shade700,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Flexible Schedule',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.samantic,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'You can always update your hours later from the business profile settings.',
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
        
        // Bottom action buttons
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: ColorConstant.lightGrey, width: 1),
            ),
          ),
          child: Column(
            children: [
              Obx(() => controller.hoursConfigured.value
                ? _buildCompleteButton()
                : _buildSetHoursButton(),
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: controller.previousStep,
                child: Text(
                  'Back to Products',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.brandColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: ColorConstant.brandColor,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorConstant.samantic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildExampleHour(String day, String hours) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorConstant.darkGrey,
            ),
          ),
          Text(
            hours,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: ColorConstant.samantic,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSetHoursButton() {
    return GestureDetector(
      onTap: controller.skipToHours,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorConstant.brandColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Set Operating Hours',
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
  
  Widget _buildCompleteButton() {
    return GestureDetector(
      onTap: controller.completeOnboarding,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.green.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Complete & Go Live',
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
