import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/image_constant.dart';
import '../controllers/menu_controller.dart';

class MenuView extends GetView<VendorMenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorConstant.samantic),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'More',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Refer & Earn Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorConstant.brandColor,
                    ColorConstant.brandColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refer & Earn Cash',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Earn ₦5,000 for every vendor you invite that\nactivates their shop.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: controller.referVendor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ColorConstant.brandColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                      ),
                      child: Text(
                        'Refer a Vendor',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // BUSINESS Section
            _buildSectionHeader('BUSINESS'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.business,
                    iconBg: ColorConstant.lightGreen,
                    title: 'Business Profile',
                    subtitle: 'Name, logo, phone, address',
                    onTap: controller.goToBusinessProfile,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.time,
                    iconBg: ColorConstant.fadedPurpleAccent,
                    title: 'Operating Hours',
                    subtitle: 'Mon-Sun schedule',
                    onTap: controller.goToOperatingHours,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.bike,
                    iconBg: Colors.orange.shade50,
                    title: 'Delivery & Pickup',
                    subtitle: 'Setup, minimum, fees',
                    onTap: controller.goToDeliveryPickup,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // OPERATIONS Section
            _buildSectionHeader('OPERATIONS'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.inventory,
                    iconBg: Colors.brown.shade50,
                    title: 'Inventory',
                    badge: '3 low',
                    badgeColor: Colors.orange,
                    onTap: controller.goToInventory,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.sales,
                    iconBg: Colors.blue.shade50,
                    title: 'Sales Dashboard',
                    onTap: controller.goToSalesDashboard,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.promotion,
                    iconBg: Colors.red.shade50,
                    title: 'Promotions',
                    onTap: controller.goToPromotions,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.branch,
                    iconBg: Colors.grey.shade100,
                    title: 'Branch Settings',
                    onTap: controller.goToBranchSettings,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // REPORTS Section
            _buildSectionHeader('REPORTS'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.report,
                    iconBg: Colors.brown.shade50,
                    title: 'Reports',
                    onTap: controller.goToReports,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.staff,
                    iconBg: Colors.blue.shade50,
                    title: 'Staff & Roles',
                    onTap: controller.goToStaffRoles,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.referrals,
                    iconBg: ColorConstant.fadedPurpleAccent,
                    title: 'Referrals',
                    onTap: controller.goToReferrals,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.badge,
                    iconBg: Colors.brown.shade50,
                    title: 'Badge Details',
                    onTap: controller.goToBadgeDetails,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.star,
                    iconBg: Colors.amber.shade50,
                    title: 'Ratings & Reviews',
                    onTap: controller.goToRatingsReviews,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // ACCOUNT Section
            _buildSectionHeader('ACCOUNT'),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.notification,
                    iconBg: Colors.amber.shade50,
                    title: 'Notifications',
                    onTap: controller.goToNotifications,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.support,
                    iconBg: Colors.grey.shade100,
                    title: 'Support',
                    badge: '1 open',
                    badgeColor: Colors.orange,
                    onTap: controller.goToSupport,
                  ),
                  _buildMenuItemWithImage(
                    imagePath: ImageConstant.settings,
                    iconBg: Colors.grey.shade100,
                    title: 'Settings',
                    onTap: controller.goToSettings,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Log out button
            Center(
              child: TextButton(
                onPressed: controller.logout,
                child: Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            SizedBox(height: 100.h), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: ColorConstant.lighengrey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),

            // Title & Subtitle
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
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Badge or Arrow
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor?.withOpacity(0.1) ?? Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeColor ?? Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithImage({
    required String imagePath,
    required Color iconBg,
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Row(
          children: [
            // Image Icon
            Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(10.w),
              child: Image.asset(
                imagePath,
                width: 18.w,
                height: 18.w,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(width: 12.w),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.blackBold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: ColorConstant.lighengrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Badge or Arrow
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor?.withOpacity(0.1) ?? Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeColor ?? Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
