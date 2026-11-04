import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/products_controller.dart';

class EditProductView extends GetView<ProductsController> {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.close, size: 22.sp, color: ColorConstant.samantic)),
        title: Text('Edit Product', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
        actions: [
          GestureDetector(
            onTap: () {/* TODO: delete product */},
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(Icons.delete_outline_rounded, color: ColorConstant.red, size: 22.sp),
            ),
          ),
        ],
      ),
      body: Center(child: Text('Edit product form coming soon', style: TextStyle(color: ColorConstant.darkGrey))),
    );
  }
}
