import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_registration_controller.dart';

class BusinessRegistrationView extends GetView<BusinessRegistrationController> {
  const BusinessRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConstant.samantic),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register your business',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: ColorConstant.samantic,
              ),
            ),
            Text(
              'Get started with Quickli in under 5-15 minutes',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: ColorConstant.darkGrey,
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      'Submit the required information so our team can verify your account.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Progress indicator
                    Row(
                      children: [
                        Text(
                          '${controller.completedSteps.length} of 5 completed',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${controller.progressPercentage}%',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.brandColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: controller.progressPercentage / 100,
                        backgroundColor: ColorConstant.lightestGrey,
                        valueColor: AlwaysStoppedAnimation<Color>(ColorConstant.brandColor),
                        minHeight: 8.h,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Warning banner
                    if (!controller.canGoOnline)
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: ColorConstant.lightAmber.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: ColorConstant.amber.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: ColorConstant.amber,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'You cannot go online until all required items are approved or conditionally accepted.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: ColorConstant.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 24.h),

                    // Registration steps
                    _RegistrationStep(
                      icon: Icons.business_outlined,
                      title: 'Business information',
                      subtitle: 'Type, name, logo, and address',
                      status: controller.businessInfoStatus.value,
                      onTap: controller.goToBusinessInfo,
                    ),
                    SizedBox(height: 12.h),

                    _RegistrationStep(
                      icon: Icons.badge_outlined,
                      title: 'Owner verification',
                      subtitle: 'Identity documents and selfie',
                      status: controller.ownerVerificationStatus.value,
                      onTap: controller.goToOwnerVerification,
                    ),
                    SizedBox(height: 12.h),

                    _RegistrationStep(
                      icon: Icons.description_outlined,
                      title: 'Business documents',
                      subtitle: 'Upload required documents',
                      status: controller.businessDocsStatus.value,
                      onTap: controller.goToBusinessDocs,
                    ),
                    SizedBox(height: 12.h),

                    _RegistrationStep(
                      icon: Icons.account_balance_outlined,
                      title: 'Bank account',
                      subtitle: 'Payout bank account submission',
                      status: controller.bankAccountStatus.value,
                      onTap: controller.goToBankAccount,
                    ),
                    SizedBox(height: 12.h),

                    _RegistrationStep(
                      icon: Icons.verified_outlined,
                      title: 'Tax information',
                      subtitle: 'Business tax details',
                      status: controller.taxInfoStatus.value,
                      onTap: controller.goToTaxInfo,
                    ),
                  ],
                ),
              ),
            ),

            // Submit button
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: controller.canSubmit ? controller.submitApplication : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.brandColor,
                    disabledBackgroundColor: ColorConstant.lightGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Submit Application',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
}

class _RegistrationStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status; // 'not_started' | 'in_progress' | 'completed' | 'pending_review'
  final VoidCallback onTap;

  const _RegistrationStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    Color statusBgColor;

    switch (status) {
      case 'completed':
        statusColor = ColorConstant.green;
        statusText = 'Completed';
        statusBgColor = ColorConstant.lightGreen;
        break;
      case 'in_progress':
        statusColor = ColorConstant.orange;
        statusText = 'In progress';
        statusBgColor = ColorConstant.lightAmber;
        break;
      case 'pending_review':
        statusColor = ColorConstant.brandColor;
        statusText = 'Pending review';
        statusBgColor = ColorConstant.fadedPurpleAccent;
        break;
      default:
        statusColor = ColorConstant.darkGrey;
        statusText = 'Not started';
        statusBgColor = ColorConstant.lightestGrey;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorConstant.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: ColorConstant.fadedPurpleAccent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: ColorConstant.brandColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right,
              color: ColorConstant.darkGrey,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
