import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';

class OrdersController extends GetxController {
  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedTab = 'Completed'.obs; // Picked Up | Completed | Cancelled

  // Sample orders data
  final sampleOrders = <Map<String, dynamic>>[
    {
      'id': '#QL-7830',
      'status': 'Completed',
      'location': 'Harbour Town Main',
      'customer': 'Funmi A.',
      'customerInitial': 'F',
      'items': 3,
      'total': 4100,
      'paid': true,
      'prepTime': '18 min',
      'elapsed': '17 elapsed',
      'time': '11:40',
      'type': 'Delivery',
    },
    {
      'id': '#QL-7828',
      'status': 'Completed',
      'location': 'Victoria Island',
      'customer': 'Kemi S.',
      'customerInitial': 'K',
      'items': 2,
      'total': 4500,
      'paid': true,
      'prepTime': '20 min',
      'elapsed': '19 elapsed',
      'time': '11:03',
      'type': 'Delivery',
    },
    {
      'id': '#QL-7825',
      'status': 'Cancelled',
      'location': 'Harbour Town Main',
      'customer': 'Obinna U.',
      'customerInitial': 'O',
      'items': 2,
      'total': 8200,
      'refunded': true,
      'prepTime': '20 min',
      'time': '10:30',
      'type': 'Delivery',
    },
    {
      'id': '#QL-7822',
      'status': 'Rejected',
      'location': 'Lekki Phase 1',
      'customer': 'Tolu F.',
      'customerInitial': 'T',
      'items': 4,
      'total': 11200,
      'refunded': true,
      'prepTime': '25 min',
      'time': '10:04',
      'type': 'Delivery',
    },
    {
      'id': '#QL-7834',
      'status': 'Picked Up',
      'location': 'Lekki Phase 1',
      'customer': 'Aisha M.',
      'customerInitial': 'A',
      'items': 2,
      'total': 4350,
      'paid': true,
      'prepTime': '18 min',
      'elapsed': '22 elapsed',
      'time': '13:10',
      'type': 'Delivery',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      orders.value = sampleOrders;
      isLoading.value = false;
    });
  }

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedTab.value == 'Picked Up') {
      return orders.where((o) => o['status'] == 'Picked Up').toList();
    } else if (selectedTab.value == 'Completed') {
      return orders.where((o) => o['status'] == 'Completed').toList();
    } else if (selectedTab.value == 'Cancelled') {
      return orders
          .where((o) => o['status'] == 'Cancelled' || o['status'] == 'Rejected')
          .toList();
    }
    return orders;
  }

  int getTabCount(String tab) {
    if (tab == 'Picked Up') {
      return orders.where((o) => o['status'] == 'Picked Up').length;
    } else if (tab == 'Completed') {
      return orders.where((o) => o['status'] == 'Completed').length;
    } else if (tab == 'Cancelled') {
      return orders
          .where((o) => o['status'] == 'Cancelled' || o['status'] == 'Rejected')
          .length;
    }
    return 0;
  }

  void showTimeline(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTimelineModal(),
    );
  }

  Widget _buildTimelineModal() {
    return Container(
      height: 700.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Modal header
          Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Timeline',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, size: 24.sp),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: ColorConstant.lightestGrey),
          // Timeline content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: _buildTimelineContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineContent() {
    final timelineEvents = [
      {
        'title': 'Order created',
        'subtitle': 'System',
        'description': 'Customer placed order via Quickli app',
        'time': '13:30',
      },
      {
        'title': 'Payment confirmed',
        'subtitle': 'System',
        'description': '₦3,600 via Cash',
        'time': '13:30',
      },
      {
        'title': 'Order accepted',
        'subtitle': 'Lena Okonkwo',
        'description': 'Prep time set to 15 min',
        'time': '13:31',
      },
      {
        'title': 'Rider assigned',
        'subtitle': 'System',
        'description': 'Chidi Eze (LAG-421-AK) dispatched',
        'time': '13:31',
      },
      {
        'title': 'Order marked ready',
        'subtitle': 'Lena Okonkwo',
        'description': '',
        'time': '13:47',
      },
      {
        'title': 'Rider arrived',
        'subtitle': 'Chidi Eze',
        'description': 'Rider at branch — awaiting handoff',
        'time': '13:48',
      },
      {
        'title': 'Pickup code verified',
        'subtitle': 'Lena Okonkwo',
        'description': '4-digit code matched',
        'time': '13:49',
      },
      {
        'title': 'Handed to rider',
        'subtitle': 'Lena Okonkwo',
        'description': 'All items confirmed and transferred',
        'time': '13:49',
      },
      {
        'title': 'Delivered',
        'subtitle': 'Chidi Eze',
        'description': 'Delivered to customer',
        'time': '13:49',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIMELINE',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.darkGrey,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 16.h),
        ...timelineEvents.asMap().entries.map((entry) {
          final isLast = entry.key == timelineEvents.length - 1;
          final event = entry.value;
          return _buildTimelineItem(
            title: event['title']!,
            subtitle: event['subtitle']!,
            description: event['description']!,
            time: event['time']!,
            isLast: isLast,
          );
        }),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String description,
    required String time,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: ColorConstant.green,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 14.sp),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 60.h,
                color: ColorConstant.lightestGrey,
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstant.black,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.darkGrey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: subtitle == 'System'
                      ? ColorConstant.brandColor
                      : ColorConstant.darkGrey,
                ),
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
              if (!isLast) SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
}
