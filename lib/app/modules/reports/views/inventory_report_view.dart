import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/reports_controller.dart';

class InventoryReportView extends GetView<ReportsController> {
  const InventoryReportView({super.key});

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
                _buildStatsCards(),
                SizedBox(height: 24.h),
                _buildAttentionRequiredSection(),
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
          'Inventory Report',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'TOTAL ITEMS',
                controller.totalItems.value.toString(),
                Colors.white,
                ColorConstant.black,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'LOW STOCK',
                controller.lowStockItems.value.toString(),
                ColorConstant.orange.withValues(alpha: 0.1),
                ColorConstant.orange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'OUT OF STOCK',
                controller.outOfStockItems.value.toString(),
                ColorConstant.red.withValues(alpha: 0.1),
                ColorConstant.red,
              ),
            ),
          ],
        ));
  }

  Widget _buildStatCard(String label, String value, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: bgColor == Colors.white ? Border.all(color: ColorConstant.lightestGrey) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: ColorConstant.darkGrey,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionRequiredSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attention Required',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() => Column(
              children: controller.attentionRequiredItems.map((item) {
                return _buildInventoryItem(item);
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildInventoryItem(Map<String, dynamic> item) {
    final isOutOfStock = item['status'] == 'Out of Stock';
    final statusColor = isOutOfStock ? ColorConstant.red : ColorConstant.orange;
    final statusBg = isOutOfStock 
        ? ColorConstant.red.withValues(alpha: 0.1) 
        : ColorConstant.orange.withValues(alpha: 0.1);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorConstant.lightestGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'Threshold: ${item['threshold']}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.darkGrey,
                ),
              ),
              SizedBox(width: 12.w),
              if (item['current'] != '0')
                Text(
                  'Current: ${item['current']}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
