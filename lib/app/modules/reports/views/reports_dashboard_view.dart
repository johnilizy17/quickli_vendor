import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/reports_controller.dart';

class ReportsDashboardView extends GetView<ReportsController> {
  const ReportsDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildHeader(),
            SizedBox(height: 24.h),
            Expanded(
              child: _buildReportsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
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
            'Reports Dashboard',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: ColorConstant.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    final reports = [
      {'title': 'Sales Report', 'route': '/reports/sales'},
      {'title': 'Order Report', 'route': '/reports/orders'},
      {'title': 'Product Performance Report', 'route': '/reports/product-performance'},
      {'title': 'Branch Performance Report', 'route': '/reports/branch-performance'},
      {'title': 'Inventory Report', 'route': '/reports/inventory'},
      {'title': 'Cancellation Report', 'route': '/reports/cancellation'},
      {'title': 'Refund/Dispute Report', 'route': '/reports/refund-dispute'},
      {'title': 'Customer Complaint Report', 'route': '/reports/customer-complaint'},
      {'title': 'Staff Activity Report', 'route': '/reports/staff-activity'},
    ];

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: reports.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportItem(
          report['title']!,
          report['route']!,
        );
      },
    );
  }

  Widget _buildReportItem(String title, String route) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorConstant.lightestGrey),
        ),
        child: Row(
          children: [
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
