class ApiRoute {
  // Auth
  static const requestOtp  = '/vendors/auth/login/request-code';
  static const verifyOtp   = '/vendors/auth/login';
  static const signup      = '/vendors/auth/signup';
  static const setupAccount= '/vendors/auth/setup-account';
  static const refreshAuth = '/vendors/auth/refresh-token';
  static const userProfile = '/vendors/my-profile';
  static const updateProfile = '/vendors/update';
  static const checkEmailAvailability = '/vendors/auth/check-email';

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

  // Earnings / Wallet
  static const getEarnings       = '/vendors/earnings';
  static const getTransactions   = '/vendors/wallet/transactions';
  static const requestWithdrawal = '/vendors/wallet/withdraw';

  // Notifications
  static const getNotifications  = '/vendors/notifications';
  static const markAllRead       = '/vendors/notifications/read-all';

  // Uploads
  static const uploadImage       = '/uploads';
}
