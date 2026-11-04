import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_docs_controller.dart';
import '../../../widgets/custom_button.dart';

class BusinessDocsView extends GetView<BusinessDocsController> {
  const BusinessDocsView({super.key});

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
          'Business Documents',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.samantic,
          ),
        ),
      ),
      body: Column(
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
                            'Upload required business documents to verify your business registration.',
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

                  Text(
                    'Required Documents',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Business Registration Certificate
                  _DocumentUploadCard(
                    title: 'Business Registration Certificate',
                    subtitle: 'CAC or business registration certificate',
                    iconData: Icons.verified_outlined,
                    imagePath: controller.businessRegPath,
                    onTap: controller.uploadBusinessReg,
                    isRequired: true,
                  ),
                  SizedBox(height: 12.h),

                  // Tax Identification
                  _DocumentUploadCard(
                    title: 'Tax Identification Number (TIN)',
                    subtitle: 'Federal Inland Revenue certificate',
                    iconData: Icons.receipt_long_outlined,
                    imagePath: controller.tinPath,
                    onTap: controller.uploadTin,
                    isRequired: true,
                  ),
                  SizedBox(height: 12.h),

                  // Food Safety Certificate (Conditional)
                  _DocumentUploadCard(
                    title: 'Food Safety Certificate',
                    subtitle: 'Required for restaurants and food businesses',
                    iconData: Icons.food_bank_outlined,
                    imagePath: controller.foodSafetyCertPath,
                    onTap: controller.uploadFoodSafetyCert,
                    isRequired: false,
                  ),
                  SizedBox(height: 12.h),

                  // Business Permit
                  _DocumentUploadCard(
                    title: 'Business Permit/License',
                    subtitle: 'Local government business permit',
                    iconData: Icons.approval_outlined,
                    imagePath: controller.businessPermitPath,
                    onTap: controller.uploadBusinessPermit,
                    isRequired: false,
                  ),
                  SizedBox(height: 24.h),

                  // Additional documents section
                  Text(
                    'Additional Documents (Optional)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Upload any other relevant business documents',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Additional documents list
                  Obx(
                    () => controller.additionalDocs.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            children: controller.additionalDocs
                                .map((doc) => Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: _AdditionalDocCard(
                                        fileName: doc['name'] ?? '',
                                        onRemove: () => controller.removeAdditionalDoc(doc),
                                      ),
                                    ))
                                .toList(),
                          ),
                  ),

                  // Add document button
                  GestureDetector(
                    onTap: controller.addAdditionalDoc,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: ColorConstant.brandColor,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: ColorConstant.brandColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Add Another Document',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.brandColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Tips
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
                              Icons.tips_and_updates_outlined,
                              color: ColorConstant.green,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Document Guidelines',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        _TipItem('Upload clear, readable copies'),
                        _TipItem('Documents should be valid and not expired'),
                        _TipItem('PDF or image formats accepted'),
                        _TipItem('File size should not exceed 10MB'),
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
              onPressed: controller.saveDocuments,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final RxString imagePath;
  final VoidCallback onTap;
  final bool isRequired;

  const _DocumentUploadCard({
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.imagePath,
    required this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: imagePath.value.isEmpty
                  ? ColorConstant.borderColor
                  : ColorConstant.green,
              width: imagePath.value.isEmpty ? 1 : 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: imagePath.value.isEmpty
                      ? ColorConstant.lightestGrey
                      : ColorConstant.lightGreen,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  imagePath.value.isEmpty ? iconData : Icons.check_circle,
                  color: imagePath.value.isEmpty
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.samantic,
                            ),
                          ),
                        ),
                        if (isRequired)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: ColorConstant.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Required',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      imagePath.value.isEmpty ? subtitle : 'Uploaded',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: imagePath.value.isEmpty
                            ? ColorConstant.darkGrey
                            : ColorConstant.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                imagePath.value.isEmpty ? Icons.upload_outlined : Icons.edit,
                color: ColorConstant.brandColor,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdditionalDocCard extends StatelessWidget {
  final String fileName;
  final VoidCallback onRemove;

  const _AdditionalDocCard({
    required this.fileName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorConstant.lightGreen,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorConstant.green),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, color: ColorConstant.green, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              fileName,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorConstant.samantic,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: ColorConstant.red, size: 20.sp),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem(this.text);

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
              color: ColorConstant.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorConstant.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
