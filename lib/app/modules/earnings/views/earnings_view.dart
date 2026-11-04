import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/earnings_controller.dart';

class EarningsView extends GetView<EarningsController> {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.lightestGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Earnings', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Summary card ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(color: ColorConstant.brandColor, borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance', style: TextStyle(fontSize: 13.sp, color: Colors.white70)),
                  SizedBox(height: 8.h),
                  Obx(() => Text('₦${controller.totalEarnings.value.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, color: Colors.white))),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {/* TODO: withdrawal */},
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
                      child: Text('Withdraw', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: ColorConstant.brandColor)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // ── Period breakdown ───────────────────────────────────
            Row(children: ['today', 'week', 'month'].map((p) {
              return Obx(() {
                final active = controller.selectedPeriod.value == p;
                return GestureDetector(
                  onTap: () => controller.selectedPeriod.value = p,
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: active ? ColorConstant.brandColor : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(p.capitalizeFirst!, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600,
                        color: active ? Colors.white : ColorConstant.darkGrey)),
                  ),
                );
              });
            }).toList()),
            SizedBox(height: 20.h),

            // ── Transactions ───────────────────────────────────────
            Text('Transactions', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: ColorConstant.samantic)),
            SizedBox(height: 12.h),
            Obx(() {
              if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
              if (controller.transactions.isEmpty) return Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
                child: Center(child: Text('No transactions yet', style: TextStyle(color: ColorConstant.darkGrey, fontSize: 13.sp))),
              );
              return Column(children: controller.transactions.map((t) => _TransactionRow(item: t)).toList());
            }),
          ],
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final dynamic item;
  const _TransactionRow({required this.item});

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
    child: Row(children: [
      Container(
        width: 40.w, height: 40.w,
        decoration: BoxDecoration(color: ColorConstant.lightGreen, borderRadius: BorderRadius.circular(10.r)),
        child: Icon(Icons.arrow_downward_rounded, color: ColorConstant.green, size: 20.sp),
      ),
      SizedBox(width: 12.w),
      Expanded(child: Text('Order payment', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ColorConstant.samantic))),
      Text('₦0.00', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: ColorConstant.green)),
    ]),
  );
}
