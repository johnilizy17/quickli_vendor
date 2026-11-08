import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/business_docs_controller.dart';

class KycDocumentsView extends GetView<BusinessDocsController> {
  const KycDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
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
                          'Business Documents',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Upload your business registration documents',
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

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // CAC Certificate section
                  Text(
                    'CAC Registration Certificate *',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Upload your Corporate Affairs Commission (CAC) certificate',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => _DocumentUploadCard(
                    icon: Icons.description_outlined,
                    label: controller.businessRegPath.value.isEmpty
                        ? 'Upload CAC Certificate'
                        : 'CAC Certificate Selected',
                    fileName: controller.businessRegPath.value.isNotEmpty
                        ? controller.businessRegPath.value.split('/').last
                        : null,
                    onTap: controller.uploadBusinessReg,
                    onRemove: controller.businessRegPath.value.isNotEmpty
                        ? () {
                            controller.businessRegFile.value = null;
                            controller.businessRegPath.value = '';
                          }
                        : null,
                  )),
                  SizedBox(height: 16.h),

                  // CAC Number field
                  CustomTextField(
                    controller: controller.cacNumberController,
                    label: 'CAC Registration Number *',
                    hint: 'Enter CAC number (e.g., RC123456)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CAC number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // TIN section
                  Text(
                    'Tax Identification Number (TIN) *',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Upload your TIN certificate or FIRS tax clearance',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => _DocumentUploadCard(
                    icon: Icons.receipt_long_outlined,
                    label: controller.tinPath.value.isEmpty
                        ? 'Upload TIN Document'
                        : 'TIN Document Selected',
                    fileName: controller.tinPath.value.isNotEmpty
                        ? controller.tinPath.value.split('/').last
                        : null,
                    onTap: controller.uploadTin,
                    onRemove: controller.tinPath.value.isNotEmpty
                        ? () {
                            controller.tinFile.value = null;
                            controller.tinPath.value = '';
                          }
                        : null,
                  )),
                  SizedBox(height: 24.h),

                  // Optional documents section
                  Text(
                    'Additional Documents (Optional)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Upload food safety certificate, business permit, or other relevant documents',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => _DocumentUploadCard(
                    icon: Icons.verified_outlined,
                    label: controller.foodSafetyCertPath.value.isEmpty
                        ? 'Upload Food Safety Certificate'
                        : 'Food Safety Certificate Selected',
                    fileName: controller.foodSafetyCertPath.value.isNotEmpty
                        ? controller.foodSafetyCertPath.value.split('/').last
                        : null,
                    onTap: controller.uploadFoodSafetyCert,
                    onRemove: controller.foodSafetyCertPath.value.isNotEmpty
                        ? () {
                            controller.foodSafetyCertFile.value = null;
                            controller.foodSafetyCertPath.value = '';
                          }
                        : null,
                  )),
                  SizedBox(height: 12.h),
                  Obx(() => _DocumentUploadCard(
                    icon: Icons.business_outlined,
                    label: controller.businessPermitPath.value.isEmpty
                        ? 'Upload Business Permit'
                        : 'Business Permit Selected',
                    fileName: controller.businessPermitPath.value.isNotEmpty
                        ? controller.businessPermitPath.value.split('/').last
                        : null,
                    onTap: controller.uploadBusinessPermit,
                    onRemove: controller.businessPermitPath.value.isNotEmpty
                        ? () {
                            controller.businessPermitFile.value = null;
                            controller.businessPermitPath.value = '';
                          }
                        : null,
                  )),
                  SizedBox(height: 80.h), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom save button with SafeArea
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() => GestureDetector(
            onTap: controller.isUploading.value
                ? null
                : () => controller.saveDocuments(),
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: controller.isUploading.value
                    ? Colors.grey.shade400
                    : ColorConstant.brandColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: controller.isUploading.value
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Save & Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          )),
        ),
      ),
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? fileName;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _DocumentUploadCard({
    required this.icon,
    required this.label,
    this.fileName,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasFile = fileName != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: hasFile
              ? ColorConstant.brandColor.withOpacity(0.05)
              : ColorConstant.whiteCard,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasFile
                ? ColorConstant.brandColor.withOpacity(0.3)
                : ColorConstant.borderColor,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: hasFile
                    ? ColorConstant.brandColor.withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                hasFile ? Icons.check_circle : icon,
                color: hasFile ? ColorConstant.brandColor : ColorConstant.darkGrey,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: hasFile
                          ? ColorConstant.brandColor
                          : ColorConstant.samantic,
                    ),
                  ),
                  if (hasFile) ...[
                    SizedBox(height: 2.h),
                    Text(
                      fileName!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: ColorConstant.darkGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12.w),
            if (hasFile && onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ),
              )
            else
              Icon(
                Icons.upload_file,
                color: ColorConstant.darkGrey,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
