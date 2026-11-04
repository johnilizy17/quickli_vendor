import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Orders', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
      ),
      body: Column(
        children: [
          // ── Filter tabs ──────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Obx(() => Row(
              children: ['all', 'pending', 'accepted', 'ready', 'completed', 'canceled'].map((f) {
                final active = controller.filter.value == f;
                return GestureDetector(
                  onTap: () => controller.filter.value = f,
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: active ? ColorConstant.brandColor : ColorConstant.lightestGrey,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(f.capitalizeFirst!, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600,
                        color: active ? Colors.white : ColorConstant.darkGrey)),
                  ),
                );
              }).toList(),
            )),
          ),

          // ── Order list ───────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
              if (controller.orders.isEmpty) return Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.receipt_long_outlined, size: 48.sp, color: ColorConstant.lightGrey),
                  SizedBox(height: 12.h),
                  Text('No orders yet', style: TextStyle(fontSize: 14.sp, color: ColorConstant.darkGrey)),
                ]),
              );
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.orders.length,
                itemBuilder: (_, i) => _OrderCard(order: controller.orders[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ORDER_DETAIL, arguments: order),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: ColorConstant.borderColor),
        ),
        child: Text('Order item', style: TextStyle(fontSize: 14.sp)),
      ),
    );
  }
}
