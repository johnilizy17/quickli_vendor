import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/color_constant.dart';
import '../../home/views/home_view.dart';
import '../../orders/views/orders_view.dart';
import '../../menu/views/menu_view.dart';
import '../../earnings/views/earnings_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/wrapper_controller.dart';

class WrapperView extends GetView<WrapperController> {
  const WrapperView({super.key});

  static final _pages = [
    const HomeView(),
    const OrdersView(),
    const MenuView(),
    const EarningsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _pages[controller.currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ColorConstant.brandColor,
            unselectedItemColor: ColorConstant.darkGrey,
            selectedLabelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 11.sp),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined),       activeIcon: Icon(Icons.home_rounded),         label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined),activeIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined),   activeIcon: Icon(Icons.menu_book_rounded),    label: 'Menu'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined),   activeIcon: Icon(Icons.bar_chart_rounded),    label: 'Earnings'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline),       activeIcon: Icon(Icons.person_rounded),       label: 'Profile'),
            ],
          ),
        ));
  }
}
