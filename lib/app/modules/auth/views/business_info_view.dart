import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_info_controller.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class BusinessInfoView extends GetView<BusinessInfoController> {
  const BusinessInfoView({super.key});

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
          'Business Information',
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
                    // Display selected business type
                    Obx(() => controller.selectedBusinessCategory.value.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.all(12.w),
                            margin: EdgeInsets.only(bottom: 20.h),
                            decoration: BoxDecoration(
                              color: ColorConstant.fadedPurpleAccent,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: ColorConstant.brandColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.brandColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    controller.selectedBusinessCategory.value == 'restaurant'
                                        ? Icons.restaurant_outlined
                                        : Icons.shopping_basket_outlined,
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
                                        'Business Type',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: ColorConstant.darkGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        controller.selectedBusinessCategory.value == 'restaurant'
                                            ? 'Restaurant'
                                            : 'Grocery / Supermarket',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: ColorConstant.brandColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: ColorConstant.brandColor,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()),

                    // Business Logo
                    Center(
                      child: GestureDetector(
                        onTap: controller.pickLogo,
                        child: Obx(
                          () {
                            final logoPathValue = controller.logoPath.value;
                            final hasLogo = logoPathValue.isNotEmpty;
                            final isNetworkImage = hasLogo && (logoPathValue.startsWith('http://') || logoPathValue.startsWith('https://'));
                            final isLocalFile = hasLogo && !isNetworkImage;
                            
                            return Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                color: ColorConstant.lightestGrey,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: ColorConstant.borderColor,
                                  width: 2,
                                ),
                                image: hasLogo
                                    ? DecorationImage(
                                        image: isNetworkImage
                                            ? NetworkImage(logoPathValue)
                                            : FileImage(File(logoPathValue)) as ImageProvider,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: !hasLogo
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 32.sp,
                                          color: ColorConstant.darkGrey,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Add Logo',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorConstant.darkGrey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Business Type
                    Text(
                      'Business Type',
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
                            value: controller.businessType.value.isEmpty
                                ? null
                                : controller.businessType.value,
                            hint: Text(
                              'Select business type',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorConstant.darkGrey,
                              ),
                            ),
                            isExpanded: true,
                            items: [
                              'Restaurant',
                              'Cafe',
                              'Grocery Store',
                              'Bakery',
                              'Pharmacy',
                              'Convenience Store',
                              'Other',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.businessType.value = value;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Business Name
                    CustomTextField(
                      controller: controller.businessNameController,
                      label: 'Business Name',
                      hint: 'Enter your business name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter business name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Business Phone
                    CustomTextField(
                      controller: controller.businessPhoneController,
                      label: 'Business Phone',
                      hint: 'Enter business phone number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter business phone';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Business Email
                    CustomTextField(
                      controller: controller.businessEmailController,
                      label: 'Business Email',
                      hint: 'Enter business email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter business email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Business Address
                    Text(
                      'Business Address',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: controller.streetAddressController,
                      label: 'Street Address',
                      hint: 'Enter street address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter street address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: controller.cityController,
                            label: 'City',
                            hint: 'Enter city',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomTextField(
                            controller: controller.stateController,
                            label: 'State',
                            hint: 'Enter state',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: controller.postalCodeController,
                      label: 'Postal Code',
                      hint: 'Enter postal code',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter postal code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Business Description
                    CustomTextField(
                      controller: controller.descriptionController,
                      label: 'Business Description (Optional)',
                      hint: 'Tell us about your business',
                      maxLines: 4,
                    ),
                    SizedBox(height: 24.h),

                    // Operating Hours
                    Text(
                      'Operating Hours',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.selectOpenTime(context),
                            child: Obx(
                              () => Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorConstant.borderColor),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Opens',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorConstant.darkGrey,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      controller.openTime.value.isEmpty
                                          ? '09:00 AM'
                                          : controller.openTime.value,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant.samantic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.selectCloseTime(context),
                            child: Obx(
                              () => Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorConstant.borderColor),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Closes',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorConstant.darkGrey,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      controller.closeTime.value.isEmpty
                                          ? '09:00 PM'
                                          : controller.closeTime.value,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant.samantic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                // Old single-page flow - replaced by 5-step flow
                // Use BusinessTypeSelectionView instead
                onPressed: () {
                  Get.snackbar(
                    'Notice',
                    'Please use the new 5-step business registration flow from Business Documents',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
