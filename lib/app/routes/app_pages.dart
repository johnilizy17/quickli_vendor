import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/auth/views/verification_view.dart';
import '../modules/auth/views/verification_pending_view.dart';
import '../modules/password_reset/bindings/password_reset_binding.dart';
import '../modules/password_reset/views/password_reset_view.dart';
import '../modules/password_reset/views/verify_reset_code_view.dart';
import '../modules/password_reset/views/create_new_password_view.dart';
import '../modules/auth/views/business_registration_view.dart';
import '../modules/auth/views/business_info_view.dart';
import '../modules/auth/views/business_docs_view.dart';
import '../modules/auth/views/bank_account_view.dart';
import '../modules/auth/views/tax_info_view.dart';
import '../modules/application_status/controllers/application_status_controller.dart';
import '../modules/application_status/views/review_application_view.dart';
import '../modules/application_status/views/application_status_view.dart';
import '../modules/onboarding_completion/bindings/onboarding_completion_binding.dart';
import '../modules/onboarding_completion/views/launch_checklist_view.dart';
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
import '../modules/business_profile/bindings/business_profile_binding.dart';
import '../modules/business_profile/views/business_profile_view.dart';
import '../modules/business_profile/views/edit_business_profile_view.dart';
import '../modules/business_profile/views/business_logo_view.dart';
import '../modules/business_profile/views/cover_image_view.dart';
import '../modules/business_profile/bindings/operating_hours_binding.dart';
import '../modules/business_profile/views/operating_hours_view.dart';
import '../modules/business_profile/bindings/delivery_pickup_binding.dart';
import '../modules/business_profile/views/delivery_pickup_view.dart';
import '../modules/referrals/bindings/referrals_binding.dart';
import '../modules/referrals/views/referrals_view.dart';
import '../modules/sales/bindings/sales_binding.dart';
import '../modules/sales/views/sales_dashboard_view.dart';
import '../modules/sales/views/branch_sales_view.dart';
import '../modules/sales/views/product_sales_view.dart';
import '../modules/sales/views/category_sales_view.dart';
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/reports/views/reports_dashboard_view.dart';
import '../modules/reports/views/sales_report_view.dart';
import '../modules/reports/views/order_report_view.dart';
import '../modules/reports/views/product_performance_report_view.dart';
import '../modules/reports/views/branch_performance_report_view.dart';
import '../modules/reports/views/inventory_report_view.dart';
import '../modules/reports/views/cancellation_report_view.dart';
import '../modules/reports/views/refund_dispute_report_view.dart';
import '../modules/staff/bindings/staff_binding.dart';
import '../modules/staff/views/staff_dashboard_view.dart';
import '../modules/staff/views/staff_list_view.dart';
import '../modules/staff/views/staff_detail_view.dart';
import '../modules/staff/views/invite_staff_view.dart';
import '../modules/staff/views/edit_staff_view.dart';
import '../modules/staff/views/pending_staff_invites_view.dart';
import '../modules/staff/views/approval_workflow_settings_view.dart';
import '../modules/staff/views/approval_queue_view.dart';
import '../modules/notification_settings/bindings/notification_settings_binding.dart';
import '../modules/notification_settings/views/notification_settings_view.dart';
import '../modules/ratings_reviews/bindings/ratings_reviews_binding.dart';
import '../modules/ratings_reviews/views/ratings_reviews_view.dart';
import '../modules/account_settings/bindings/account_settings_binding.dart';
import '../modules/account_settings/views/account_settings_dashboard_view.dart';
import '../modules/account_settings/views/change_password_view.dart';
import '../modules/account_settings/views/verify_code_view.dart';
import '../modules/account_settings/views/create_new_password_view.dart' as account_settings;
import '../modules/account_settings/views/password_updated_view.dart';
import '../modules/account_settings/views/activity_log_view.dart';
import '../modules/account_settings/views/activity_detail_view.dart';
import '../modules/account_settings/views/legal_policies_view.dart';
import '../modules/help_support/bindings/help_support_binding.dart';
import '../modules/help_support/views/help_support_dashboard_view.dart';
import '../modules/help_support/views/report_issue_view.dart';
import '../modules/help_support/views/support_chat_view.dart';

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
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
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
      name: _Paths.PASSWORD_RESET,
      page: () => const PasswordResetView(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_RESET_VERIFY,
      page: () => const VerifyResetCodeView(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_RESET_NEW,
      page: () => const CreateNewPasswordView(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.BUSINESS_REGISTRATION,
      page: () => const BusinessRegistrationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.BUSINESS_INFO,
      page: () => const BusinessInfoView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.BUSINESS_DOCS,
      page: () => const BusinessDocsView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.BANK_ACCOUNT,
      page: () => const BankAccountView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.TAX_INFO,
      page: () => const TaxInfoView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW_APPLICATION,
      page: () => const ReviewApplicationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ApplicationStatusController>(() => ApplicationStatusController());
      }),
    ),
    GetPage(
      name: _Paths.APPLICATION_STATUS,
      page: () => const ApplicationStatusView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ApplicationStatusController>(() => ApplicationStatusController());
      }),
    ),
    GetPage(
      name: _Paths.LAUNCH_CHECKLIST,
      page: () => const LaunchChecklistView(),
      binding: OnboardingCompletionBinding(),
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
    GetPage(
      name: _Paths.BUSINESS_PROFILE,
      page: () => const BusinessProfileView(),
      binding: BusinessProfileBinding(),
    ),
    GetPage(
      name: _Paths.BUSINESS_PROFILE_EDIT,
      page: () => const EditBusinessProfileView(),
      binding: BusinessProfileBinding(),
    ),
    GetPage(
      name: _Paths.BUSINESS_LOGO,
      page: () => const BusinessLogoView(),
      binding: BusinessProfileBinding(),
    ),
    GetPage(
      name: _Paths.COVER_IMAGE,
      page: () => const CoverImageView(),
      binding: BusinessProfileBinding(),
    ),
    GetPage(
      name: _Paths.OPERATING_HOURS,
      page: () => const OperatingHoursView(),
      binding: OperatingHoursBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_PICKUP,
      page: () => const DeliveryPickupView(),
      binding: DeliveryPickupBinding(),
    ),
    GetPage(
      name: _Paths.REFERRALS,
      page: () => const ReferralsView(),
      binding: ReferralsBinding(),
    ),
    GetPage(
      name: _Paths.SALES_DASHBOARD,
      page: () => const SalesDashboardView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.SALES_BRANCH,
      page: () => const BranchSalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.SALES_PRODUCT,
      page: () => const ProductSalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.SALES_CATEGORY,
      page: () => const CategorySalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: _Paths.REPORTS_DASHBOARD,
      page: () => const ReportsDashboardView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.SALES_REPORT,
      page: () => const SalesReportView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_REPORT,
      page: () => const OrderReportView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_PERFORMANCE,
      page: () => const ProductPerformanceReportView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.BRANCH_PERFORMANCE,
      page: () => const BranchPerformanceReportView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.INVENTORY_REPORT,
      page: () => const InventoryReportView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.CANCELLATION_REPORT,
      page: () => const CancellationReportView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.REFUND_DISPUTE_REPORT,
      page: () => const RefundDisputeReportView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_DASHBOARD,
      page: () => const StaffDashboardView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_LIST,
      page: () => const StaffListView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.STAFF_DETAIL,
      page: () => const StaffDetailView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.INVITE_STAFF,
      page: () => const InviteStaffView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_STAFF,
      page: () => const EditStaffView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.PENDING_STAFF_INVITES,
      page: () => const PendingStaffInvitesView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.APPROVAL_WORKFLOW_SETTINGS,
      page: () => const ApprovalWorkflowSettingsView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.APPROVAL_QUEUE,
      page: () => const ApprovalQueueView(),
      binding: StaffBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SETTINGS,
      page: () => const NotificationSettingsView(),
      binding: NotificationSettingsBinding(),
    ),
    GetPage(
      name: _Paths.RATINGS_REVIEWS,
      page: () => const RatingsReviewsView(),
      binding: RatingsReviewsBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_SETTINGS,
      page: () => const AccountSettingsDashboardView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_CODE,
      page: () => const VerifyCodeView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_NEW_PASSWORD,
      page: () => const account_settings.CreateNewPasswordView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_UPDATED,
      page: () => const PasswordUpdatedView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY_LOG,
      page: () => const ActivityLogView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY_DETAIL,
      page: () => const ActivityDetailView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.LEGAL_POLICIES,
      page: () => const LegalPoliciesView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.HELP_SUPPORT,
      page: () => const HelpSupportDashboardView(),
      binding: HelpSupportBinding(),
    ),
    GetPage(
      name: _Paths.HELP_SUPPORT_REPORT,
      page: () => const ReportIssueView(),
      binding: HelpSupportBinding(),
    ),
    GetPage(
      name: _Paths.HELP_SUPPORT_CHAT,
      page: () => const SupportChatView(),
      binding: HelpSupportBinding(),
    ),
  ];
}
