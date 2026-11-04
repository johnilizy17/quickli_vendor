import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isAuthEmail    = false.obs;
  final isLoading      = false.obs;
  final errorText      = ''.obs;
  final obscurePassword = true.obs;
  
  // Form validation
  final firstNameError = ''.obs;
  final lastNameError = ''.obs;
  final emailError = ''.obs;
  final phoneError = ''.obs;
  final passwordError = ''.obs;
  
  // Password strength
  final passwordStrength = ''.obs; // 'weak', 'medium', 'strong', ''
  final passwordStrengthColor = Rx<Color>(Colors.transparent);
  
  @override
  void onInit() {
    super.onInit();
    // Listen to password changes
    passwordController.addListener(_checkPasswordStrength);
  }
  
  void _checkPasswordStrength() {
    final password = passwordController.text;
    
    if (password.isEmpty) {
      passwordStrength.value = '';
      passwordStrengthColor.value = Colors.transparent;
      return;
    }
    
    // Calculate password strength
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    if (strength <= 2) {
      passwordStrength.value = 'Weak';
      passwordStrengthColor.value = Colors.red;
    } else if (strength <= 4) {
      passwordStrength.value = 'Medium';
      passwordStrengthColor.value = Colors.orange;
    } else {
      passwordStrength.value = 'Strong';
      passwordStrengthColor.value = Colors.green;
    }
  }
  
  bool validateSignupForm() {
    bool isValid = true;
    
    // Clear previous errors
    firstNameError.value = '';
    lastNameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    
    // First name validation
    if (firstNameController.text.trim().isEmpty) {
      firstNameError.value = 'First name is required';
      isValid = false;
    }
    
    // Last name validation
    if (lastNameController.text.trim().isEmpty) {
      lastNameError.value = 'Last name is required';
      isValid = false;
    }
    
    // Email validation
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }
    
    // Phone validation
    final phone = phoneNumberController.text.trim();
    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (phone.length < 10) {
      phoneError.value = 'Please enter a valid phone number';
      isValid = false;
    }
    
    // Password validation
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      isValid = false;
    }
    
    return isValid;
  }

  // TODO: implement requestOtp, verifyOtp, googleLogin

  @override
  void onClose() {
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
