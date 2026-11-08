import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/onboarding_completion_controller.dart';

class ProductsStepView extends GetView<OnboardingCompletionController> {
  const ProductsStepView({super.key});

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
                          '2',
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
                      'Add Products',
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
                  'Add at least 5 products to your menu to start accepting orders. You can add more products later.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstant.darkGrey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Progress card
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorConstant.brandColor.withValues(alpha: 0.1),
                        ColorConstant.brandColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorConstant.brandColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48.sp,
                            color: ColorConstant.brandColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Obx(() => Text(
                        '${controller.productsAdded.value} / 5',
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w800,
                          color: ColorConstant.brandColor,
                          height: 1,
                        ),
                      )),
                      SizedBox(height: 8.h),
                      Text(
                        'Products Added',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.samantic,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Progress bar
                      Obx(() {
                        final progress = (controller.productsAdded.value / 5).clamp(0.0, 1.0);
                        
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8.h,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorConstant.brandColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '${(progress * 100).toInt()}% Complete',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.darkGrey,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Product checklist
                _buildChecklistItem(
                  '1. Add high-quality product images',
                  controller.productsAdded.value >= 1,
                ),
                _buildChecklistItem(
                  '2. Write clear product descriptions',
                  controller.productsAdded.value >= 2,
                ),
                _buildChecklistItem(
                  '3. Set competitive prices',
                  controller.productsAdded.value >= 3,
                ),
                _buildChecklistItem(
                  '4. Include preparation time',
                  controller.productsAdded.value >= 4,
                ),
                _buildChecklistItem(
                  '5. Add customization options (optional)',
                  controller.productsAdded.value >= 5,
                ),
                SizedBox(height: 24.h),
                
                // Tips card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 20.sp,
                        color: Colors.green.shade700,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pro Tips',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.samantic,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '• Use professional product photos\n'
                              '• Write detailed descriptions\n'
                              '• Price competitively for your area\n'
                              '• Start with your most popular items',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorConstant.darkGrey,
                                height: 1.5,
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
              Obx(() => controller.productsAdded.value >= 5
                ? _buildContinueButton()
                : _buildAddProductButton(),
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: controller.previousStep,
                child: Text(
                  'Back to Agreement',
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
  
  Widget _buildChecklistItem(String text, bool isCompleted) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: isCompleted 
                ? Colors.green 
                : ColorConstant.lightGrey,
              shape: BoxShape.circle,
            ),
            child: isCompleted
              ? Icon(
                  Icons.check,
                  size: 14.sp,
                  color: Colors.white,
                )
              : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: isCompleted 
                  ? ColorConstant.samantic 
                  : ColorConstant.darkGrey,
                fontWeight: isCompleted 
                  ? FontWeight.w600 
                  : FontWeight.w400,
                decoration: isCompleted 
                  ? TextDecoration.lineThrough 
                  : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddProductButton() {
    return GestureDetector(
      onTap: controller.skipToProducts,
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
            Icon(Icons.add, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Add Products',
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
  
  Widget _buildContinueButton() {
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
              'Continue to Hours Setup',
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
