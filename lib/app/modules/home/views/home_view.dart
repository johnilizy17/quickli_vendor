import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.lightestGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning 👋', style: TextStyle(fontSize: 12.sp, color: ColorConstant.darkGrey)),
                      Text('My Store', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                    child: Container(
                      width: 40.w, height: 40.w,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
                      child: Icon(Icons.notifications_outlined, color: ColorConstant.samantic, size: 20.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Online toggle ─────────────────────────────────────
              Obx(() => Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: controller.isOnline.value ? ColorConstant.brandColor : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(controller.isOnline.value ? 'Store is Open' : 'Store is Closed',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700,
                            color: controller.isOnline.value ? Colors.white : ColorConstant.samantic)),
                    Switch(
                      value: controller.isOnline.value,
                      onChanged: (_) => controller.isOnline.toggle(),
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.4),
                    ),
                  ],
                ),
              )),
              SizedBox(height: 20.h),

              // ── Stats row ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Pending Orders', value: '${controller.pendingCount.value}', icon: Icons.pending_actions_rounded)),
                  SizedBox(width: 12.w),
                  Expanded(child: _StatCard(label: "Today's Orders", value: '${controller.todayOrderCount.value}', icon: Icons.receipt_long_rounded)),
                ],
              ),
              SizedBox(height: 12.h),
              _StatCard(
                label: "Today's Revenue",
                value: '₦${controller.todayRevenue.value.toStringAsFixed(0)}',
                icon: Icons.account_balance_wallet_outlined,
                wide: true,
              ),
              SizedBox(height: 20.h),

              // ── Quick actions ─────────────────────────────────────
              Text('Quick Actions', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: ColorConstant.samantic)),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(child: _ActionButton(label: 'View Orders',   icon: Icons.receipt_long_outlined,  onTap: () => Get.toNamed(Routes.ORDERS))),
                  SizedBox(width: 12.w),
                  Expanded(child: _ActionButton(label: 'Manage Menu',   icon: Icons.menu_book_outlined,      onTap: () => Get.toNamed(Routes.MENU))),
                  SizedBox(width: 12.w),
                  Expanded(child: _ActionButton(label: 'Add Product',   icon: Icons.add_box_outlined,        onTap: () => Get.toNamed(Routes.ADD_PRODUCT))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool wide;
  const _StatCard({required this.label, required this.value, required this.icon, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
      child: Row(
        children: [
          Container(
            width: 40.w, height: 40.w,
            decoration: BoxDecoration(color: ColorConstant.fadedPurpleAccent, borderRadius: BorderRadius.circular(10.r)),
            child: Icon(icon, color: ColorConstant.brandColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
              Text(label,  style: TextStyle(fontSize: 11.sp, color: ColorConstant.darkGrey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
        child: Column(
          children: [
            Icon(icon, color: ColorConstant.brandColor, size: 22.sp),
            SizedBox(height: 6.h),
            Text(label, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: ColorConstant.samantic), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
