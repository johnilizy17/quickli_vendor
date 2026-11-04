import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/api_route.dart';
import '../../../services/api_service.dart';
import '../../../models/vendor_user.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_logger.dart';

class VerificationPendingView extends StatefulWidget {
  const VerificationPendingView({super.key});

  @override
  State<VerificationPendingView> createState() => _VerificationPendingViewState();
}

class _VerificationPendingViewState extends State<VerificationPendingView> {
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // Check verification status periodically (every 20 seconds)
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    Future.delayed(const Duration(seconds: 20), () {
      if (mounted) {
        _checkVerificationStatus();
        _startPeriodicCheck();
      }
    });
  }

  Future<void> _checkVerificationStatus() async {
    if (_isChecking) return;
    
    setState(() => _isChecking = true);
    
    try {
      final response = await ApiService.to.get(ApiRoute.userProfile);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success' && data['data'] != null) {
          final vendor = data['data'];
          final verification = vendor['verification'];
          final kycStatus = verification?['kycStatus'] ?? 'pending';
          final isFullyVerified = verification?['isFullyVerified'] ?? false;
          
          appLog('VerificationPending: Checking status - kycStatus=$kycStatus, isFullyVerified=$isFullyVerified');
          
          // Update vendor user data
          VendorUser.setUser(vendor);
          
          // If verified, navigate to wrapper
          if (isFullyVerified || kycStatus == 'verified') {
            appLog('VerificationPending: Verification approved! Navigating to wrapper');
            Get.offAllNamed(Routes.WRAPPER);
          } else if (kycStatus == 'rejected') {
            // If rejected, go back to auth for re-submission
            appLog('VerificationPending: Verification rejected. Navigating to auth');
            Get.offAllNamed(Routes.AUTH);
          }
        }
      }
    } catch (e) {
      appLog('VerificationPending: Error checking status: $e');
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pending Icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: ColorConstant.fadedPurpleAccent,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    size: 48.sp,
                    color: ColorConstant.brandColor,
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Title
                Text(
                  'Verification Pending',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.darkColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 12.h),
                
                // Description
                Text(
                  'Your account is under review.\nVerification should be completed\nwithin 24 hours.',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: ColorConstant.darkGrey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 48.h),
                
                // Refresh Button
                GestureDetector(
                  onTap: _isChecking ? null : _checkVerificationStatus,
                  child: Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: _isChecking 
                          ? ColorConstant.lightestGrey 
                          : ColorConstant.brandColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    alignment: Alignment.center,
                    child: _isChecking
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ColorConstant.brandColor,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Check Status',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Contact Support Button (optional)
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to support or open support dialog
                    Get.snackbar(
                      'Contact Support',
                      'Support feature coming soon',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: ColorConstant.brandColor,
                      colorText: Colors.white,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConstant.brandColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Contact Support',
                      style: TextStyle(
                        color: ColorConstant.brandColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Logout Button
                TextButton(
                  onPressed: () {
                    ApiService.to.clearTokens();
                    VendorUser.clear();
                    Get.offAllNamed(Routes.AUTH);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: ColorConstant.darkGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
