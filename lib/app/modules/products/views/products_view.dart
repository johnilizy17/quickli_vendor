import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios, size: 20.sp, color: ColorConstant.samantic)),
        title: Text('Products', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.ADD_PRODUCT),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(color: ColorConstant.brandColor, borderRadius: BorderRadius.circular(10.r)),
              child: Text('+ Add', style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Center(child: Text('Products list coming soon', style: TextStyle(color: ColorConstant.darkGrey))),
    );
  }
}
