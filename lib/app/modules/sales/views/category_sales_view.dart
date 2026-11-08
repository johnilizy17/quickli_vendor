import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/sales_controller.dart';

class CategorySalesView extends GetView<SalesController> {
  const CategorySalesView({super.key});

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
                SizedBox(height: 32.h),
                _buildPieChart(),
                SizedBox(height: 32.h),
                _buildLegend(),
                SizedBox(height: 24.h),
                _buildCategoryList(),
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
          'Category Sales',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstant.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Obx(() {
      final total = controller.categorySales.fold<double>(
        0,
        (sum, item) => sum + item['revenue'].toDouble(),
      );

      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200.w,
              height: 200.w,
              child: CustomPaint(
                painter: PieChartPainter(
                  categories: controller.categorySales,
                  total: total,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.darkGrey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '₦${(total / 1000).toStringAsFixed(0)}k',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: ColorConstant.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLegend() {
    return Obx(() => Wrap(
          spacing: 16.w,
          runSpacing: 12.h,
          children: controller.categorySales.map((category) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: category['color'],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  category['name'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            );
          }).toList(),
        ));
  }

  Widget _buildCategoryList() {
    return Obx(() => Column(
          children: controller.categorySales.map((category) {
            return _buildCategoryCard(category);
          }).toList(),
        ));
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
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
                category['name'],
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.black,
                ),
              ),
              Text(
                controller.formatCurrency(category['revenue'].toDouble()),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${category['orders']} orders',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstant.darkGrey,
            ),
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
                widthFactor: category['percentage'] / 100,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: category['color'],
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
              '${category['percentage']}%',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: category['color'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> categories;
  final double total;

  PieChartPainter({
    required this.categories,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    double startAngle = -math.pi / 2;

    for (final category in categories) {
      final percentage = category['revenue'] / total;
      final sweepAngle = 2 * math.pi * percentage;

      final paint = Paint()
        ..color = category['color']
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw white circle in center for donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
