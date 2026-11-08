import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/sales_controller.dart';

class SalesDashboardView extends GetView<SalesController> {
  const SalesDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildHeader(),
                SizedBox(height: 24.h),
                _buildTotalRevenueCard(),
                SizedBox(height: 24.h),
                _buildStatsGrid(),
                SizedBox(height: 24.h),
                _buildWeeklyChart(),
                SizedBox(height: 24.h),
                _buildMenuOptions(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: ColorConstant.lightestGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),
        ),
        Text(
          'Sales Dashboard',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
        GestureDetector(
          onTap: () => controller.showFilterModal(Get.context!),
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: ColorConstant.lightestGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.tune,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRevenueCard() {
    return Obx(() => Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorConstant.brandColor,
                ColorConstant.brandColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Revenue',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                controller.formatCurrency(controller.totalRevenue.value),
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    controller.revenueChange.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    controller.revenueChangeLabel.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildStatsGrid() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildStatItem(
                    'TOTAL ORDERS',
                    controller.totalOrders.value.toString(),
                  ),
                  SizedBox(height: 16.h),
                  _buildStatItem(
                    'GROSS REVENUE',
                    controller.formatCurrency(controller.grossRevenue.value),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                children: [
                  _buildStatItem(
                    'AVG ORDER VALUE',
                    controller.formatCurrency(controller.avgOrderValue.value),
                  ),
                  SizedBox(height: 16.h),
                  _buildStatItem(
                    'NET REVENUE',
                    controller.formatCurrency(controller.netRevenue.value),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorConstant.lightestGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: ColorConstant.darkGrey,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ColorConstant.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          final maxValue = controller.maxWeeklyValue;
          return SizedBox(
            height: 120.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final value = controller.weeklyData[index];
                final height = (value / maxValue) * 100.h;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 36.w,
                      height: height,
                      decoration: BoxDecoration(
                        color: ColorConstant.brandColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      controller.weekDays[index],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.darkGrey,
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        _buildMenuItem(
          'Branch Sales',
          Icons.store_outlined,
          () => Get.toNamed('/sales/branch'),
        ),
        SizedBox(height: 12.h),
        _buildMenuItem(
          'Product Sales',
          Icons.inventory_2_outlined,
          () => Get.toNamed('/sales/product'),
        ),
        SizedBox(height: 12.h),
        _buildMenuItem(
          'Category Sales',
          Icons.category_outlined,
          () => Get.toNamed('/sales/category'),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorConstant.lightestGrey),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: ColorConstant.brandColor,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: ColorConstant.darkGrey,
            ),
          ],
        ),
      ),
    );
  }
}
