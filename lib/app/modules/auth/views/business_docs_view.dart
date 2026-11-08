import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/business_docs_controller.dart';
import '../controllers/business_info_controller.dart';
import '../../owner_verification/controllers/owner_verification_controller.dart';
import '../../owner_verification/views/id_type_selection_view.dart';
import '../../business_documents/controllers/business_documents_controller.dart';
import '../../business_documents/views/business_documents_upload_view.dart';
import '../controllers/bank_account_controller.dart';
import 'business_type_selection_view.dart';
import 'kyc_documents_view.dart';
import 'bank_account_view.dart';

class BusinessDocsView extends GetView<BusinessDocsController> {
  const BusinessDocsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Go back to login when hardware/gesture back is triggered
          Get.offAllNamed('/auth');
        }
      },
      child: Scaffold(
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
                    onTap: () {
                      // Go back to login instead of previous screen
                      Get.offAllNamed('/auth');
                    },
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
                          'Register your business',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Get started with Quickli in under 5 -15 minutes',
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
            child: RefreshIndicator(
              onRefresh: () async {
                print('[BusinessDocs] 🔄 Pull-to-refresh triggered');
                await controller.loadSavedData();
              },
              color: ColorConstant.brandColor,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(), // Enable refresh even when content fits
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      'Submit the required information so our team can verify your account.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorConstant.deepGrey,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Progress section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                          '${controller.completedSections.value} of 4 completed',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.samantic,
                          ),
                        )),
                        Obx(() => Text(
                          '${controller.progressPercentage.value}%',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.gradientStart,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Progress bar
                    Obx(() => ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: controller.progressPercentage.value / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorConstant.brandColor,
                        ),
                        minHeight: 8.h,
                      ),
                    )),
                    SizedBox(height: 20.h),

                    // Warning banner
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.yellowCard,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'You cannot go online until all required items are approved or conditionally accepted.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorConstant.amber,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Business information section
                    Obx(() => _RegistrationSection(
                      icon: Icons.person_2_outlined,
                      iconColor: ColorConstant.gradientStart,
                      iconBgColor: ColorConstant.fadedPurpleAccent,
                      title: 'Business information',
                      subtitle: 'Type, name, logo, and address',
                      status: controller.businessInfoStatus.value,
                      onTap: () async {
                        // Initialize BusinessInfoController before navigation
                        Get.put(BusinessInfoController());
                        await Get.to(() => const BusinessTypeSelectionView());
                        
                        // Refresh verification status when returning
                        controller.loadSavedData();
                      },
                    )),
                    SizedBox(height: 12.h),

                    // Owner verification section
                    Obx(() => _RegistrationSection(
                      icon: Icons.badge_outlined,
                      iconColor: Colors.blue,
                      iconBgColor: Colors.blue.shade50,
                      title: 'Owner verification',
                      subtitle: 'Identity documents and selfie',
                      status: controller.ownerVerificationStatus.value,
                      onTap: () async {
                        print('[BusinessDocs] Owner verification tapped');
                        try {
                          // Clean up any existing controller
                          if (Get.isRegistered<OwnerVerificationController>()) {
                            print('[BusinessDocs] Removing existing controller...');
                            Get.delete<OwnerVerificationController>();
                          }
                          
                          print('[BusinessDocs] Creating OwnerVerificationController...');
                          final ownerController = Get.put(OwnerVerificationController());
                          print('[BusinessDocs] Controller created: ${ownerController.runtimeType}');
                          
                          print('[BusinessDocs] Navigating to IdTypeSelectionView...');
                          await Get.to(() => const IdTypeSelectionView());
                          
                          print('[BusinessDocs] Returned from owner verification, refreshing data...');
                          // Refresh verification status when returning
                          await controller.loadSavedData();
                        } catch (e, stackTrace) {
                          print('[BusinessDocs] ❌ Error navigating to owner verification: $e');
                          print('[BusinessDocs] Stack trace: $stackTrace');
                          Get.snackbar(
                            'Navigation Error',
                            'Failed to open owner verification: ${e.toString()}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                    )),
                    SizedBox(height: 12.h),

                    // Business documents section
                    Obx(() => _RegistrationSection(
                      icon: Icons.description_outlined,
                      iconColor: Colors.blue,
                      iconBgColor: Colors.blue.shade50,
                      title: 'Business documents',
                      subtitle: 'Upload required documents',
                      status: controller.businessDocsStatus.value,
                      onTap: () async {
                        print('[BusinessDocs] Business documents tapped');
                        
                        try {
                          // Clean up any existing controller
                          if (Get.isRegistered<BusinessDocumentsController>()) {
                            print('[BusinessDocs] Removing existing business documents controller...');
                            Get.delete<BusinessDocumentsController>();
                          }
                          
                          print('[BusinessDocs] Creating BusinessDocumentsController...');
                          Get.put(BusinessDocumentsController());
                          
                          await Get.to(() => const BusinessDocumentsUploadView());
                          
                          print('[BusinessDocs] Returned from business documents, refreshing data...');
                          // Refresh verification status when returning
                          await controller.loadSavedData();
                        } catch (e, stackTrace) {
                          print('[BusinessDocs] ❌ Error navigating to business documents: $e');
                          print('[BusinessDocs] Stack trace: $stackTrace');
                          Get.snackbar(
                            'Navigation Error',
                            'Failed to open business documents: ${e.toString()}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                    )),
                    SizedBox(height: 12.h),

                    // Bank account section
                    Obx(() => _RegistrationSection(
                      icon: Icons.account_balance_outlined,
                      iconColor: Colors.blue,
                      iconBgColor: Colors.blue.shade50,
                      title: 'Bank account',
                      subtitle: 'Payout bank account submission',
                      status: controller.bankAccountStatus.value,
                      onTap: () async {
                        Get.put(BankAccountController());
                        await Get.to(() => const BankAccountView());
                        
                        // Refresh verification status when returning
                        controller.loadSavedData();
                      },
                    )),

                    SizedBox(height: 80.h), // Space for button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          child: GestureDetector(
            onTap: () async {
              print('[BusinessDocsView] ========== BUTTON TAPPED ==========');
              print('[BusinessDocsView] Controller instance: ${controller.runtimeType}');
              print('[BusinessDocsView] About to call controller.submitApplication()');
              try {
                await controller.submitApplication();
                print('[BusinessDocsView] ✅ Controller method completed');
              } catch (e, stackTrace) {
                print('[BusinessDocsView] ❌ Error calling controller: $e');
                print('[BusinessDocsView] ❌ Stack: $stackTrace');
              }
              print('[BusinessDocsView] ========== BUTTON TAP COMPLETE ==========');
            },
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: ColorConstant.brandColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
      ), // Close Scaffold
    ); // Close PopScope
  }
}

class _RegistrationSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String status; // 'not_started', 'in_progress', 'completed'
  final VoidCallback onTap;

  const _RegistrationSection({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorConstant.whiteCard,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorConstant.whiteCard,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.samantic,
                    ),
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
            SizedBox(width: 12.w),
            // Status badge and arrow stacked vertically
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: ColorConstant.darkGrey,
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In progress';
      case 'not_started':
      default:
        return 'Not started';
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'not_started':
      default:
        return Colors.orange;
    }
  }
}
