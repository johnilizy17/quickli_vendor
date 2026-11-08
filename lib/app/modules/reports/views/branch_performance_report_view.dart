import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/reports_controller.dart';

class BranchPerformanceReportView extends GetView<ReportsController> {
  const BranchPerformanceReportView({super.key});

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
            _buildPeriodSelector(),
            SizedBox(height: 24.h),
            Expanded(child: _buildBranchList()),
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
              child: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            'Branch Performance',
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

  Widget _buildPeriodSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(() => Row(
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
          )),
    );
  }

  Widget _buildBranchList() {
    return Obx(() => ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: controller.branchPerformance.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final branch = controller.branchPerformance[index];
            return _buildBranchCard(branch);
          },
        ));
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorConstant.lightestGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branch['name'],
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ColorConstant.black,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildMetric('REVENUE', controller.formatCurrency(branch['revenue'].toDouble())),
              ),
              Expanded(
                child: _buildMetric('ORDERS', branch['orders'].toString()),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildMetric('AVG PREP', branch['avgPrep']),
              ),
              Expanded(
                child: _buildMetric('ON-TIME', branch['onTime']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
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
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
      ],
    );
  }
}
