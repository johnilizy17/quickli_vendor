import 'package:get/get.dart';

class StaffMember {
  final String id;
  final String name;
  final String initials;
  final String role;
  final String location;
  final String lastActive;
  final String status; // 'online', 'away', 'offline'

  StaffMember({
    required this.id,
    required this.name,
    required this.initials,
    required this.role,
    required this.location,
    required this.lastActive,
    required this.status,
  });
}

class PendingInvite {
  final String id;
  final String name;
  final String initials;
  final String email;
  final String role;
  final String? location;
  final String invitedDate;

  PendingInvite({
    required this.id,
    required this.name,
    required this.initials,
    required this.email,
    required this.role,
    this.location,
    required this.invitedDate,
  });
}

class StaffActivity {
  final String action;
  final String staffName;
  final String role;
  final String location;
  final String details;
  final String? oldValue;
  final String? newValue;
  final String timestamp;

  StaffActivity({
    required this.action,
    required this.staffName,
    required this.role,
    required this.location,
    required this.details,
    this.oldValue,
    this.newValue,
    required this.timestamp,
  });
}

class ApprovalRequest {
  final String id;
  final String type; // 'price_change', 'promotion', 'role_change'
  final String title;
  final String requestedBy;
  final String timestamp;
  final String? currentValue;
  final String? proposedValue;
  final String status; // 'pending', 'approved', 'rejected'

  ApprovalRequest({
    required this.id,
    required this.type,
    required this.title,
    required this.requestedBy,
    required this.timestamp,
    this.currentValue,
    this.proposedValue,
    required this.status,
  });
}

class StaffController extends GetxController {
  final selectedTab = 'All'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  
  // Approval workflow settings
  final priceChangesRequireApproval = true.obs;
  final bulkEditsRequireApproval = true.obs;
  final roleChangesRequireApproval = true.obs;
  final promotionCreationRequireApproval = false.obs;
  final largeOrderCancellationsRequireApproval = true.obs;
  final inventoryAdjustmentsRequireApproval = false.obs;
  final notifyApproverViaPush = true.obs;
  final notifyRequesterOnDecision = true.obs;
  
  final selectedApprover = Rx<StaffMember?>(null);

  // Sample staff data
  final staffList = <StaffMember>[
    StaffMember(
      id: '1',
      name: 'Adaeze Okonkwo',
      initials: 'AO',
      role: 'Branch Manager',
      location: 'Lekki Phase 1',
      lastActive: 'Just now',
      status: 'online',
    ),
    StaffMember(
      id: '2',
      name: 'Emeka Nwosu',
      initials: 'EN',
      role: 'Cashier',
      location: 'Victoria Island',
      lastActive: '5 min ago',
      status: 'online',
    ),
    StaffMember(
      id: '3',
      name: 'Fatima Bello',
      initials: 'FB',
      role: 'Kitchen Staff',
      location: 'Ikeja GRA',
      lastActive: '2 days ago',
      status: 'away',
    ),
    StaffMember(
      id: '4',
      name: 'Chidi Osei',
      initials: 'CO',
      role: 'Delivery Coordinator',
      location: 'Lekki Phase 1',
      lastActive: '1 hour ago',
      status: 'online',
    ),
  ].obs;

  // Pending invites
  final pendingInvites = <PendingInvite>[
    PendingInvite(
      id: '1',
      name: 'Ngozi Eze',
      initials: 'NE',
      email: 'ngozi.eze@gmail.com',
      role: 'Cashier',
      invitedDate: '2 days ago',
    ),
    PendingInvite(
      id: '2',
      name: 'Tunde Adeyemi',
      initials: 'TA',
      email: 'tunde.adeyemi@outlook.com',
      role: 'Kitchen Staff',
      invitedDate: '2 days ago',
    ),
    PendingInvite(
      id: '3',
      name: 'Grace Obi',
      initials: 'GO',
      email: 'grace.obi@email.com',
      role: 'Branch Manager',
      location: 'Victoria Island',
      invitedDate: '3 days ago',
    ),
  ].obs;

