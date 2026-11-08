import 'package:get/get.dart';

class Review {
  final String id;
  final int rating;
  final String comment;
  final String customerName;
  final String date;
  final String time;
  final String orderId;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.customerName,
    required this.date,
    required this.time,
    required this.orderId,
  });
}

class RatingsReviewsController extends GetxController {
  final selectedFilter = 'All'.obs;
  final currentPage = 1.obs;
  final isLoading = false.obs;

  // Sample data
  final reviews = <Review>[
    Review(
      id: '1',
      rating: 3,
      comment: 'Very fast and polite. Rider kept me updated!',
      customerName: 'Faith Dosumu',
      date: 'Sep 18, 2024',
      time: '4:45 PM',
      orderId: '#QL-8273',
    ),
    Review(
      id: '2',
      rating: 3,
      comment: 'Very fast and polite. Rider kept me updated!',
      customerName: 'Faith Dosumu',
      date: 'Sep 18, 2024',
      time: '4:45 PM',
      orderId: '#QL-8273',
    ),
    Review(
      id: '3',
      rating: 3,
      comment: 'Very fast and polite. Rider kept me updated!',
      customerName: 'Faith Dosumu',
      date: 'Sep 18, 2024',
      time: '4:45 PM',
      orderId: '#QL-8273',
    ),
    Review(
      id: '4',
      rating: 3,
      comment: 'Very fast and polite. Rider kept me updated!',
      customerName: 'Faith Dosumu',
      date: 'Sep 18, 2024',
      time: '4:45 PM',
      orderId: '#QL-8273',
    ),
    Review(
      id: '5',
      rating: 3,
      comment: 'Very fast and polite. Rider kept me updated!',
      customerName: 'Faith Dosumu',
      date: 'Sep 18, 2024',
      time: '4:45 PM',
      orderId: '#QL-8273',
    ),
  ].obs;

  final totalReviews = 278.obs;
  final averageRating = 4.6.obs;

  // Rating distribution
  final fiveStarCount = 180.obs;
  final fourStarCount = 60.obs;
  final threeStarCount = 25.obs;
  final twoStarCount = 8.obs;
  final oneStarCount = 5.obs;

  @override
  void onInit() {
    super.onInit();
    loadReviews();
  }

  void loadReviews() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  List<Review> get filteredReviews {
    if (selectedFilter.value == 'All') {
      return reviews;
    } else if (selectedFilter.value == '5 ⭐') {
      return reviews.where((r) => r.rating == 5).toList();
    } else if (selectedFilter.value == '4 ⭐') {
      return reviews.where((r) => r.rating == 4).toList();
    } else if (selectedFilter.value == '3 ⭐') {
      return reviews.where((r) => r.rating == 3).toList();
    } else if (selectedFilter.value == '2 & below ⭐') {
      return reviews.where((r) => r.rating <= 2).toList();
    }
    return reviews;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void nextPage() {
    if (currentPage.value * 5 < totalReviews.value) {
      currentPage.value++;
      loadReviews();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      loadReviews();
    }
  }

  int get totalPages => (totalReviews.value / 5).ceil();
  
  String get pageInfo {
    final start = ((currentPage.value - 1) * 5) + 1;
    final end = (currentPage.value * 5).clamp(0, totalReviews.value);
    return 'Showing $start-$end from ${totalReviews.value}';
  }
}
