import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/reports_controller.dart';

class OrderReportView extends GetView<ReportsController> {
  const OrderReportView({super.key});

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
                _buildPeriodSelector(),
                SizedBox(height: 24.h),
                _buildStatsGrid(),
                SizedBox(height: 24.h),
                _buildOrdersByStatus(),
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
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          'Order Report',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Obx(() => Row(
          children: ['Today', 'Week', 'Month'].map((period) {
            final isSelected = controller.selectedPeriod.value == period;
            return GestureDetector(
              onTap: () => controller.changePeriod(period),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? ColorConstant.brandColor : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? ColorConstant.brandColor : ColorConstant.lightestGrey,
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : ColorConstant.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildStatsGrid() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildStatCard(
                    'TOTAL ORDERS',
                    controller.totalOrders.value.toString(),
                  ),
                  SizedBox(height: 12.h),
                  _buildStatCard(
                    'CANCELLED',
                    controller.cancelledOrders.value.toString(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                children: [
                  _buildStatCard(
                    'COMPLETED',
                    controller.completedOrders.value.toString(),
                  ),
                  SizedBox(height: 12.h),
                  _buildStatCard(
                    'REJECTED',
                    controller.rejectedOrders.value.toString(),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildStatCard(String label, String value) {
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
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: ColorConstant.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersByStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders by Status',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() => Column(
              children: [
                _buildStatusBar(
                  'Completed',
                  controller.completedOrders.value,
                  controller.completionRate,
                  ColorConstant.green,
                ),
                SizedBox(height: 16.h),
                _buildStatusBar(
                  'Cancelled',
                  controller.cancelledOrders.value,
                  controller.cancellationRate,
                  ColorConstant.red,
                ),
                SizedBox(height: 16.h),
                _buildStatusBar(
                  'Rejected',
                  controller.rejectedOrders.value,
                  controller.rejectionRate,
                  ColorConstant.orange,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildStatusBar(String label, int count, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.black,
              ),
            ),
            Text(
              '$count $percentage%',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: ColorConstant.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Stack(
          children: [
            Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConstant.lightestGrey,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
