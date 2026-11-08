import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          color: ColorConstant.brandColor,
          child: Obx(() => controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: ColorConstant.brandColor))
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ────────────────────────────────────────────
                    Row(
                      children: [
                        // Profile Avatar / Logo
                        GestureDetector(
                          onTap: controller.goToBusinessProfile,
                          child: Obx(() {
                            final hasLogo = controller.businessLogo.value.isNotEmpty;
                            
                            if (hasLogo) {
                              // Show business logo
                              return Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorConstant.lightGrey,
                                    width: 1,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    controller.businessLogo.value,
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to initial if image fails to load
                                      return Container(
                                        color: ColorConstant.brandColor,
                                        child: Center(
                                          child: Text(
                                            controller.businessName.value.isNotEmpty 
                                              ? controller.businessName.value[0].toUpperCase()
                                              : 'V',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: ColorConstant.lightestGrey,
                                        child: Center(
                                          child: SizedBox(
                                            width: 20.w,
                                            height: 20.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: ColorConstant.brandColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              // Show initial letter
                              return Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: ColorConstant.brandColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    controller.businessName.value.isNotEmpty 
                                      ? controller.businessName.value[0].toUpperCase()
                                      : 'V',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.greetingText,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: ColorConstant.darkGrey,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Obx(() => Text(
                                controller.businessName.value.isEmpty 
                                  ? 'Welcome back'
                                  : controller.businessName.value,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.samantic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.NOTIFICATIONS);
                          },
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                color: ColorConstant.samantic,
                                size: 28.sp,
                              ),
                              Obx(() => controller.hasNewNotifications.value
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 8.w,
                                      height: 8.w,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink()),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    
                    // ── Onboarding Completion Banner (Always Visible if Incomplete) ──
                    Obx(() {
                      final needsOnboarding = controller.showContractBanner.value ||
                          controller.productsAdded.value < 5 ||
                          !controller.hoursConfigured.value;
                          
                      if (!needsOnboarding) return SizedBox.shrink();
                      
                      return Column(
                        children: [
                          _OnboardingCompletionBanner(),
                        ],
                      );
                    }),
                    
                   
                    SizedBox(height: 16.h),

                    // ── Availability toggle ─────────────────────────────────────
                    // Only show when onboarding is complete
                    Obx(() {
                      // Hide toggle if onboarding is incomplete
                      if (controller.needsOnboarding.value) {
                        return SizedBox.shrink();
                      }
                      
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: controller.isAvailable.value ? Color(0xFFE8F5E9) : Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Are you available to take orders at the moment?',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: controller.isAvailable.value ? ColorConstant.green :ColorConstant.amber,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Switch(
                                  value: controller.isAvailable.value,
                                  onChanged: (value) => controller.toggleAvailability(value),
                                  activeThumbColor: Colors.white,
                                  activeTrackColor: Color(0xFF4CAF50),
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      );
                    }),

                    // ── Stats Grid ─────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _StatCard(
                            icon: '💰',
                            value: '₦${_formatNumber(controller.todayRevenue.value)}',
                            label: 'Today\'s Revenue',
                            change: '${controller.revenueChangePercent.value >= 0 ? '+' : ''}${controller.revenueChangePercent.value.toStringAsFixed(1)}%',
                            changeColor: controller.revenueChangePercent.value >= 0 ? Colors.green : Colors.red,
                          )),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Obx(() => _StatCard(
                            icon: '📋',
                            value: '${controller.ordersToday.value}',
                            label: 'Orders Today',
                            change: '${controller.orderChange.value >= 0 ? '+' : ''}${controller.orderChange.value}',
                            changeColor: controller.orderChange.value >= 0 ? Colors.green : Colors.red,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _StatCard(
                            icon: '⭐',
                            value: controller.avgRating.value > 0 
                              ? '${controller.avgRating.value.toStringAsFixed(1)}' 
                              : 'N/A',
                            label: 'Avg. Rating',
                            change: controller.ratingChange.value > 0 
                              ? '+${controller.ratingChange.value.toStringAsFixed(1)}' 
                              : '',
                            changeColor: Colors.green,
                          )),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Obx(() => _StatCard(
                            icon: '✅',
                            value: '${controller.completionRate.value.toStringAsFixed(1)}%',
                            label: 'Completion Rate',
                            change: '${controller.completionRateChange.value >= 0 ? '+' : ''}${controller.completionRateChange.value.toStringAsFixed(1)}%',
                            changeColor: controller.completionRateChange.value >= 0 ? Colors.green : Colors.red,
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // ── New Orders ─────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'New Orders',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.samantic,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Obx(() => controller.newOrders.isNotEmpty
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.brandColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    controller.newOrders.length.toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()),
                          ],
                        ),
                        TextButton(
                          onPressed: controller.goToOrders,
                          child: Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.brandColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Obx(() => controller.newOrders.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 48.sp,
                                  color: ColorConstant.lightGrey,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'No new orders',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorConstant.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            for (final order in controller.newOrders)
                              _OrderCard(
                                order: order,
                                onAccept: () => controller.acceptOrder(order['_id'] ?? ''),
                                onReject: () => controller.rejectOrder(order['_id'] ?? ''),
                              ),
                          ],
                        )),
                    SizedBox(height: 24.h),

                    // ── Recent Activity ─────────────────────────────────────
                    Obx(() {
                      if (controller.recentActivities.isEmpty) return SizedBox.shrink();
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Activity',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.samantic,
                                ),
                              ),
                              Text(
                                '${controller.recentActivities.length} activities',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: ColorConstant.darkGrey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ...controller.recentActivities.take(5).map((activity) => 
                            _ActivityItem(activity: activity)
                          ).toList(),
                        ],
                      );
                    }),
                    
                    SizedBox(height: 24.h), // Bottom padding
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
  
  static String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Onboarding Completion Banner (Standalone, Not in Carousel)
// ──────────────────────────────────────────────────────────────
class _OnboardingCompletionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return GestureDetector(
      onTap: () {
        // Navigate to launch checklist and refresh status
        Get.toNamed(Routes.LAUNCH_CHECKLIST)?.then((_) {
          // Refresh home data when returning
          controller.fetchDashboardData();
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorConstant.whiteCard,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Complete these before going live',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.blackGrey,
              ),
            ),
            SizedBox(height: 2.h),
            
            // Progress text and percentage on same line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  int completed = 0;
                  if (controller.showContractBanner.value == false) completed++;
                  if (controller.productsAdded.value >= 5) completed++;
                  if (controller.hoursConfigured.value) completed++;
                  
                  return Text(
                    '$completed / 3 required tasks done',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorConstant.grey,
                    ),
                  );
                }),
                Obx(() {
                  int completed = 0;
                  if (controller.showContractBanner.value == false) completed++;
                  if (controller.productsAdded.value >= 5) completed++;
                  if (controller.hoursConfigured.value) completed++;
                  final percentage = ((completed / 3) * 100).round();
                  
                  return Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.orange,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Progress bar
            Obx(() {
              int completed = 0;
              if (controller.showContractBanner.value == false) completed++;
              if (controller.productsAdded.value >= 5) completed++;
              if (controller.hoursConfigured.value) completed++;
              final progress = completed / 3;
              
              return ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6.h,
                  backgroundColor: ColorConstant.lightestGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
              );
            }),
            SizedBox(height: 12.h),
            
            // Tap to view text
            Text(
              'Tap to view',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstant.blackGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Banner Carousel Widget (For Other Reminders)
// ──────────────────────────────────────────────────────────────
class _BannersCarousel extends StatefulWidget {
  final HomeController controller;
  
  const _BannersCarousel({required this.controller});

  @override
  State<_BannersCarousel> createState() => _BannersCarouselState();
}

class _BannersCarouselState extends State<_BannersCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final banners = <Widget>[];
      
      // Only add profile completion and documents banners to carousel
      if (widget.controller.showProfileCompletionBanner.value) {
        banners.add(_ProfileCompletionBanner());
      }
      
      
      return Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => Container(
                width: _currentPage == index ? 20.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                    ? ColorConstant.brandColor 
                    : ColorConstant.lightGrey,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _ProfileCompletionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle_outlined, size: 32.sp, color: Colors.blue.shade700),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Complete your profile',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.samantic,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Finish setting up your business profile',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.BUSINESS_DOCS);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Complete',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, size: 32.sp, color: Colors.pink.shade700),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upload documents',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.samantic,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Add required business documents',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.BUSINESS_DOCS);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.pink.shade700,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Upload',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Stat Card Widget
// ──────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final String change;
  final Color changeColor;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.change,
    required this.changeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 20.sp),
              ),
              Spacer(),
              if (change.isNotEmpty)
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: changeColor,
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: ColorConstant.samantic,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: ColorConstant.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Order Card Widget
// ──────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _OrderCard({
    required this.order,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final orderId = order['orderNumber'] ?? order['_id'] ?? '';
    final orderType = order['orderType'] ?? order['type'] ?? 'Delivery';
    final items = order['items'] as List? ?? [];
    final itemsText = items.isNotEmpty 
      ? items.map((item) => '${item['name']} × ${item['quantity']}').join(', ')
      : order['itemsText'] ?? 'No items';
    final price = order['totalAmount'] ?? order['price'] ?? 0;
    final timeAgo = _getTimeAgo(order['createdAt']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    orderId,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.samantic,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: orderType.toLowerCase() == 'delivery' 
                        ? Colors.orange.shade50 
                        : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      orderType,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: orderType.toLowerCase() == 'delivery' 
                          ? Colors.orange 
                          : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            itemsText,
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorConstant.darkGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₦${_formatPrice(price)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: ColorConstant.samantic,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onReject,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.samantic,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: onAccept,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: ColorConstant.brandColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    
    try {
      final date = timestamp is DateTime 
        ? timestamp 
        : DateTime.parse(timestamp.toString());
      final diff = DateTime.now().difference(date);
      
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return 'Just now';
    }
  }
  
  String _formatPrice(dynamic price) {
    final amount = price is num ? price.toDouble() : 0.0;
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Activity Item Widget
// ──────────────────────────────────────────────────────────────
class _ActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    final type = activity['type'] ?? '';
    final message = activity['message'] ?? activity['description'] ?? '';
    final time = _getTimeAgo(activity['timestamp'] ?? activity['createdAt']);
    
    IconData icon;
    Color iconColor;
    
    switch (type.toLowerCase()) {
      case 'order':
        icon = Icons.shopping_bag_outlined;
        iconColor = Colors.green;
        break;
      case 'product':
        icon = Icons.inventory_2_outlined;
        iconColor = Colors.blue;
        break;
      case 'payment':
        icon = Icons.payment_outlined;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.circle_notifications_outlined;
        iconColor = ColorConstant.brandColor;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ColorConstant.samantic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ColorConstant.darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    
    try {
      final date = timestamp is DateTime 
        ? timestamp 
        : DateTime.parse(timestamp.toString());
      final diff = DateTime.now().difference(date);
      
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return 'Just now';
    }
  }
}