  // Staff activities
  final staffActivities = <StaffActivity>[
    StaffActivity(
      action: 'Changed product price',
      staffName: 'Adaeze Okonkwo',
      role: 'Manager',
      location: 'Lekki Phase 1',
      details: '₦2,500',
      oldValue: '₦2,500',
      newValue: '₦2,800',
      timestamp: 'Now',
    ),
    StaffActivity(
      action: 'Accepted order #QL-7841',
      staffName: 'Adaeze Okonkwo',
      role: 'Manager',
      location: 'Lekki Phase 1',
      details: '',
      timestamp: '8 min ago',
    ),
    StaffActivity(
      action: 'Updated payout account',
      staffName: 'Adaeze Okonkwo',
      role: 'Manager',
      location: 'Lekki Phase 1',
      details: '****1180',
      oldValue: '****1180',
      newValue: '****4821',
      timestamp: '32 min ago',
    ),
  ].obs;

  // Approval queue
  final approvalRequests = <ApprovalRequest>[
    ApprovalRequest(
      id: '1',
      type: 'price_change',
      title: 'Price change: Jollof Rice',
      requestedBy: 'Emeka Nwosu',
      timestamp: '2 hours ago',
      currentValue: '₦1,800',
      proposedValue: '₦2,100',
      status: 'pending',
    ),
    ApprovalRequest(
      id: '2',
      type: 'promotion',
      title: 'New promotion: Lunch Deal',
      requestedBy: 'Fatima Bello',
      timestamp: '4 hours ago',
      status: 'pending',
    ),
    ApprovalRequest(
      id: '3',
      type: 'role_change',
      title: 'Staff role change: Chidi Osei',
      requestedBy: 'Adaeze Okonkwo',
      timestamp: 'Yesterday',
      status: 'pending',
    ),
  ].obs;

  final completedApprovals = <ApprovalRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStaffData();
    // Set initial approver
    if (staffList.isNotEmpty) {
      selectedApprover.value = staffList[0];
    }
  }

  void loadStaffData() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  List<StaffMember> get filteredStaff {
    var filtered = staffList.toList();
    
    // Filter by tab
    if (selectedTab.value == 'Active') {
      filtered = filtered.where((s) => s.status == 'online').toList();
    } else if (selectedTab.value == 'Suspended') {
      filtered = filtered.where((s) => s.status == 'away').toList();
    }
    
    // Filter by search
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((s) => 
        s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        s.role.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  StaffMember? getStaffById(String id) {
    try {
      return staffList.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  List<StaffActivity> getStaffActivities(String staffId) {
    // In real app, filter by staffId
    return staffActivities.toList();
  }

  void resendInvite(String inviteId) {
    Get.snackbar(
      'Success',
      'Invitation resent successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void cancelInvite(String inviteId) {
    pendingInvites.removeWhere((invite) => invite.id == inviteId);
    Get.snackbar(
      'Success',
      'Invitation cancelled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void approveRequest(String requestId) {
    final request = approvalRequests.firstWhere((r) => r.id == requestId);
    approvalRequests.removeWhere((r) => r.id == requestId);
    completedApprovals.add(ApprovalRequest(
      id: request.id,
      type: request.type,
      title: request.title,
      requestedBy: request.requestedBy,
      timestamp: request.timestamp,
      currentValue: request.currentValue,
      proposedValue: request.proposedValue,
      status: 'approved',
    ));
    Get.snackbar(
      'Approved',
      'Request approved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rejectRequest(String requestId) {
    final request = approvalRequests.firstWhere((r) => r.id == requestId);
    approvalRequests.removeWhere((r) => r.id == requestId);
    completedApprovals.add(ApprovalRequest(
      id: request.id,
      type: request.type,
      title: request.title,
      requestedBy: request.requestedBy,
      timestamp: request.timestamp,
      currentValue: request.currentValue,
      proposedValue: request.proposedValue,
      status: 'rejected',
    ));
    Get.snackbar(
      'Rejected',
      'Request rejected',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void changeApprover() {
    // Show approver selection dialog
    Get.snackbar(
      'Info',
      'Approver selection coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  int get pendingApprovalsCount => approvalRequests.length;
}
