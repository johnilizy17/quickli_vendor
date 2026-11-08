import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/business_registration_controller.dart';

// Helper function to format date
String _formatDate(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('MMMM dd, yyyy').format(date);
  } catch (e) {
    return dateStr;
  }
}

class BusinessRegistrationView extends GetView<BusinessRegistrationController> {
  const BusinessRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navigate back to business docs when back button is pressed
          Get.offNamed(Routes.BUSINESS_DOCS);
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ColorConstant.samantic),
            onPressed: () => Get.offNamed(Routes.BUSINESS_DOCS),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review your application',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.samantic,
                ),
              ),
              Text(
                'Check everything before submitting',
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
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorConstant.brandColor,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            // Info banner
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: ColorConstant.fadedPurpleAccent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Review carefully. Our team will use this information to verify your business.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: ColorConstant.darkPurpleAccent,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Owner Account Section
                            _ReviewSection(
                              title: 'Owner Account',
                              children: [
                                _ReviewItem(
                                  label: 'Name',
                                  value: controller.ownerName.value.isNotEmpty
                                      ? controller.ownerName.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Email',
                                  value: controller.ownerEmail.value.isNotEmpty
                                      ? controller.ownerEmail.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Phone',
                                  value: controller.ownerPhone.value.isNotEmpty
                                      ? controller.ownerPhone.value
                                      : 'Not provided',
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            // Business Information Section
                            _ReviewSection(
                              title: 'Business Information',
                              onEdit: controller.goToBusinessInfo,
                              children: [
                                _ReviewItem(
                                  label: 'Name',
                                  value:
                                      controller.businessName.value.isNotEmpty
                                      ? controller.businessName.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Type',
                                  value:
                                      controller.businessType.value.isNotEmpty
                                      ? controller.businessType.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Logo',
                                  value: controller.logoUploaded.value
                                      ? 'Uploaded ✓'
                                      : 'Not uploaded',
                                  valueColor: controller.logoUploaded.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                                _ReviewItem(
                                  label: 'Cover',
                                  value: controller.coverUploaded.value
                                      ? 'Uploaded ✓'
                                      : 'Not uploaded',
                                  valueColor: controller.coverUploaded.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            // Business Address Section
                            _ReviewSection(
                              title: 'Business Address',
                              onEdit: controller.goToBusinessInfo,
                              children: [
                                _ReviewItem(
                                  label: 'Address',
                                  value:
                                      controller
                                          .businessAddress
                                          .value
                                          .isNotEmpty
                                      ? controller.businessAddress.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Country',
                                  value:
                                      controller
                                          .businessCountry
                                          .value
                                          .isNotEmpty
                                      ? controller.businessCountry.value
                                      : 'Not provided',
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            // Owner Verification Section
                            _ReviewSection(
                              title: 'Owner Verification',
                              onEdit: controller.goToOwnerVerification,
                              children: [
                                _ReviewItem(
                                  label: 'DOB',
                                  value: controller.ownerDob.value.isNotEmpty
                                      ? _formatDate(controller.ownerDob.value)
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'ID Type',
                                  value: controller.ownerIdType.value.isNotEmpty
                                      ? controller.ownerIdType.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'ID Front',
                                  value: controller.idFrontUploaded.value
                                      ? 'Uploaded ✓'
                                      : 'Not uploaded',
                                  valueColor: controller.idFrontUploaded.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                                _ReviewItem(
                                  label: 'ID Back',
                                  value: controller.idBackUploaded.value
                                      ? 'Uploaded ✓'
                                      : 'Not uploaded',
                                  valueColor: controller.idBackUploaded.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                                _ReviewItem(
                                  label: 'Selfie',
                                  value: controller.selfieVerified.value
                                      ? 'Verified ✓'
                                      : 'Not uploaded',
                                  valueColor: controller.selfieVerified.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            // Documents Section
                            _ReviewSection(
                              title: 'Documents',
                              onEdit: controller.goToBusinessDocs,
                              children: [
                                _ReviewItem(
                                  label: 'CAC Certificate',
                                  value: controller.cacUploaded.value
                                      ? 'Uploaded ✓'
                                      : 'Not uploaded',
                                  valueColor: controller.cacUploaded.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                                _ReviewItem(
                                  label: 'TIN',
                                  value: controller.tinUploaded.value
                                      ? 'Uploaded ✓'
                                      : 'Not uploaded',
                                  valueColor: controller.tinUploaded.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            // Bank Account Section
                            _ReviewSection(
                              title: 'Bank Account',
                              onEdit: controller.goToBankAccount,
                              children: [
                                _ReviewItem(
                                  label: 'Bank',
                                  value: controller.bankName.value.isNotEmpty
                                      ? controller.bankName.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Account',
                                  value:
                                      controller.accountNumber.value.isNotEmpty
                                      ? '•••• ${controller.accountNumber.value.length > 4 ? controller.accountNumber.value.substring(controller.accountNumber.value.length - 4) : controller.accountNumber.value}'
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Name',
                                  value: controller.accountName.value.isNotEmpty
                                      ? controller.accountName.value
                                      : 'Not provided',
                                ),
                                _ReviewItem(
                                  label: 'Verified',
                                  value: controller.accountVerified.value
                                      ? 'Yes ✓'
                                      : 'No',
                                  valueColor: controller.accountVerified.value
                                      ? ColorConstant.green
                                      : ColorConstant.darkGrey,
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),

                            // Terms checkbox
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: Checkbox(
                                        value: controller.agreedToTerms.value,
                                        onChanged: (value) =>
                                            controller.agreedToTerms.value =
                                                value ?? false,
                                        activeColor: ColorConstant.brandColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: ColorConstant.samantic,
                                          height: 1.4,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text:
                                                'I confirm that all information provided is accurate, and I agree to Quickli\'s ',
                                          ),
                                          TextSpan(
                                            text: 'Vendor Terms of Service',
                                            style: TextStyle(
                                              color: ColorConstant.brandColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: TextStyle(
                                              color: ColorConstant.brandColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const TextSpan(text: '.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 100.h),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 52.h,
                              child: ElevatedButton(
                                onPressed:
                                    controller.canSubmit &&
                                        controller.agreedToTerms.value
                                    ? controller.submitApplication
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.brandColor,
                                  disabledBackgroundColor:
                                      ColorConstant.lightGrey,
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
                          SizedBox(height: 8.h),
                          Text(
                            'You can edit items after submission if needed',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorConstant.darkGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  final List<Widget> children;

  const _ReviewSection({
    required this.title,
    this.onEdit,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorConstant.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorConstant.borderColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                ),
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: Text(
                      'Edit',
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
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ReviewItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: ColorConstant.darkGrey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: valueColor ?? ColorConstant.samantic,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
