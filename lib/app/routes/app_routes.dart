part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH               = _Paths.SPLASH;
  static const AUTH                 = _Paths.AUTH;
  static const VERIFICATION         = _Paths.VERIFICATION;
  static const VERIFICATION_PENDING = _Paths.VERIFICATION_PENDING;
  static const BUSINESS_REGISTRATION = _Paths.BUSINESS_REGISTRATION;
  static const BUSINESS_INFO        = _Paths.BUSINESS_INFO;
  static const OWNER_VERIFICATION   = _Paths.OWNER_VERIFICATION;
  static const BUSINESS_DOCS        = _Paths.BUSINESS_DOCS;
  static const BANK_ACCOUNT         = _Paths.BANK_ACCOUNT;
  static const TAX_INFO             = _Paths.TAX_INFO;
  static const WRAPPER              = _Paths.WRAPPER;
  static const HOME                 = _Paths.HOME;
  static const ORDERS               = _Paths.ORDERS;
  static const ORDER_DETAIL         = _Paths.ORDER_DETAIL;
  static const PRODUCTS             = _Paths.PRODUCTS;
  static const ADD_PRODUCT          = _Paths.ADD_PRODUCT;
  static const EDIT_PRODUCT         = _Paths.EDIT_PRODUCT;
  static const MENU                 = _Paths.MENU;
  static const PROFILE              = _Paths.PROFILE;
  static const NOTIFICATIONS        = _Paths.NOTIFICATIONS;
  static const EARNINGS             = _Paths.EARNINGS;
  static const SETTINGS             = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH               = '/splash';
  static const AUTH                 = '/auth';
  static const VERIFICATION         = '/verification';
  static const VERIFICATION_PENDING = '/verification-pending';
  static const BUSINESS_REGISTRATION = '/business-registration';
  static const BUSINESS_INFO        = '/business-info';
  static const OWNER_VERIFICATION   = '/owner-verification';
  static const BUSINESS_DOCS        = '/business-docs';
  static const BANK_ACCOUNT         = '/bank-account';
  static const TAX_INFO             = '/tax-info';
  static const WRAPPER              = '/wrapper';
  static const HOME                 = '/home';
  static const ORDERS               = '/orders';
  static const ORDER_DETAIL         = '/orders/detail';
  static const PRODUCTS             = '/products';
  static const ADD_PRODUCT          = '/products/add';
  static const EDIT_PRODUCT         = '/products/edit';
  static const MENU                 = '/menu';
  static const PROFILE              = '/profile';
  static const NOTIFICATIONS        = '/notifications';
  static const EARNINGS             = '/earnings';
  static const SETTINGS             = '/settings';
}
