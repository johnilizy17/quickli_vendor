import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/bank_account_controller.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class BankAccountView extends GetView<BankAccountController> {
  const BankAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with SafeArea
          SafeArea(
            child: Padding(
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
                          'Bank Account',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Where should we send your payouts?',
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
          ),
          
          Expanded(
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    
                    // Section Title
                    Text(
                      'Payouts account details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    
                    // Info banner
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.fadedPurpleAccent,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Your bank details are encrypted and only used to process vendor payouts. Quickli uses bank-grade security.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorConstant.samantic,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Bank Selection
                    Text(
                      'Bank name *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => GestureDetector(
                        onTap: () => controller.showBankSelectionDialog(),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: ColorConstant.greyCard,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_balance,
                                size: 20.sp,
                                color: controller.selectedBank.value.isEmpty
                                    ? ColorConstant.lighengrey
                                    : ColorConstant.brandColor,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  controller.selectedBank.value.isEmpty
                                      ? 'Select your bank'
                                      : controller.selectedBank.value,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: controller.selectedBank.value.isEmpty
                                        ? FontWeight.w400
                                        : FontWeight.w600,
                                    color: controller.selectedBank.value.isEmpty
                                        ? ColorConstant.lighengrey
                                        : ColorConstant.samantic,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.sp,
                                color: ColorConstant.darkGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Account Number
                    Text(
                      'Account number (10 digits) *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: controller.accountNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: controller.verifyAccountNumber,
                      decoration: InputDecoration(
                        hintText: '0123456789',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.lighengrey,
                        ),
                        filled: true,
                        fillColor: ColorConstant.greyCard,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        counterText: '', // Hide character counter
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Account Name (Auto-filled after verification)
                    Obx(
                      () => controller.isVerifying.value
                          ? Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: ColorConstant.lightestGrey,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16.w,
                                    height: 16.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorConstant.brandColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Verifying account...',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: ColorConstant.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : controller.accountName.value.isNotEmpty
                              ? Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Account verified',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.green.shade700,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              controller.accountName.value,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: ColorConstant.samantic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ),
                    
                    // Payout schedule info
                    if (controller.accountName.value.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      Text(
                        'Payout schedule:',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.samantic,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _PayoutInfoItem('Weekly payouts every Thursday'),
                      _PayoutInfoItem('Funds arrive in 1-2 business days'),
                      _PayoutInfoItem('Minimum payout: ₦5,000'),
                      _PayoutInfoItem('Instant payout available (fee applies)'),
                    ],

                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ),

          // Save Button with SafeArea
          SafeArea(
            child: Container(
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
              child: Obx(() => ElevatedButton(
                onPressed: controller.accountName.value.isEmpty
                    ? null
                    : controller.saveBankAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.brandColor,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(
                  'Save Bank Account',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.white,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.title,
    required this.icon,
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
          color: isSelected
              ? ColorConstant.fadedPurpleAccent
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? ColorConstant.brandColor
                : ColorConstant.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? ColorConstant.brandColor
                  : ColorConstant.darkGrey,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? ColorConstant.brandColor
                    : ColorConstant.samantic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoticeItem extends StatelessWidget {
  final String text;
  const _NoticeItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: ColorConstant.amber,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorConstant.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _PayoutInfoItem extends StatelessWidget {
  final String text;
  const _PayoutInfoItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorConstant.deepGrey,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: ColorConstant.deepGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
