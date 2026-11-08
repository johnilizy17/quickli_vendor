import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/application_status_controller.dart';

class ApplicationStatusView extends GetView<ApplicationStatusController> {
  const ApplicationStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                ColorConstant.brandColor,
              ),
            ),
          );
        }

        // Determine status view based on kycStatus
        switch (controller.status.value) {
          case 'approved':
            return _buildApprovedView();
          case 'rejected':
            return _buildRejectedView();
          case 'requested':
          case 'pending':
          default:
            return _buildPendingView();
        }
      }),
    );
  }

  // Pending/Submitted View (First Mockup)
  Widget _buildPendingView() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status Icon - Single Circle based on status
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: controller.status.value == 'rejected'
                          ? Colors.red.withOpacity(0.1)
                          : ColorConstant.lightGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.status.value == 'rejected'
                            ? Colors.red
                            : ColorConstant.green,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      controller.status.value == 'rejected' 
                          ? Icons.close 
                          : Icons.check,
                      size: 40.sp,
                      color: controller.status.value == 'rejected'
                          ? Colors.red
                          : ColorConstant.green,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Title
                  Text(
                    'Application Submitted!',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),

                  // Subtitle
                  Text(
                    'Your application is now under review. You\'ll hear\nfrom us within 1-3 business days.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),

                  // Reference Number Card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorConstant.fadedPurpleAccent,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: ColorConstant.brandColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'REFERENCE NUMBER',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.brandColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          controller.referenceNumber.value,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.brandColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Save this for your records',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstant.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // What Happens Next
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'WHAT HAPPENS NEXT',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.darkGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  _TimelineItem(
                    icon: Icons.search,
                    title: 'Identity review',
                    subtitle: 'We verify your ID and selfie',
                    duration: '1-2 days',
                  ),
                  SizedBox(height: 12.h),

                  _TimelineItem(
                    icon: Icons.description_outlined,
                    title: 'Document review',
                    subtitle: 'Business docs and compliance check',
                    duration: '1-2 days',
                  ),
                  SizedBox(height: 12.h),

                  _TimelineItem(
                    icon: Icons.check_circle,
                    title: 'Final approval',
                    subtitle: 'Account activated and ready to go live',
                    duration: 'Same day',
                    isLast: true,
                  ),
                  SizedBox(height: 24.h),

                  // Email notification
                  if (controller.email.value.isNotEmpty)
                    Text(
                      'We\'ll send updates to ${controller.email.value}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorConstant.darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),

            // Go to Home Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: controller.goToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.brandColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Go to Home',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Rejected View (Second Mockup)
  Widget _buildRejectedView() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),

                    // Error Icon
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 40.sp, color: Colors.red),
                    ),
                    SizedBox(height: 24.h),

                    // Title
                    Text(
                      'Application Rejected',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.samantic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),

                    // Subtitle
                    Text(
                      'Unfortunately your vendor application could not\nbe approved at this time.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.darkGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    // Rejection Reasons Card
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rejection Reasons',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // List rejection reasons
                          if (controller.rejectionReasons.isNotEmpty)
                            ...controller.rejectionReasons.map((reason) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 6.sp,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reason['title'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red[700],
                                            ),
                                          ),
                                          if (reason['description'] !=
                                              null) ...[
                                            SizedBox(height: 4.h),
                                            Text(
                                              reason['description'],
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.red[600],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList()
                          else
                            Text(
                              'No specific reasons provided. Please contact support for details.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.red[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Your Options
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your options:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.brandColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    _OptionItem(
                      text:
                          'File an appeal within 14 days if you believe this is an error',
                    ),
                    _OptionItem(
                      text: 'Fix the issues and reapply with correct documents',
                    ),
                    _OptionItem(text: 'Contact our support team for guidance'),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.resubmitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.brandColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Resubmit Registration',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: controller.contactSupport,
                  child: Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Approved View (Third Mockup)
  Widget _buildApprovedView() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: ColorConstant.lightGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 40.sp,
                      color: ColorConstant.green,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Title
                  Text(
                    'You\'re approved!',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),

                  // Subtitle
                  Text(
                    '${controller.businessName.value} is now a verified Quickli vendor.\nYou\'re almost ready to start receiving orders.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstant.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),

                  // Vendor ID Card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: ColorConstant.lightGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: ColorConstant.green.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VENDOR ID',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.green,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                controller.referenceNumber.value,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: ColorConstant.green.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: ColorConstant.green,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Set up store Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: controller.setupStore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.brandColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Set up store',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

// Timeline Item Widget
class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String duration;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.duration,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: ColorConstant.fadedPurpleAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16.sp, color: ColorConstant.darkGrey),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 24.h,
                color: ColorConstant.borderColor,
                margin: EdgeInsets.symmetric(vertical: 4.h),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                ],
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
      ],
    );
  }
}

// Option Item Widget
class _OptionItem extends StatelessWidget {
  final String text;

  const _OptionItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6.sp, color: ColorConstant.brandColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: ColorConstant.darkGrey),
            ),
          ),
        ],
      ),
    );
  }
}
