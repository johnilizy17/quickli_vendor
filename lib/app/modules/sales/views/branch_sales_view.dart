import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/sales_controller.dart';

class BranchSalesView extends GetView<SalesController> {
  const BranchSalesView({super.key});

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
                _buildTotalRevenue(),
                SizedBox(height: 24.h),
                _buildBranchList(),
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
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          'Branch Sales',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRevenue() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Revenue — Sep 2026',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstant.darkGrey,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              controller.formatCurrency(controller.totalRevenue.value),
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: ColorConstant.black,
              ),
            ),
          ],
        ));
  }

  Widget _buildBranchList() {
    return Obx(() => Column(
          children: controller.branchSales.map((branch) {
            return _buildBranchCard(branch);
          }).toList(),
        ));
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorConstant.lightestGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                branch['name'],
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.black,
                ),
              ),
              Text(
                controller.formatCurrency(branch['revenue'].toDouble()),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top: ${branch['topProduct']}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.darkGrey,
                ),
              ),
              Text(
                '${branch['orders']} orders',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.darkGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Progress bar
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
                widthFactor: branch['percentage'] / 100,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: ColorConstant.brandColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${branch['percentage']}%',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.brandColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
