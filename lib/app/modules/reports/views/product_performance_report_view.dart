import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/reports_controller.dart';

class ProductPerformanceReportView extends GetView<ReportsController> {
  const ProductPerformanceReportView({super.key});

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
            _buildTableHeader(),
            SizedBox(height: 12.h),
            Expanded(child: _buildProductList()),
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
            'Product Performance',
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

  Widget _buildTableHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: Text(
              '',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.darkGrey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'PRODUCT',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.darkGrey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'REVENUE',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.darkGrey,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 80.w,
            child: Text(
              'ORDERS RATING',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(() => ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: controller.productPerformance.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final product = controller.productPerformance[index];
            return _buildProductRow(product);
          },
        ));
  }

  Widget _buildProductRow(Map<String, dynamic> product) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorConstant.lightestGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: ColorConstant.brandColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                product['rank'].toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.brandColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Text(
              product['name'],
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              controller.formatCurrency(product['revenue'].toDouble()),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: ColorConstant.black,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 80.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product['orders'].toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.star, size: 14.sp, color: ColorConstant.orange),
                    Text(
                      product['rating'].toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
