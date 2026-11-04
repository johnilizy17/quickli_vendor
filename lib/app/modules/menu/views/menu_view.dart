import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/menu_controller.dart';

class MenuView extends GetView<VendorMenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Menu', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.ADD_PRODUCT),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(color: ColorConstant.brandColor, borderRadius: BorderRadius.circular(10.r)),
              child: Text('+ Add Item', style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.products.isEmpty) return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.menu_book_outlined, size: 48.sp, color: ColorConstant.lightGrey),
            SizedBox(height: 12.h),
            Text('No menu items yet', style: TextStyle(fontSize: 14.sp, color: ColorConstant.darkGrey)),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.ADD_PRODUCT),
              child: Text('Add your first item', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: ColorConstant.brandColor)),
            ),
          ]),
        );
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.products.length,
          itemBuilder: (_, i) => _MenuItemCard(item: controller.products[i]),
        );
      }),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final dynamic item;
  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorConstant.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w, height: 60.w,
            decoration: BoxDecoration(color: ColorConstant.lightestGrey, borderRadius: BorderRadius.circular(10.r)),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product name', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
              Text('₦0', style: TextStyle(fontSize: 13.sp, color: ColorConstant.brandColor, fontWeight: FontWeight.w700)),
            ],
          )),
          Icon(Icons.chevron_right, color: ColorConstant.darkGrey, size: 20.sp),
        ],
      ),
    );
  }
}
