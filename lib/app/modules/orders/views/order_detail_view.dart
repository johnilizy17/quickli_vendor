import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/orders_controller.dart';

class OrderDetailView extends GetView<OrdersController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios, size: 20.sp, color: ColorConstant.samantic)),
        title: Text('Order Details', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 16.h),
            // TODO: order items, customer info, action buttons (accept / reject / ready)
            Text('Order details will appear here.', style: TextStyle(color: ColorConstant.darkGrey)),
          ],
        ),
      ),
    );
  }
}
