import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/owner_verification_controller.dart';
import 'id_front_upload_view.dart';

class IdTypeSelectionView extends GetView<OwnerVerificationController> {
  const IdTypeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    print('[IdTypeSelectionView] Building view...');
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 20.sp,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Owner information',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Your personal details as the business owner',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstant.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Select government-issued ID you\'ll use',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // NIN Card
                    Obx(() => _IdTypeCard(
                      icon: '🪪',
                      title: 'National Identity Card (NIN)',
                      subtitle: 'Nigerian national ID with NIN number',
                      isSelected: controller.idType.value == 'nin',
                      onTap: () => controller.idType.value = 'nin',
                    )),
                    SizedBox(height: 12.h),

                    // International Passport
                    Obx(() => _IdTypeCard(
                      icon: '🛂',
                      title: 'International Passport',
                      subtitle: 'Valid travel passport',
                      isSelected: controller.idType.value == 'passport',
                      onTap: () => controller.idType.value = 'passport',
                    )),
                    SizedBox(height: 12.h),

                    // Driver's License
                    Obx(() => _IdTypeCard(
                      icon: '🚗',
                      title: 'Driver\'s License',
                      subtitle: 'FRSC-issued driving license',
                      isSelected: controller.idType.value == 'drivers_license',
                      onTap: () => controller.idType.value = 'drivers_license',
                    )),
                    SizedBox(height: 12.h),

                    // Voter's Card
                    Obx(() => _IdTypeCard(
                      icon: '🗳️',
                      title: 'Voter\'s Card',
                      subtitle: 'INEC permanent voter card',
                      isSelected: controller.idType.value == 'voters_card',
                      onTap: () => controller.idType.value = 'voters_card',
                    )),
                    SizedBox(height: 20.h),

                    // Info text
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.greyCard,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: ColorConstant.darkColor,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: 'Your ID must be: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'Government-issued, not expired, clearly legible, and show your full name and photo.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Continue button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Obx(() => ElevatedButton(
            onPressed: controller.idType.value.isNotEmpty
                ? () {
                    Get.to(() => const IdFrontUploadView());
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.brandColor,
              minimumSize: Size(double.infinity, 56.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.white,
              ),
            ),
          )),
        ),
      ),
    );
  }
}

class _IdTypeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _IdTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected? ColorConstant.lightPurpleAccent: ColorConstant.white,
          border: Border.all(
            color: isSelected? ColorConstant.brandColor: ColorConstant.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 28.sp),
                ),
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.blackGrey,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorConstant.lighengrey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: ColorConstant.brandColor,
                size: 24.sp,
              )
            else
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
