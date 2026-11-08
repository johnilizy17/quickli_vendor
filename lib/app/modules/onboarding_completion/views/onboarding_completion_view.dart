import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/onboarding_completion_controller.dart';
import 'agreement_step_view.dart';
import 'products_step_view.dart';
import 'hours_step_view.dart';

class OnboardingCompletionView extends GetView<OnboardingCompletionController> {
  const OnboardingCompletionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: ColorConstant.brandColor),
            );
          }
          
          return Column(
            children: [
              // Header with progress
              _buildHeader(),
              
              // Progress bar
              _buildProgressBar(),
              
              // Step content
              Expanded(
                child: IndexedStack(
                  index: controller.currentStep.value,
                  children: const [
                    AgreementStepView(),
                    ProductsStepView(),
                    HoursStepView(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: ColorConstant.lightGrey, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: ColorConstant.samantic,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete these before going live',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Obx(() => Text(
                      controller.completionText,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ColorConstant.darkGrey,
                      ),
                    )),
                  ],
                ),
              ),
              Obx(() => Text(
                '${controller.completionPercentage}%',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.brandColor,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar() {
    return Obx(() {
      final progress = controller.completionPercentage / 100;
      
      return Container(
        height: 6.h,
        width: double.infinity,
        color: ColorConstant.lightestGrey,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF9800),
                  Color(0xFFFF6F00),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
