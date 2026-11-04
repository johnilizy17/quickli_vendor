import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/tax_info_controller.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class TaxInfoView extends GetView<TaxInfoController> {
  const TaxInfoView({super.key});

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
          'Tax Information',
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
                              'Provide your tax information for compliance and reporting purposes.',
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

                    // Tax Identification Number (TIN)
                    CustomTextField(
                      controller: controller.tinController,
                      label: 'Tax Identification Number (TIN)',
                      hint: 'Enter your TIN',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter TIN';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // VAT Registration Number (Optional)
                    CustomTextField(
                      controller: controller.vatNumberController,
                      label: 'VAT Registration Number (Optional)',
                      hint: 'Enter VAT number if registered',
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 16.h),

                    // Business Registration Number
                    CustomTextField(
                      controller: controller.businessRegNumberController,
                      label: 'Business Registration Number',
                      hint: 'Enter CAC registration number',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter business registration number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Tax Office
                    CustomTextField(
                      controller: controller.taxOfficeController,
                      label: 'Tax Office',
                      hint: 'Enter your tax office location',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tax office';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // VAT Registered Toggle
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: ColorConstant.borderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VAT Registered',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.samantic,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Are you registered for VAT?',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: ColorConstant.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => Switch(
                              value: controller.isVatRegistered.value,
                              onChanged: (value) {
                                controller.isVatRegistered.value = value;
                              },
                              activeColor: ColorConstant.brandColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Tax Certificate Upload
                    Text(
                      'Tax Certificate',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Upload your tax clearance certificate',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ColorConstant.darkGrey,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Obx(
                      () => GestureDetector(
                        onTap: controller.uploadTaxCertificate,
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: controller.taxCertificatePath.value.isEmpty
                                  ? ColorConstant.borderColor
                                  : ColorConstant.green,
                              width: controller.taxCertificatePath.value.isEmpty ? 1 : 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: controller.taxCertificatePath.value.isEmpty
                                      ? ColorConstant.lightestGrey
                                      : ColorConstant.lightGreen,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  controller.taxCertificatePath.value.isEmpty
                                      ? Icons.upload_file_outlined
                                      : Icons.check_circle,
                                  color: controller.taxCertificatePath.value.isEmpty
                                      ? ColorConstant.darkGrey
                                      : ColorConstant.green,
                                  size: 24.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tax Clearance Certificate',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant.samantic,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      controller.taxCertificatePath.value.isEmpty
                                          ? 'Upload certificate (PDF or Image)'
                                          : 'Uploaded',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: controller.taxCertificatePath.value.isEmpty
                                            ? ColorConstant.darkGrey
                                            : ColorConstant.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                controller.taxCertificatePath.value.isEmpty
                                    ? Icons.upload_outlined
                                    : Icons.edit,
                                color: ColorConstant.brandColor,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Info box
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.lightGreen,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: ColorConstant.green,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Did you know?',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Your tax information helps us comply with local tax regulations and ensures smooth payment processing. All information is kept confidential and secure.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: ColorConstant.green,
                            ),
                          ),
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
                onPressed: controller.saveTaxInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
