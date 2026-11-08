import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';

class SalesController extends GetxController {
  // Dashboard stats
  final totalRevenue = 847230.0.obs;
  final revenueChange = '+12.4%'.obs;
  final revenueChangeLabel = 'vs last month'.obs;
  
  final totalOrders = 1247.obs;
  final avgOrderValue = 679.0.obs;
  final grossRevenue = 980450.0.obs;
  final netRevenue = 847230.0.obs;

  // Weekly chart data (Mon-Sun)
  final weeklyData = <double>[65000, 85000, 72000, 95000, 110000, 120000, 95000].obs;
  final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Branch sales data
  final branchSales = <Map<String, dynamic>>[
    {
      'name': 'Lekki Phase 1',
      'topProduct': 'Jollof Rice',
      'revenue': 342100,
      'orders': 487,
      'percentage': 40,
    },
    {
      'name': 'Victoria Island',
      'topProduct': 'Grilled Chicken',
      'revenue': 298650,
      'orders': 412,
      'percentage': 35,
    },
    {
      'name': 'Ikeja GRA',
      'topProduct': 'Pepper Soup',
      'revenue': 206480,
      'orders': 348,
      'percentage': 25,
    },
  ].obs;

  // Product sales data
  final productSales = <Map<String, dynamic>>[
    {'name': 'Jollof Rice & Chicken', 'orders': 312, 'revenue': 187450},
    {'name': 'Grilled Chicken Platter', 'orders': 198, 'revenue': 134200},
    {'name': 'Pepper Soup (Large)', 'orders': 165, 'revenue': 98700},
    {'name': 'Fried Rice & Turkey', 'orders': 142, 'revenue': 87300},
    {'name': 'Egusi Soup & Fufu', 'orders': 128, 'revenue': 74850},
    {'name': 'Suya Platter (500g)', 'orders': 103, 'revenue': 62100},
    {'name': 'Pounded Yam & Ofe Owerri', 'orders': 91, 'revenue': 54400},
    {'name': 'Assorted Peppered Snails', 'orders': 72, 'revenue': 43200},
    {'name': 'Zobo Cocktail (1L)', 'orders': 88, 'revenue': 31480},
    {'name': 'Chin Chin Party Pack', 'orders': 60, 'revenue': 13500},
  ].obs;

  // Category sales data
  final categorySales = <Map<String, dynamic>>[
    {
      'name': 'Rice Dishes',
      'revenue': 287450,
      'orders': 487,
      'percentage': 34,
      'color': ColorConstant.brandColor,
    },
    {
      'name': 'Protein/Grills',
      'revenue': 198600,
      'orders': 312,
      'percentage': 23,
      'color': ColorConstant.orange,
    },
    {
      'name': 'Soups & Stews',
      'revenue': 154200,
      'orders': 268,
      'percentage': 18,
      'color': ColorConstant.green,
    },
    {
      'name': 'Snacks',
      'revenue': 102900,
      'orders': 201,
      'percentage': 12,
      'color': ColorConstant.red,
    },
    {
      'name': 'Drinks',
      'revenue': 104080,
      'orders': 178,
      'percentage': 13,
      'color': const Color(0xFF00BCD4),
    },
  ].obs;

  // Filter states
  final selectedDateRange = 'This Month'.obs;
  final selectedBranches = <String>['All Branches'].obs;
  final selectedPaymentMethod = 'All'.obs;
  final selectedOrderType = 'All'.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSalesData();
  }

  void loadSalesData() {
    // TODO: Load from API
    isLoading.value = false;
  }

  double get maxWeeklyValue {
    if (weeklyData.isEmpty) return 0;
    return weeklyData.reduce((a, b) => a > b ? a : b);
  }

  void showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterModal(context),
    );
  }

  Widget _buildFilterModal(BuildContext context) {
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
          // Header
          Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales Filter',
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
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeFilter(),
                  SizedBox(height: 24.h),
                  _buildBranchFilter(),
                  SizedBox(height: 24.h),
                  _buildPaymentMethodFilter(),
                  SizedBox(height: 24.h),
                  _buildOrderTypeFilter(),
                ],
              ),
            ),
          ),
          // Footer buttons
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(color: ColorConstant.lightestGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.brandColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    final options = ['Today', 'This Week', 'This Month', 'Custom Range'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.black,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            return Obx(() {
              final isSelected = selectedDateRange.value == option;
              return GestureDetector(
                onTap: () => selectedDateRange.value = option,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? ColorConstant.brandColor : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? ColorConstant.brandColor : ColorConstant.lightestGrey,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : ColorConstant.black,
                    ),
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBranchFilter() {
    final branches = ['All Branches', 'Lekki Phase 1', 'Victoria Island', 'Ikeja GRA'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Branch',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.black,
          ),
        ),
        SizedBox(height: 12.h),
        ...branches.map((branch) {
          return Obx(() {
            final isSelected = selectedBranches.contains(branch);
            return GestureDetector(
              onTap: () {
                if (branch == 'All Branches') {
                  selectedBranches.value = ['All Branches'];
                } else {
                  selectedBranches.remove('All Branches');
                  if (isSelected) {
                    selectedBranches.remove(branch);
                  } else {
                    selectedBranches.add(branch);
                  }
                  if (selectedBranches.isEmpty) {
                    selectedBranches.add('All Branches');
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: ColorConstant.lightestGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      branch,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.black,
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: isSelected ? ColorConstant.brandColor : Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: isSelected ? ColorConstant.brandColor : ColorConstant.lightGrey,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          });
        }).toList(),
      ],
    );
  }

  Widget _buildPaymentMethodFilter() {
    final methods = ['All', 'Card', 'Cash', 'Transfer', 'Wallet'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.black,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: methods.map((method) {
            return Obx(() {
              final isSelected = selectedPaymentMethod.value == method;
              return GestureDetector(
                onTap: () => selectedPaymentMethod.value = method,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? ColorConstant.brandColor : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? ColorConstant.brandColor : ColorConstant.lightestGrey,
                    ),
                  ),
                  child: Text(
                    method,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : ColorConstant.black,
                    ),
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOrderTypeFilter() {
    final types = ['All', 'Delivery', 'Pickup', 'Dine-in'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Type',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstant.black,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: types.map((type) {
            return Obx(() {
              final isSelected = selectedOrderType.value == type;
              return GestureDetector(
                onTap: () => selectedOrderType.value = type,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? ColorConstant.brandColor : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? ColorConstant.brandColor : ColorConstant.lightestGrey,
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : ColorConstant.black,
                    ),
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  void resetFilters() {
    selectedDateRange.value = 'This Month';
    selectedBranches.value = ['All Branches'];
    selectedPaymentMethod.value = 'All';
    selectedOrderType.value = 'All';
  }

  void applyFilters() {
    Get.back();
    loadSalesData();
    Get.snackbar(
      'Filters Applied',
      'Sales data updated',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  String formatCurrency(double amount) {
    return '₦${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
}
