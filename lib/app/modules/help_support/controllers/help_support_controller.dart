import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SupportTicket {
  final String id;
  final String title;
  final String ticketNumber;
  final String date;
  final String status; // 'under_review', 'resolved', 'in_progress'
  final String category;

  SupportTicket({
    required this.id,
    required this.title,
    required this.ticketNumber,
    required this.date,
    required this.status,
    required this.category,
  });
}

class ChatMessage {
  final String id;
  final String message;
  final String timestamp;
  final bool isVendor; // true if from vendor, false if from support

  ChatMessage({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.isVendor,
  });
}

class HelpSupportController extends GetxController {
  final issueDescriptionController = TextEditingController();
  final chatMessageController = TextEditingController();
  
  final isLoading = false.obs;
  final selectedImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();

  // Sample tickets
  final openTickets = <SupportTicket>[
    SupportTicket(
      id: '1',
      title: 'Payout issue',
      ticketNumber: '#TKT-4821',
      date: 'Today 10:15 AM',
      status: 'under_review',
      category: 'payment',
    ),
    SupportTicket(
      id: '2',
      title: 'Payout issue',
      ticketNumber: '#TKT-4790',
      date: 'Yesterday',
      status: 'under_review',
      category: 'payment',
    ),
  ].obs;

  final resolvedTickets = <SupportTicket>[
    SupportTicket(
      id: '3',
      title: 'Payout issue',
      ticketNumber: '#TKT-4750',
      date: 'Jun 20',
      status: 'resolved',
      category: 'payment',
    ),
    SupportTicket(
      id: '4',
      title: 'Payout issue',
      ticketNumber: '#TKT-4750',
      date: 'Jun 20',
      status: 'resolved',
      category: 'payment',
    ),
  ].obs;

  // Sample chat messages
  final chatMessages = <ChatMessage>[
    ChatMessage(
      id: '1',
      message: 'Hi, I haven\'t received my payout for the week of Aug 26–Sep 1. It shows as \'Pending\' since Sep 3.',
      timestamp: 'Delivered 8:11 PM',
      isVendor: true,
    ),
    ChatMessage(
      id: '2',
      message: 'Hi! I can see your payout for that period. It\'s currently under review due to our automated compliance check. I\'ll escalate this now.',
      timestamp: 'Sent 8:11 PM',
      isVendor: false,
    ),
    ChatMessage(
      id: '3',
      message: 'Update: Your payout has been cleared and will be processed within 24 hours. You\'ll receive a notification once it\'s sent. Ref: PAY-2026090200142.',
      timestamp: 'Sent 8:11 PM',
      isVendor: false,
    ),
    ChatMessage(
      id: '4',
      message: 'Thank you! Appreciate the quick help.',
      timestamp: 'Delivered 8:11 PM',
      isVendor: true,
    ),
  ].obs;

  @override
  void onClose() {
    issueDescriptionController.dispose();
    chatMessageController.dispose();
    super.onClose();
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        selectedImages.add(image);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image');
    }
  }

  Future<void> pickImagesFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      selectedImages.addAll(images);
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images');
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void reportIssue(String category) {
    Get.toNamed('/help-support/report-issue', arguments: category);
  }

  void submitTicket() {
    if (issueDescriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please describe the issue');
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar('Success', 'Support ticket created successfully');
      Get.back();
      issueDescriptionController.clear();
      selectedImages.clear();
    });
  }

  void sendMessage() {
    if (chatMessageController.text.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: chatMessageController.text,
      timestamp: 'Sending...',
      isVendor: true,
    );

    chatMessages.add(message);
    chatMessageController.clear();

    // Simulate message sent
    Future.delayed(const Duration(seconds: 1), () {
      final index = chatMessages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        chatMessages[index] = ChatMessage(
          id: message.id,
          message: message.message,
          timestamp: 'Delivered ${TimeOfDay.now().format(Get.context!)}',
          isVendor: true,
        );
      }
    });
  }

  void openChat() {
    // Open live chat
    Get.snackbar('Info', 'Opening chat with support team...');
  }

  void callSupport() {
    // Make phone call
    Get.snackbar('Info', 'Calling support: +234 800 123 4567');
  }

  String getCategoryName(String category) {
    switch (category) {
      case 'order':
        return 'Order Issue';
      case 'payment':
        return 'Payment/Payout';
      case 'product':
        return 'Product Issue';
      case 'technical':
        return 'Technical';
      case 'account':
        return 'Account';
      case 'other':
        return 'Other';
      default:
        return 'Issue';
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'under_review':
        return 'Under review';
      case 'resolved':
        return 'Resolved';
      case 'in_progress':
        return 'In progress';
      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'under_review':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
