class ApiRoute {
  // Auth
  static const login       = '/vendors/auth/login';
  static const requestOtp  = '/vendors/auth/login/request-code';
  static const verifyOtp   = '/vendors/auth/login';
  static const signup      = '/vendors/auth/signup';
  static const setupAccount= '/vendors/auth/setup-account';
  static const refreshAuth = '/vendors/auth/refresh-token';
  static const userProfile = '/vendors/my-profile';
  static const updateProfile = '/vendors/update';
  static const checkEmailAvailability = '/vendors/auth/check-email';
  static const verifyPhone = '/vendors/auth/verify-phone';
  static const resendPhoneOTP = '/vendors/auth/verify-phone/resend';
  static const verifyEmail = '/vendors/auth/verify-email';
  static const resendEmailOTP = '/vendors/auth/verify-email/resend';
  static const requestPasswordReset = '/vendors/auth/request-password-reset';
  static const resetPassword = '/vendors/auth/reset-password';

  // Orders
  static const getOrders        = '/vendors/orders';
  static String getOrderById(String id) => '/vendors/orders/$id';
  static String acceptOrder(String id)  => '/vendors/orders/$id/accept';
  static String rejectOrder(String id)  => '/vendors/orders/$id/reject';
  static String readyOrder(String id)   => '/vendors/orders/$id/ready';

  // Products / Menu
  static const getProducts       = '/vendors/products';
  static const createProduct     = '/vendors/products';
  static String updateProduct(String id) => '/vendors/products/$id';
  static String deleteProduct(String id) => '/vendors/products/$id';
  static String toggleProduct(String id) => '/vendors/products/$id/toggle';

  // Categories
  static const getCategories     = '/vendors/categories';
  static const createCategory    = '/vendors/categories';
  static String updateCategory(String id) => '/vendors/categories/$id';
  static String deleteCategory(String id) => '/vendors/categories/$id';

  // Outlet
  static const getOutlet         = '/vendors/outlet';
  static const updateOutlet      = '/vendors/outlet';
  static const toggleOutletOnline= '/vendors/outlet/toggle';
  static const updateOpeningHours= '/vendors/outlet/opening-hours';
  
  // Dashboard / Metrics
  static String businessOutletsMetrics(String businessId) => '/business/$businessId/outlets/all/metrics';
  static String outletMetrics(String businessId, String outletId) => '/business/$businessId/outlets/$outletId/metrics';

  // Earnings / Wallet
  static const getEarnings       = '/vendors/earnings';
  static const getTransactions   = '/vendors/wallet/transactions';
  static const requestWithdrawal = '/vendors/wallet/withdraw';

  // Notifications
  static String getNotifications(String businessId, String outletId) => 
    '/business/$businessId/outlets/$outletId/notifications';
  static String markNotificationsRead(String businessId, String outletId) => 
    '/business/$businessId/outlets/$outletId/notifications/mark-read';

  // Uploads
  static const uploadImage       = '/uploads';

  // Location / Address
  static const getAddressByLatLng = '/address/get-address-by-latlng';

  // Business Information / Registration
  static const setupBusinessInfo  = '/business/onboarding/setup-business-info';
  static const setupKycDetails    = '/business/onboarding/setup-kyc-details';
  static const updateVerificationStep = '/business/onboarding/update-verification-step';
  static const setupBankDetails   = '/business/onboarding/setup-bank-details';
  static const ownerVerification  = '/vendors/owner-verification';
  static const businessDocuments  = '/vendors/business-documents';
  static const submitRegistration = '/vendors/submit-registration';
  static const registrationStatus = '/vendors/registration-status';
  static const getVendorBusiness  = '/business';
}
