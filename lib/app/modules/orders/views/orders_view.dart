import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

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
            _buildTabBar(),
            SizedBox(height: 16.h),
            Expanded(
              child: _buildOrderList(),
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
            'Orders',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: ColorConstant.black,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Search functionality
                },
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: ColorConstant.lightestGrey,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  // Filter functionality
                },
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
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(
        () => Row(
          children: [
            _buildTab('Picked Up', controller.getTabCount('Picked Up')),
            SizedBox(width: 8.w),
            _buildTab('Completed', controller.getTabCount('Completed')),
            SizedBox(width: 8.w),
            _buildTab('Cancelled', controller.getTabCount('Cancelled')),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    final isSelected = controller.selectedTab.value == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = label,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? ColorConstant.brandColor : ColorConstant.lightestGrey,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : ColorConstant.black,
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : ColorConstant.darkGrey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : ColorConstant.darkGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = controller.filteredOrders;
        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64.sp,
                  color: ColorConstant.lightGrey,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: orders.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildOrderCard(order);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final isCancelled = order['status'] == 'Cancelled' || order['status'] == 'Rejected';
    final isPickedUp = order['status'] == 'Picked Up';

    Color statusColor = ColorConstant.green;
    if (isCancelled) statusColor = ColorConstant.red;
    if (isPickedUp) statusColor = ColorConstant.brandColor;

    return GestureDetector(
      onTap: () {
        // Navigate to order details
        Get.toNamed('/order-details', arguments: order);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: ColorConstant.lightestGrey,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['id'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.black,
                  ),
                ),
                Text(
                  order['status'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16.sp,
                  color: ColorConstant.red,
                ),
                SizedBox(width: 4.w),
                Text(
                  order['location'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Customer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: ColorConstant.brandColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          order['customerInitial'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.brandColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      order['customer'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorConstant.lightestGrey,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    order['type'],
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, color: ColorConstant.lightestGrey),
            SizedBox(height: 12.h),
            // Items and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: ColorConstant.darkGrey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Prep ${order['prepTime']}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.darkGrey,
                      ),
                    ),
                    if (order['elapsed'] != null) ...[
                      Text(
                        ' · ${order['elapsed']}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.darkGrey,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  order['time'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order['items']} items',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.darkGrey,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '₦${order['total'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.black,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: order['paid'] == true
                            ? ColorConstant.green.withValues(alpha: 0.1)
                            : order['refunded'] == true
                                ? ColorConstant.brandColor.withValues(alpha: 0.1)
                                : ColorConstant.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        order['paid'] == true
                            ? 'Paid'
                            : order['refunded'] == true
                                ? 'Refunded'
                                : 'Pending',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: order['paid'] == true
                              ? ColorConstant.green
                              : order['refunded'] == true
                                  ? ColorConstant.brandColor
                                  : ColorConstant.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
