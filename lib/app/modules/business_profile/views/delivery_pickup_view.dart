import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../controllers/delivery_pickup_controller.dart';

class DeliveryPickupView extends GetView<DeliveryPickupController> {
  const DeliveryPickupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.sp,
            color: ColorConstant.samantic,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Delivery & Pickup',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.samantic,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
              child: Column(
                children: [
                  // Card 1: Delivery enabled & Pickup enabled
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Delivery enabled toggle
                        Obx(() => Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery enabled',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant.blackBold,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Accept delivery orders',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: ColorConstant.lighengrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: Switch(
                                  value: controller.deliveryEnabled.value,
                                  onChanged: (value) => controller.toggleDelivery(value),
                                  activeColor: Colors.white,
                                  activeTrackColor: ColorConstant.brandColor,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                        )),

                        // Pickup enabled toggle (no border bottom on last item)
                        Obx(() => Container(
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pickup enabled',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConstant.blackBold,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Allow customer self-pickup',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: ColorConstant.lighengrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9,
                                child: Switch(
                                  value: controller.pickupEnabled.value,
                                  onChanged: (value) => controller.togglePickup(value),
                                  activeColor: Colors.white,
                                  activeTrackColor: ColorConstant.brandColor,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Card 2: Delivery radius, Minimum order, Prep buffer, Pickup lead time
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery radius
                        Obx(() => GestureDetector(
                          onTap: () => _showDeliveryRadiusDialog(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery radius',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.blackBold,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '${controller.deliveryRadius.value} km',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorConstant.lighengrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                        // Minimum order
                        Obx(() => GestureDetector(
                          onTap: () => _showMinimumOrderDialog(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Minimum order',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.blackBold,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '₦${controller.minimumOrder.value.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorConstant.lighengrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                        // Prep buffer
                        Obx(() => GestureDetector(
                          onTap: () => _showPrepBufferDialog(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prep buffer',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.blackBold,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  '+${controller.prepBuffer.value} min at busy times',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorConstant.lighengrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),

                        // Pickup lead time (no border bottom on last item)
                        Obx(() => GestureDetector(
                          onTap: () => _showPickupLeadTimeDialog(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup lead time',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.blackBold,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '${controller.pickupLeadTime.value} min',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorConstant.lighengrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button at bottom
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Obx(() => GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : () => controller.saveSettings(),
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: controller.isLoading.value
                        ? ColorConstant.brandColor.withOpacity(0.6)
                        : ColorConstant.brandColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeliveryRadiusDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.deliveryRadius.value.toString(),
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          'Delivery Radius',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Radius (km)',
                hintText: 'Enter delivery radius',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                suffixText: 'km',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(textController.text);
              if (value != null && value > 0) {
                controller.deliveryRadius.value = value;
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.brandColor,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMinimumOrderDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.minimumOrder.value.toStringAsFixed(0),
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          'Minimum Order',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Amount (₦)',
                hintText: 'Enter minimum order amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                prefixText: '₦',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(textController.text);
              if (value != null && value >= 0) {
                controller.minimumOrder.value = value;
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.brandColor,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrepBufferDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.prepBuffer.value.toString(),
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          'Prep Buffer',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Extra time added during busy periods',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Buffer (minutes)',
                hintText: 'Enter prep buffer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                suffixText: 'min',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(textController.text);
              if (value != null && value >= 0) {
                controller.prepBuffer.value = value;
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.brandColor,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPickupLeadTimeDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.pickupLeadTime.value.toString(),
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          'Pickup Lead Time',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Minimum time before order is ready',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Lead time (minutes)',
                hintText: 'Enter pickup lead time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                suffixText: 'min',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(textController.text);
              if (value != null && value > 0) {
                controller.pickupLeadTime.value = value;
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.brandColor,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
