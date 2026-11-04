import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/api_route.dart';
import '../../../models/vendor_user.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_service.dart';
import '../../../services/main_storage.dart';
import '../../../utils/app_logger.dart';
import '../views/verify_phone_view.dart';
import '../views/verify_email_view.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final emailOtpController = TextEditingController();
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();
  
  final otpFocusNode = FocusNode();
  final emailOtpFocusNode = FocusNode();
  
  final isAuthEmail    = false.obs;
  final isLoading      = false.obs;
  final errorText      = ''.obs;
  final obscurePassword = true.obs;
  final obscureLoginPassword = true.obs;
  
  // OTP resend timer
  final canResendOtp = false.obs;
  final resendTimer = 60.obs;
  Timer? _resendTimer;
  
  // Email OTP resend timer
  final canResendEmailOtp = false.obs;
  final resendEmailTimer = 60.obs;
  Timer? _resendEmailTimer;
  
  // Form validation
  final firstNameError = ''.obs;
  final lastNameError = ''.obs;
  final emailError = ''.obs;
  final phoneError = ''.obs;
  final passwordError = ''.obs;
  final loginUsernameError = ''.obs;
  final loginPasswordError = ''.obs;
  
  // Email availability check
  final isCheckingEmail = false.obs;
  final emailAvailable = true.obs;
  Timer? _emailCheckDebounce;
  
  // Password strength
  final passwordStrength = ''.obs; // 'Too weak', 'Weak', 'Good', 'Strong', ''
  final passwordStrengthColor = Rx<Color>(Colors.transparent);
  
  @override
  void onInit() {
    super.onInit();
    // Listen to password changes
    passwordController.addListener(_checkPasswordStrength);
    // Listen to email changes for live validation and availability check
    emailController.addListener(_handleEmailChange);
    // Listen to phone changes for live validation
    phoneNumberController.addListener(_validatePhoneLive);
  }
  
  void _handleEmailChange() {
    _validateEmailLive();
    _checkEmailAvailability();
  }
  
  void _checkEmailAvailability() {
    final email = emailController.text.trim();
    
    // Cancel previous debounce
    _emailCheckDebounce?.cancel();
    
    // Don't check if email is empty or invalid
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      emailAvailable.value = true;
      isCheckingEmail.value = false;
      return;
    }
    
    // Show checking state
    isCheckingEmail.value = true;
    
    // Debounce the API call (wait 500ms after user stops typing)
    _emailCheckDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final response = await ApiService.to.post(
          ApiRoute.checkEmailAvailability,
          data: {'email': email},
        );
        
        if (response.statusCode == 200) {
          final data = response.data;
          emailAvailable.value = data['available'] ?? true;
          
          if (!emailAvailable.value) {
            emailError.value = 'Email is already registered';
          } else if (emailError.value == 'Email is already registered') {
            emailError.value = '';
          }
        }
      } catch (e) {
        appLog('Email availability check error: $e');
        emailAvailable.value = true; // Assume available on error
      } finally {
        isCheckingEmail.value = false;
      }
    });
  }
  
  void _validateEmailLive() {
    final email = emailController.text.trim();
    
    // Don't show error if field is empty
    if (email.isEmpty) {
      if (emailError.value != 'Email is already registered') {
        emailError.value = '';
      }
      return;
    }
    
    // Show error for invalid format
    if (!GetUtils.isEmail(email)) {
      emailError.value = 'Please submit a valid email';
    } else if (emailError.value == 'Please submit a valid email') {
      // Clear the invalid format error when format becomes valid
      emailError.value = '';
    }
  }
  
  void _validatePhoneLive() {
    final phone = phoneNumberController.text.trim();
    if (phone.isEmpty) {
      phoneError.value = '';
      return;
    }
    
    if (!GetUtils.isNumericOnly(phone.replaceAll('+', ''))) {
      phoneError.value = 'Phone number must contain only numbers';
    } else if (phone.length < 10) {
      phoneError.value = 'Please enter a valid phone number';
    } else {
      phoneError.value = '';
    }
  }
  
  void _checkPasswordStrength() {
    final password = passwordController.text;
    
    if (password.isEmpty) {
      passwordStrength.value = '';
      passwordStrengthColor.value = Colors.transparent;
      return;
    }
    
    // Calculate password strength based on criteria
    int criteriaCount = 0;
    
    // Criteria 1: More than 6 characters
    if (password.length > 6) criteriaCount++;
    
    // Criteria 2: Contains numbers
    if (password.contains(RegExp(r'[0-9]'))) criteriaCount++;
    
    // Criteria 3: Contains lowercase letters
    if (password.contains(RegExp(r'[a-z]'))) criteriaCount++;
    
    // Criteria 4: Contains uppercase letters
    if (password.contains(RegExp(r'[A-Z]'))) criteriaCount++;
    
    // Criteria 5: Contains symbols
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) criteriaCount++;
    
    // Set strength based on criteria met
    if (criteriaCount == 1) {
      passwordStrength.value = 'Too weak';
      passwordStrengthColor.value = Colors.red;
    } else if (criteriaCount == 2) {
      passwordStrength.value = 'Weak';
      passwordStrengthColor.value = const Color(0xFFFFA500); // Orange
    } else if (criteriaCount == 3) {
      passwordStrength.value = 'Good';
      passwordStrengthColor.value = const Color(0xFF90EE90); // Light green
    } else if (criteriaCount >= 4) {
      passwordStrength.value = 'Strong';
      passwordStrengthColor.value = const Color(0xFF00C853); // Green
    }
  }
  
  bool validateLoginForm() {
    bool isValid = true;
    
    // Clear previous errors
    loginUsernameError.value = '';
    loginPasswordError.value = '';
    
    // Username (email or phone) validation
    final username = loginUsernameController.text.trim();
    if (username.isEmpty) {
      loginUsernameError.value = 'Email or phone number is required';
      isValid = false;
    }
    
    // Password validation
    final password = loginPasswordController.text;
    if (password.isEmpty) {
      loginPasswordError.value = 'Password is required';
      isValid = false;
    }
    
    return isValid;
  }
  
  Future<void> login() async {
    // Validate form
    if (!validateLoginForm()) {
      return;
    }
    
    isLoading.value = true;
    errorText.value = '';
    
    try {
      final username = loginUsernameController.text.trim();
      final isEmail = GetUtils.isEmail(username);
      
      final response = await ApiService.to.post(
        ApiRoute.login,
        data: {
          'username': username,
          'method': isEmail ? 'email' : 'phone',
          'password': loginPasswordController.text,
        },
      );
      
      appLog('Login response: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success' && data['data'] != null) {
          final userData = data['data'];
          
          // Save tokens
          final accessToken = userData['accessToken'];
          final refreshToken = userData['refreshToken'];
          
          if (accessToken != null && refreshToken != null) {
            ApiService.to.setTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
            
            // Save user data
            VendorUser.setUser(userData);
            
            // Mark onboarding as completed
            MainStorage.saveOnboardingCompleted(true);
            
            Get.snackbar(
              'Success',
              'Login successful!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF00C853),
              colorText: Colors.white,
            );
            
            // Check if email is verified
            final emailVerified = userData['emailVerified'] ?? false;
            
            if (!emailVerified) {
              // Navigate to email verification
              _startResendEmailTimer();
              Get.off(
                () => const VerifyEmailView(),
                arguments: {'email': userData['email']},
              );
            } else {
              // Navigate based on verification status
              final verification = userData['verification'];
              final kycStatus = verification?['kycStatus'] ?? 'pending';
              final isFullyVerified = verification?['isFullyVerified'] ?? false;
              
              if (isFullyVerified || kycStatus == 'verified') {
                Get.offAllNamed(Routes.WRAPPER);
              } else {
                // Need to complete onboarding/KYC
                Get.offAllNamed(Routes.AUTH);
              }
            }
          }
        } else {
          errorText.value = data['message'] ?? 'Login failed. Please try again.';
          Get.snackbar(
            'Error',
            errorText.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorText.value = 'Login failed. Please check your credentials.';
        Get.snackbar(
          'Error',
          errorText.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Login error: $e');
      
      // Parse error message
      String errorMessage = 'An error occurred. Please try again.';
      
      if (e.toString().contains('Invalid') || e.toString().contains('credentials')) {
        errorMessage = 'Invalid email/phone or password';
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      }
      
      errorText.value = errorMessage;
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
      emailError.value = 'Please submit a valid email';
      isValid = false;
    } else if (!emailAvailable.value) {
      emailError.value = 'Email is already registered';
      isValid = false;
    }
    
    // Phone validation
    final phone = phoneNumberController.text.trim();
    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (!GetUtils.isNumericOnly(phone.replaceAll('+', ''))) {
      phoneError.value = 'Phone number must contain only numbers';
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
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }
    
    return isValid;
  }
  
  Future<void> signup() async {
    // Validate form
    if (!validateSignupForm()) {
      return;
    }
    
    // Check if still checking email availability
    if (isCheckingEmail.value) {
      Get.snackbar(
        'Please wait',
        'Checking email availability...',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    isLoading.value = true;
    errorText.value = '';
    
    try {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final fullname = '$firstName $lastName';
      
      final response = await ApiService.to.post(
        ApiRoute.signup,
        data: {
          'fullname': fullname,
          'email': emailController.text.trim(),
          'phone': phoneNumberController.text.trim(),
          'password': passwordController.text,
        },
      );
      
      appLog('Signup response: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        if (data['status'] == 'success') {
          // Signup successful - navigate to email verification
          Get.snackbar(
            'Success',
            'Please verify your email address',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF00C853),
            colorText: Colors.white,
          );
          
          // Start email resend timer
          _startResendEmailTimer();
          
          // Navigate to email verification
          Get.to(
            () => const VerifyEmailView(),
            arguments: {'email': emailController.text.trim()},
          );
        } else {
          errorText.value = data['message'] ?? 'Signup failed. Please try again.';
          Get.snackbar(
            'Error',
            errorText.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorText.value = 'Signup failed. Please try again.';
        Get.snackbar(
          'Error',
          errorText.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Signup error: $e');
      
      // Parse error message
      String errorMessage = 'An error occurred. Please try again.';
      
      if (e.toString().contains('email')) {
        errorMessage = 'Email is already registered';
        emailError.value = errorMessage;
      } else if (e.toString().contains('phone')) {
        errorMessage = 'Phone number is already registered';
        phoneError.value = errorMessage;
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      }
      
      errorText.value = errorMessage;
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void _startResendTimer() {
    canResendOtp.value = false;
    resendTimer.value = 60;
    
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResendOtp.value = true;
        timer.cancel();
      }
    });
  }
  
  Future<void> verifyPhone(String code) async {
    isLoading.value = true;
    errorText.value = '';
    
    try {
      final response = await ApiService.to.post(
        ApiRoute.verifyPhone,
        data: {
          'phone': phoneNumberController.text.trim(),
          'code': code,
        },
      );
      
      appLog('Verify phone response: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success' && data['data'] != null) {
          final userData = data['data'];
          
          // Save tokens
          final accessToken = userData['accessToken'];
          final refreshToken = userData['refreshToken'];
          
          if (accessToken != null && refreshToken != null) {
            ApiService.to.setTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
            
            // Save user data
            VendorUser.setUser(userData);
            
            // Mark onboarding as completed
            MainStorage.saveOnboardingCompleted(true);
            
            Get.snackbar(
              'Success',
              'Phone verified successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF00C853),
              colorText: Colors.white,
            );
            
            // Navigate based on verification status
            final verification = userData['verification'];
            final kycStatus = verification?['kycStatus'] ?? 'pending';
            final isFullyVerified = verification?['isFullyVerified'] ?? false;
            
            if (isFullyVerified || kycStatus == 'verified') {
              Get.offAllNamed(Routes.WRAPPER);
            } else {
              // Need to complete onboarding/KYC
              Get.offAllNamed(Routes.AUTH);
            }
          }
        } else {
          errorText.value = data['message'] ?? 'Verification failed';
          Get.snackbar(
            'Error',
            errorText.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorText.value = 'Invalid verification code';
        Get.snackbar(
          'Error',
          errorText.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Verify phone error: $e');
      
      // Parse error message
      String errorMessage = 'Verification failed. Please try again.';
      
      if (e.toString().contains('invalid') || e.toString().contains('code')) {
        errorMessage = 'Invalid verification code. Please try again.';
      } else if (e.toString().contains('expired')) {
        errorMessage = 'Verification code has expired. Please request a new one.';
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      }
      
      errorText.value = errorMessage;
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> resendOtp() async {
    if (!canResendOtp.value) return;
    
    try {
      isLoading.value = true;
      
      final response = await ApiService.to.post(
        ApiRoute.resendPhoneOTP,
        data: {
          'phone': phoneNumberController.text.trim(),
        },
      );
      
      appLog('Resend OTP response: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        Get.snackbar(
          'Success',
          data['message'] ?? 'Verification code sent',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00C853),
          colorText: Colors.white,
        );
        
        // Restart timer
        _startResendTimer();
      } else {
        Get.snackbar(
          'Error',
          'Failed to resend code. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Resend OTP error: $e');
      
      // Parse error message
      String errorMessage = 'Failed to resend code';
      
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('limit') || e.toString().contains('too many')) {
        errorMessage = 'Too many requests. Please try again later.';
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendEmailTimer() {
    canResendEmailOtp.value = false;
    resendEmailTimer.value = 60;
    
    _resendEmailTimer?.cancel();
    _resendEmailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendEmailTimer.value > 0) {
        resendEmailTimer.value--;
      } else {
        canResendEmailOtp.value = true;
        timer.cancel();
      }
    });
  }
  
  Future<void> verifyEmail(String code) async {
    isLoading.value = true;
    errorText.value = '';
    
    try {
      final response = await ApiService.to.post(
        ApiRoute.verifyEmail,
        data: {
          'email': emailController.text.trim(),
          'code': code,
        },
      );
      
      appLog('Verify email response: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'success' && data['data'] != null) {
          final userData = data['data'];
          
          // Update tokens if new ones are provided
          final accessToken = userData['accessToken'];
          final refreshToken = userData['refreshToken'];
          
          if (accessToken != null && refreshToken != null) {
            ApiService.to.setTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
          }
          
          // Save user data
          VendorUser.setUser(userData);
          
          Get.snackbar(
            'Success',
            'Email verified successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF00C853),
            colorText: Colors.white,
          );
          
          // Navigate based on verification status
          final verification = userData['verification'];
          final kycStatus = verification?['kycStatus'] ?? 'pending';
          final isFullyVerified = verification?['isFullyVerified'] ?? false;
          
          if (isFullyVerified || kycStatus == 'verified') {
            Get.offAllNamed(Routes.WRAPPER);
          } else {
            // Need to complete onboarding/KYC
            Get.offAllNamed(Routes.AUTH);
          }
        } else {
          errorText.value = data['message'] ?? 'Verification failed';
          Get.snackbar(
            'Error',
            errorText.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorText.value = 'Invalid verification code';
        Get.snackbar(
          'Error',
          errorText.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Verify email error: $e');
      
      // Parse error message
      String errorMessage = 'Verification failed. Please try again.';
      
      if (e.toString().contains('invalid') || e.toString().contains('code')) {
        errorMessage = 'Invalid verification code. Please try again.';
      } else if (e.toString().contains('expired')) {
        errorMessage = 'Verification code has expired. Please request a new one.';
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      }
      
      errorText.value = errorMessage;
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> resendEmailOtp() async {
    if (!canResendEmailOtp.value) return;
    
    try {
      isLoading.value = true;
      
      final response = await ApiService.to.post(
        ApiRoute.resendEmailOTP,
        data: {
          'email': emailController.text.trim(),
        },
      );
      
      appLog('Resend email OTP response: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        Get.snackbar(
          'Success',
          data['message'] ?? 'Verification code sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00C853),
          colorText: Colors.white,
        );
        
        // Restart timer
        _startResendEmailTimer();
      } else {
        Get.snackbar(
          'Error',
          'Failed to resend code. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Resend email OTP error: $e');
      
      // Parse error message
      String errorMessage = 'Failed to resend code';
      
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('limit') || e.toString().contains('too many')) {
        errorMessage = 'Too many requests. Please try again later.';
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // TODO: implement googleLogin

  @override
  void onClose() {
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    otpController.dispose();
    emailOtpController.dispose();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    otpFocusNode.dispose();
    emailOtpFocusNode.dispose();
    _emailCheckDebounce?.cancel();
    _resendTimer?.cancel();
    _resendEmailTimer?.cancel();
    super.onClose();
  }
}
