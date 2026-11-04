import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/verification_view.dart';
import '../modules/auth/views/verification_pending_view.dart';
import '../modules/wrapper/bindings/wrapper_binding.dart';
import '../modules/wrapper/views/wrapper_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/orders/views/order_detail_view.dart';
import '../modules/products/bindings/products_binding.dart';
import '../modules/products/views/products_view.dart';
import '../modules/products/views/add_product_view.dart';
import '../modules/products/views/edit_product_view.dart';
import '../modules/menu/bindings/menu_binding.dart';
import '../modules/menu/views/menu_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/earnings/bindings/earnings_binding.dart';
import '../modules/earnings/views/earnings_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION,
      page: () => const VerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION_PENDING,
      page: () => const VerificationPendingView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.WRAPPER,
      page: () => const WrapperView(),
      binding: WrapperBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCTS,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PRODUCT,
      page: () => const AddProductView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PRODUCT,
      page: () => const EditProductView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.MENU,
      page: () => const MenuView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.EARNINGS,
      page: () => const EarningsView(),
      binding: EarningsBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
