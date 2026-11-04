import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.lightestGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profile', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // ── Avatar ────────────────────────────────────────────
            Container(
              width: 80.w, height: 80.w,
              decoration: BoxDecoration(color: ColorConstant.fadedPurpleAccent, shape: BoxShape.circle),
              child: Icon(Icons.store_rounded, size: 36.sp, color: ColorConstant.brandColor),
            ),
            SizedBox(height: 12.h),
            Text(controller.fullname.isNotEmpty ? controller.fullname : 'My Store',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
            Text(controller.outlet, style: TextStyle(fontSize: 13.sp, color: ColorConstant.darkGrey)),
            SizedBox(height: 24.h),

            // ── Info card ──────────────────────────────────────────
            _InfoCard(children: [
              _InfoRow(icon: Icons.phone_outlined,    label: 'Phone',  value: controller.phone.isNotEmpty  ? controller.phone  : '—'),
              _InfoRow(icon: Icons.email_outlined,    label: 'Email',  value: controller.email.isNotEmpty  ? controller.email  : '—'),
            ]),
            SizedBox(height: 16.h),

            // ── Menu ───────────────────────────────────────────────
            _InfoCard(children: [
              _MenuItem(icon: Icons.storefront_outlined,     label: 'Store Settings',   onTap: () => Get.toNamed(Routes.SETTINGS)),
              _MenuItem(icon: Icons.notifications_outlined,  label: 'Notifications',    onTap: () => Get.toNamed(Routes.NOTIFICATIONS)),
              _MenuItem(icon: Icons.bar_chart_outlined,      label: 'Earnings',         onTap: () => Get.toNamed(Routes.EARNINGS)),
            ]),
            SizedBox(height: 16.h),

            // ── Sign out ───────────────────────────────────────────
            GestureDetector(
              onTap: controller.signOut,
              child: Container(
                height: 52.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorConstant.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text('Sign Out', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: ColorConstant.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
    child: Column(children: children),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    child: Row(children: [
      Icon(icon, size: 20.sp, color: ColorConstant.darkGrey),
      SizedBox(width: 12.w),
      Text(label, style: TextStyle(fontSize: 13.sp, color: ColorConstant.darkGrey)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ColorConstant.samantic)),
    ]),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(children: [
        Icon(icon, size: 20.sp, color: ColorConstant.samantic),
        SizedBox(width: 12.w),
        Text(label, style: TextStyle(fontSize: 14.sp, color: ColorConstant.samantic)),
        const Spacer(),
        Icon(Icons.chevron_right, size: 18.sp, color: ColorConstant.darkGrey),
      ]),
    ),
  );
}
