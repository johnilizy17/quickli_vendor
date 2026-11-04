import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios, size: 20.sp, color: ColorConstant.samantic)),
        title: Text('Store Settings', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: ColorConstant.samantic)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Store Information', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: ColorConstant.samantic)),
            SizedBox(height: 12.h),
            _Field(label: 'Store Name',    ctrl: controller.storeName,    hint: 'My Store'),
            SizedBox(height: 14.h),
            _Field(label: 'Phone Number',  ctrl: controller.storePhone,   hint: '+234...'),
            SizedBox(height: 14.h),
            _Field(label: 'Email',         ctrl: controller.storeEmail,   hint: 'store@example.com', type: TextInputType.emailAddress),
            SizedBox(height: 14.h),
            _Field(label: 'Address',       ctrl: controller.storeAddress, hint: 'Store address', maxLines: 2),
            SizedBox(height: 24.h),

            Text('Preferences', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: ColorConstant.samantic)),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(color: ColorConstant.lightestGrey, borderRadius: BorderRadius.circular(14.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Push Notifications', style: TextStyle(fontSize: 14.sp, color: ColorConstant.samantic)),
                  Obx(() => Switch(
                    value: controller.notificationsOn.value,
                    onChanged: (v) => controller.notificationsOn.value = v,
                    activeColor: ColorConstant.brandColor,
                  )),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            Obx(() => GestureDetector(
              onTap: controller.isLoading.value ? null : () {/* TODO: save */},
              child: Container(
                height: 52.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: ColorConstant.brandColor, borderRadius: BorderRadius.circular(14.r)),
                child: controller.isLoading.value
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600)),
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
  final TextEditingController ctrl;
  final String hint;
  final int maxLines;
  final TextInputType type;
  const _Field({required this.label, required this.ctrl, required this.hint,
      this.maxLines = 1, this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: ColorConstant.deepGrey)),
      SizedBox(height: 6.h),
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: type,
        style: TextStyle(fontSize: 14.sp, color: ColorConstant.samantic),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp, color: ColorConstant.darkGrey),
          filled: true, fillColor: ColorConstant.lightestGrey,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    ],
  );
}
