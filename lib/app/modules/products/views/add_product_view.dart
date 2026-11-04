import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/products_controller.dart';

class AddProductView extends GetView<ProductsController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.close, size: 22.sp, color: ColorConstant.samantic)),
        title: Text('Add Product', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image upload placeholder
            GestureDetector(
              onTap: () {/* TODO: pick image */},
              child: Container(
                height: 160.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstant.lightestGrey,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: ColorConstant.borderColor, style: BorderStyle.solid),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 32.sp, color: ColorConstant.darkGrey),
                  SizedBox(height: 8.h),
                  Text('Add Photo', style: TextStyle(fontSize: 13.sp, color: ColorConstant.darkGrey)),
                ]),
              ),
            ),
            SizedBox(height: 20.h),
            _Field(label: 'Product Name', controller: controller.nameController, hint: 'e.g. Jollof Rice'),
            SizedBox(height: 16.h),
            _Field(label: 'Description', controller: controller.descriptionController, hint: 'Describe your product', maxLines: 3),
            SizedBox(height: 16.h),
            _Field(label: 'Price (₦)', controller: controller.priceController, hint: '0.00', keyboardType: TextInputType.number),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('In Stock', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: ColorConstant.samantic)),
                Obx(() => Switch(
                  value: controller.inStock.value,
                  onChanged: (v) => controller.inStock.value = v,
                  activeColor: ColorConstant.brandColor,
                )),
              ],
            ),
            SizedBox(height: 32.h),
            Obx(() => GestureDetector(
              onTap: controller.isLoading.value ? null : () {/* TODO */},
              child: Container(
                height: 52.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: ColorConstant.brandColor, borderRadius: BorderRadius.circular(14.r)),
                child: controller.isLoading.value
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('Save Product', style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  const _Field({required this.label, required this.controller, required this.hint,
      this.maxLines = 1, this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: ColorConstant.samantic)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14.sp, color: ColorConstant.samantic),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14.sp, color: ColorConstant.darkGrey),
            filled: true,
            fillColor: ColorConstant.lightestGrey,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }
}
