import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_documents_controller.dart';

class BusinessDocumentsUploadView extends GetView<BusinessDocumentsController> {
  const BusinessDocumentsUploadView({super.key});

  @override
  Widget build(BuildContext context) {
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
                          'Business documents',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Upload required compliance documents',
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
                    SizedBox(height: 8.h),
                    
                    // Section Title
                    Text(
                      'Regulatory business documents',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Info Box
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.yellowCard,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18.sp,
                            color: ColorConstant.amber,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Please provide at least your TIN or RC/BN Number. Additional documents can be added later if not available now.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorConstant.amber,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // CAC Certificate Upload
                    Text(
                      'CAC Certificate (Optional)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    Obx(() {
                      // Show success if file selected OR URL loaded
                      final hasFile = controller.cacCertificateFile.value != null;
                      final hasUrl = controller.cacCertificatePath.value.isNotEmpty;
                      
                      if (hasFile || hasUrl) {
                        return Column(
                          children: [
                            // Success card
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CAC Certificate',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant.samantic,
                                          ),
                                        ),
                                        Text(
                                          'Uploaded successfully',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.cacCertificateFile.value = null;
                                      controller.cacCertificatePath.value = '';
                                    },
                                    icon: Icon(Icons.close, color: ColorConstant.deepGrey, size: 20.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            // File preview card - Full width
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: ColorConstant.greyCard,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.red,
                                    size: 32.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.cacCertificatePath.value.split('/').last,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant.samantic,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          hasFile 
                                            ? '${(controller.cacCertificateFile.value!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB · Uploaded just now'
                                            : 'Uploaded',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: ColorConstant.deepGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(40.w),
                            decoration: BoxDecoration(
                              color: ColorConstant.greyCard,
                              border: Border.all(
                                color: ColorConstant.greyLight,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.white,
                                    border: Border.all(
                                      color: ColorConstant.greyLight,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 32.sp,
                                    color: ColorConstant.brandColor,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'CAC Certificate',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.samantic,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'PDF, JPG or PNG · Max 15 MB',
                                  style: TextStyle(fontSize: 12.sp, color: ColorConstant.deepGrey),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => controller.uploadCacCertificate(),
                                  label: Text(
                                    '📷 Take Photo',
                                    style: TextStyle(
                                      color: ColorConstant.samantic,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14.h),
                                    side: BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => controller.uploadCacCertificate(),
                                  label: Text(
                                    '📁 Upload File',
                                    style: TextStyle(
                                      color: ColorConstant.samantic,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14.h),
                                    side: BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 24.h),

                    // RC/BN Number
                    Text(
                      'RC/BN Number (Optional)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: controller.cacNumberController,
                      decoration: InputDecoration(
                        hintText: 'Enter your RC/BN Number',
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
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // TIN Section
                    Text(
                      'Tax Identification Number (TIN)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.samantic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: controller.tinController,
                      decoration: InputDecoration(
                        hintText: 'Enter your TIN',
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
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'FIRS-issued TIN certificate or document',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorConstant.deepGrey,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // TIN Certificate Upload (Optional)
                    Obx(() {
                      // Show success if file selected OR URL loaded
                      final hasFile = controller.tinCertificateFile.value != null;
                      final hasUrl = controller.tinCertificatePath.value.isNotEmpty;
                      
                      if (hasFile || hasUrl) {
                        return Column(
                          children: [
                            // Success card
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TIN Certificate',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant.samantic,
                                          ),
                                        ),
                                        Text(
                                          'Uploaded successfully',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.tinCertificateFile.value = null;
                                      controller.tinCertificatePath.value = '';
                                    },
                                    icon: Icon(Icons.close, color: ColorConstant.deepGrey, size: 20.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            // File preview card - Full width
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: ColorConstant.greyCard,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.red,
                                    size: 32.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.tinCertificatePath.value.split('/').last,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ColorConstant.samantic,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          hasFile
                                            ? '${(controller.tinCertificateFile.value!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB · Uploaded just now'
                                            : 'Uploaded',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: ColorConstant.deepGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(40.w),
                            decoration: BoxDecoration(
                              color: ColorConstant.greyCard,
                              border: Border.all(
                                color: ColorConstant.greyLight,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.white,
                                    border: Border.all(
                                      color: ColorConstant.greyLight,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 32.sp,
                                    color: ColorConstant.brandColor,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'TIN Certificate (Optional)',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.samantic,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'PDF, JPG or PNG · Max 15 MB',
                                  style: TextStyle(fontSize: 12.sp, color: ColorConstant.deepGrey),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => controller.uploadTinCertificate(),
                                  label: Text(
                                    '📷 Take Photo',
                                    style: TextStyle(
                                      color: ColorConstant.samantic,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14.h),
                                    side: BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => controller.uploadTinCertificate(),
                                  label: Text(
                                    '📁 Upload File',
                                    style: TextStyle(
                                      color: ColorConstant.samantic,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14.h),
                                    side: BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),

                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Submit Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Obx(() => ElevatedButton(
            onPressed: controller.isUploading.value
                ? null
                : () => controller.submitBusinessDocuments(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.brandColor,
              minimumSize: Size(double.infinity, 56.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: controller.isUploading.value
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Save Document',
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
