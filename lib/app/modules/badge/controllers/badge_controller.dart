import 'package:get/get.dart';

class BadgeController extends GetxController {
  final currentBadge = 'Starter'.obs;
  final currentPoints = 245.obs;
  final nextBadgePoints = 500.obs;
  
  final badges = <Map<String, dynamic>>[
    {
      'name': 'Starter',
      'icon': 'S',
      'color': 0xFF9E9E9E, // Grey
      'pointsRequired': 0,
      'status': 'CURRENT',
      'description': '0-449 POINTS',
      'benefits': [
        'Basic analytics',
        'Standard support',
        '99 fulfilled Store Milestones',
        '100 fulfilled Order Milestones',
        '3 Share Listing',
        'Below 4 Digit Rating',
      ],
    },
    {
      'name': 'Influencer',
      'icon': 'I',
      'color': 0xFFFF6B00, // Orange
      'pointsRequired': 500,
      'status': 'IN PROGRESS',
      'description': '500 pts',
      'benefits': [
        'Priority support',
        'Advanced rewards',
        '199 fulfilled orders',
        '100 fulfilled Store Milestones',
        'Multiple outlets available',
      ],
    },
    {
      'name': 'Ambassador',
      'icon': 'A',
      'color': 0xFFFFC107, // Amber
      'pointsRequired': 1000,
      'status': 'LOCKED',
      'description': '1,000 pts',
      'benefits': [
        'Early access',
        'Exclusive rewards',
        '499 fulfilled orders',
        '200 fulfilled Store Milestones',
        'Multiple outlets available',
        'Badge display on profile',
      ],
    },
    {
      'name': 'Champion',
      'icon': 'C',
      'color': 0xFF2196F3, // Blue
      'pointsRequired': 2500,
      'status': 'LOCKED',
      'description': '2,500 pts',
      'benefits': [
        'VIP Support',
        '500+ Monthly orders',
        'Excellent ratings',
        '999 fulfilled orders',
        '300 fulfilled Store Milestones',
        'Badge display on profile',
      ],
    },
    {
      'name': 'Legend',
      'icon': 'L',
      'color': 0xFF7C4DFF, // Purple
      'pointsRequired': 5000,
      'status': 'LOCKED',
      'description': '5,000 pts',
      'benefits': [
        'Dedicated account manager',
        '1000+ monthly orders',
        'Exceptional service',
        '1999 fulfilled orders',
        '500 fulfilled Store Milestones',
        'Multiple outlets available',
        'Badge display on profile',
      ],
    },
  ].obs;

  double get progressPercentage {
    if (nextBadgePoints.value == 0) return 0;
    return (currentPoints.value / nextBadgePoints.value).clamp(0.0, 1.0);
  }

  int get pointsRemaining {
    return (nextBadgePoints.value - currentPoints.value).clamp(0, nextBadgePoints.value);
  }
}
