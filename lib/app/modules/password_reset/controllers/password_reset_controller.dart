import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../../constants/api_route.dart';

class PasswordResetController extends GetxController {
  // Step 1: Email
  final emailController = TextEditingController();
  final emailError = ''.obs;
  final isLoading = false.obs;

  // Step 2: Verify code
  final resetCodeController = TextEditingController();
  final resetCodeFocusNode = FocusNode();
  final resetCodeTimer = 60.obs;
  final isVerifyingCode = false.obs;
  Timer? _resetCodeTimer;

  // Step 3: New password
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final confirmPasswordError = ''.obs;
  final isUpdatingPassword = false.obs;

  // Password strength
  final passwordStrength = 0.obs;
  final has8Characters = false.obs;
  final hasUpperLower = false.obs;
  final hasNumber = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    resetCodeController.dispose();
    resetCodeFocusNode.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _resetCodeTimer?.cancel();
    super.onClose();
  }

  // Validate email format
  bool validateEmail() {
    emailError.value = '';
    
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    }
    
    // Check if it's a valid email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emailError.value = 'Please submit a valid email';
      return false;
    }
    
    return true;
  }

  // Send reset password OTP
  Future<void> sendResetLink() async {
    if (!validateEmail()) return;

    isLoading.value = true;

    try {
      print('🔐 PasswordReset: Sending reset code to ${emailController.text.trim()}');
      
      final response = await ApiService.to.post(
        ApiRoute.requestPasswordReset,
        data: {
          'email': emailController.text.trim(),
        },
      );

      print('🔐 PasswordReset: Response status: ${response.statusCode}');
      print('🔐 PasswordReset: Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'A verification code has been sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Start timer and navigate to verification
        startResetCodeTimer();
        Get.toNamed('/password-reset/verify');
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to send reset code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('🔐 PasswordReset: Error sending reset code: $e');
      
      String errorMessage = 'An error occurred. Please try again.';
      
      // Try to extract error message from DioException
      if (e.toString().contains('DioException')) {
        final errorStr = e.toString();
        if (errorStr.contains('message:')) {
          final msgStart = errorStr.indexOf('message:');
          final msgPart = errorStr.substring(msgStart);
          errorMessage = msgPart.split(',')[0].replaceAll('message:', '').trim();
        }
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Start reset code timer
  void startResetCodeTimer() {
    resetCodeTimer.value = 60;
    _resetCodeTimer?.cancel();
    _resetCodeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resetCodeTimer.value > 0) {
        resetCodeTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // Verify reset code (just validation, no separate API call)
  Future<void> verifyResetCode() async {
    final code = resetCodeController.text.trim();
    
    if (code.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter the 6-digit code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Just navigate to create new password
    // The code will be verified when updating password
    _resetCodeTimer?.cancel();
    Get.toNamed('/password-reset/new-password');
  }

  // Resend reset code
  Future<void> resendResetCode() async {
    try {
      final response = await ApiService.to.post(
        ApiRoute.requestPasswordReset,
        data: {
          'email': emailController.text.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Verification code has been resent',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        startResetCodeTimer();
        resetCodeController.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend code. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Check password strength
  void checkPasswordStrength(String password) {
    // Check criteria
    has8Characters.value = password.length >= 8;
    hasUpperLower.value = password.contains(RegExp(r'[A-Z]')) && 
                          password.contains(RegExp(r'[a-z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));

    // Calculate strength (0-4)
    int strength = 0;
    
    if (password.isEmpty) {
      strength = 0;
    } else if (password.length < 8) {
      // Too short = 1 bar (red)
      strength = 1;
    } else if (has8Characters.value && !hasUpperLower.value && !hasNumber.value) {
      // 8+ chars only = 1 bar (red)
      strength = 1;
    } else if (has8Characters.value && hasUpperLower.value && !hasNumber.value) {
      // 8+ chars + upper/lower = 3 bars (light green)
      strength = 3;
    } else if (has8Characters.value && !hasUpperLower.value && hasNumber.value) {
      // 8+ chars + number only = 2 bars (orange)
      strength = 2;
    } else if (has8Characters.value && hasUpperLower.value && hasNumber.value) {
      // All requirements met = 4 bars (green)
      strength = 4;
    } else {
      // Partial requirements = 2 bars (orange)
      strength = 2;
    }
    
    passwordStrength.value = strength;
  }

  // Validate passwords
  bool validatePasswords() {
    confirmPasswordError.value = '';
    
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    
    if (newPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a new password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (!has8Characters.value || !hasUpperLower.value || !hasNumber.value) {
      Get.snackbar(
        'Error',
        'Password must meet all requirements',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      return false;
    }
    
    if (newPassword != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match';
      return false;
    }
    
    return true;
  }

  // Update password
  Future<void> updatePassword() async {
    if (!validatePasswords()) return;

    isUpdatingPassword.value = true;

    try {
      final response = await ApiService.to.post(
        ApiRoute.resetPassword,
        data: {
          'email': emailController.text.trim(),
          'code': resetCodeController.text.trim(),
          'newPassword': newPasswordController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Password updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Navigate back to login after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed('/auth');
        });
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to update password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingPassword.value = false;
    }
  }
}
