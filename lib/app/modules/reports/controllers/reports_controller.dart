import 'package:get/get.dart';

class ReportsController extends GetxController {
  // Time period selection
  final selectedPeriod = 'Week'.obs; // Today | Week | Month

  // Refund/Dispute Report Data
  final totalDisputes = 23.obs;
  final totalRefunded = 6280.0.obs;
  final resolvedPercentage = 87.obs;

  final recentDisputes = <Map<String, dynamic>>[
    {
      'orderId': '#QL-48291',
      'customer': 'Adaora O.',
      'issue': 'Item missing',
      'amount': 3200,
      'status': 'Resolved',
    },
    {
      'orderId': '#QL-48156',
      'customer': 'Emeka B.',
      'issue': 'Wrong order',
      'amount': 1890,
      'status': 'Resolved',
    },
    {
      'orderId': '#QL-47923',
      'customer': 'Fatima S.',
      'issue': 'Quality complaint',
      'amount': 1190,
      'status': 'Pending',
    },
    {
      'orderId': '#QL-47781',
      'customer': 'Chidi N.',
      'issue': 'Late delivery',
      'amount': 2100,
      'status': 'Rejected',
    },
  ].obs;

  // Cancellation Report Data
  final totalCancellations = 87.obs;
  final cancellationPercentage = 7.obs;
  final topCancellationReason = 'Out of stock'.obs;
  final topReasonPercentage = 34.obs;

  final cancellationReasons = <Map<String, dynamic>>[
    {'reason': 'Out of stock', 'count': 30, 'percentage': 34},
    {'reason': 'Long wait time', 'count': 21, 'percentage': 24},
    {'reason': 'Customer changed mind', 'count': 17, 'percentage': 20},
    {'reason': 'Wrong order placed', 'count': 11, 'percentage': 13},
    {'reason': 'Other', 'count': 8, 'percentage': 9},
  ].obs;

  // Inventory Report Data
  final totalItems = 47.obs;
  final lowStockItems = 3.obs;
  final outOfStockItems = 1.obs;

  final attentionRequiredItems = <Map<String, dynamic>>[
    {
      'name': 'Basmati Rice (50kg bag)',
      'threshold': '5 bags',
      'current': '3 bags',
      'status': 'Low stock',
    },
    {
      'name': 'Boneless Chicken (frozen)',
      'threshold': '15 kg',
      'current': '8 kg',
      'status': 'Low stock',
    },
    {
      'name': 'Groundnut Oil (25L)',
      'threshold': '4 kegs',
      'current': '2 kegs',
      'status': 'Low stock',
    },
    {
      'name': 'Tomato Paste (bulk)',
      'threshold': '10 cans',
      'current': '0',
      'status': 'Out of Stock',
    },
  ].obs;

  // Branch Performance Data
  final branchPerformance = <Map<String, dynamic>>[
    {
      'name': 'Lekki Phase 1',
      'revenue': 342100,
      'orders': 487,
      'avgPrep': '18min',
      'onTime': '94%',
    },
    {
      'name': 'Victoria Island',
      'revenue': 298650,
      'orders': 412,
      'avgPrep': '21min',
      'onTime': '91%',
    },
    {
      'name': 'Ikeja GRA',
      'revenue': 206480,
      'orders': 348,
      'avgPrep': '16min',
      'onTime': '96%',
    },
  ].obs;

  // Product Performance Data
  final productPerformance = <Map<String, dynamic>>[
    {
      'rank': 1,
      'name': 'Jollof Rice & Chicken',
      'revenue': 187450,
      'orders': 312,
      'rating': 4.8,
    },
    {
      'rank': 2,
      'name': 'Grilled Chicken Platter',
      'revenue': 134200,
      'orders': 198,
      'rating': 4.7,
    },
    {
      'rank': 3,
      'name': 'Pepper Soup (Large)',
      'revenue': 98700,
      'orders': 165,
      'rating': 4.9,
    },
    {
      'rank': 4,
      'name': 'Fried Rice & Turkey',
      'revenue': 87300,
      'orders': 142,
      'rating': 4.6,
    },
    {
      'rank': 5,
      'name': 'Egusi Soup & Fufu',
      'revenue': 74850,
      'orders': 128,
      'rating': 4.7,
    },
  ].obs;

  // Order Report Data
  final totalOrders = 1247.obs;
  final completedOrders = 1089.obs;
  final cancelledOrders = 87.obs;
  final rejectedOrders = 71.obs;

  // Sales Report Data
  final totalRevenue = 847230.0.obs;
  final totalOrdersForSales = 1247.obs;
  final avgOrderValue = 679.0.obs;

  final dailyRevenue = <Map<String, dynamic>>[
    {'date': 'Thu Aug 28', 'revenue': 98420, 'orders': 148},
    {'date': 'Fri Aug 29', 'revenue': 134810, 'orders': 201},
    {'date': 'Sat Aug 30', 'revenue': 121300, 'orders': 187},
    {'date': 'Sun Aug 31', 'revenue': 89640, 'orders': 134},
    {'date': 'Mon Sep 1', 'revenue': 102180, 'orders': 153},
    {'date': 'Tue Sep 2', 'revenue': 148920, 'orders': 224},
    {'date': 'Wed Sep 3', 'revenue': 151960, 'orders': 200},
  ].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  void loadReports() {
    // TODO: Load from API
    isLoading.value = false;
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    loadReports();
  }

  String formatCurrency(double amount) {
    return '₦${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  int get completionRate {
    if (totalOrders.value == 0) return 0;
    return ((completedOrders.value / totalOrders.value) * 100).round();
  }

  int get cancellationRate {
    if (totalOrders.value == 0) return 0;
    return ((cancelledOrders.value / totalOrders.value) * 100).round();
  }

  int get rejectionRate {
    if (totalOrders.value == 0) return 0;
    return ((rejectedOrders.value / totalOrders.value) * 100).round();
  }
}
