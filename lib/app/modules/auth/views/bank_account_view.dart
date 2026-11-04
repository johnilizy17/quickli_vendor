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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConstant.samantic),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Bank Account',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.samantic,
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info banner
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.fadedPurpleAccent,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ColorConstant.brandColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Add your bank account details to receive payments from Quickli. Ensure the account name matches your business registration.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorConstant.samantic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Bank Selection
                    Text(
                      'Select Bank',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.borderColor),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedBank.value.isEmpty
                                ? null
                                : controller.selectedBank.value,
                            hint: Text(
                              'Select your bank',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorConstant.darkGrey,
                              ),
                            ),
                            isExpanded: true,
                            items: controller.banks.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedBank.value = value;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Account Number
                    CustomTextField(
                      controller: controller.accountNumberController,
                      label: 'Account Number',
                      hint: 'Enter account number',
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: controller.verifyAccountNumber,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        if (value.length != 10) {
                          return 'Account number must be 10 digits';
                        }
                        return null;
                      },
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
                                    color: ColorConstant.lightGreen,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: ColorConstant.green,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: ColorConstant.green,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Account Name',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: ColorConstant.green,
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
                    SizedBox(height: 16.h),

                    // BVN (Optional but recommended)
                    CustomTextField(
                      controller: controller.bvnController,
                      label: 'BVN (Optional)',
                      hint: 'Enter BVN for faster verification',
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                    ),
                    SizedBox(height: 24.h),

                    // Account Type
                    Text(
                      'Account Type',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: _AccountTypeCard(
                              title: 'Savings',
                              icon: Icons.savings_outlined,
                              isSelected: controller.accountType.value == 'savings',
                              onTap: () => controller.accountType.value = 'savings',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _AccountTypeCard(
                              title: 'Current',
                              icon: Icons.account_balance_outlined,
                              isSelected: controller.accountType.value == 'current',
                              onTap: () => controller.accountType.value = 'current',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Important Notice
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.lightAmber.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: ColorConstant.amber.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_outlined,
                                color: ColorConstant.amber,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Important Notice',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.amber,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _NoticeItem('Account name must match business name'),
                          _NoticeItem('Only Nigerian bank accounts are supported'),
                          _NoticeItem('Payout settlements occur within 24-48 hours'),
                          _NoticeItem('Ensure account is active and not restricted'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
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
              child: CustomButton(
                text: 'Save & Continue',
                onPressed: controller.saveBankAccount,
              ),
            ),
          ],
        ),
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
