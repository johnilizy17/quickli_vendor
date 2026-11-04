class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  // Phone validation (Nigerian format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces, dashes, and parentheses
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check if it starts with +234, 234, or 0
    final phoneRegex = RegExp(r'^(\+?234|0)[789]\d{9}$');
    
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid Nigerian phone number';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Minimum length validation
  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    
    return null;
  }

  // Maximum length validation
  static String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    return null;
  }

  // Number validation
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  // Account number validation (Nigerian banks - 10 digits)
  static String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account number is required';
    }
    
    final cleaned = value.replaceAll(RegExp(r'\s'), '');
    
    if (cleaned.length != 10) {
      return 'Account number must be 10 digits';
    }
    
    if (!RegExp(r'^\d{10}$').hasMatch(cleaned)) {
      return 'Account number must contain only digits';
    }
    
    return null;
  }

  // BVN validation (11 digits)
  static String? validateBVN(String? value) {
    if (value == null || value.isEmpty) {
      return null; // BVN is optional
    }
    
    final cleaned = value.replaceAll(RegExp(r'\s'), '');
    
    if (cleaned.length != 11) {
      return 'BVN must be 11 digits';
    }
    
    if (!RegExp(r'^\d{11}$').hasMatch(cleaned)) {
      return 'BVN must contain only digits';
    }
    
    return null;
  }

  // TIN validation
  static String? validateTIN(String? value) {
    if (value == null || value.isEmpty) {
      return 'TIN is required';
    }
    
    // Nigerian TIN format varies, basic validation
    if (value.length < 8) {
      return 'Please enter a valid TIN';
    }
    
    return null;
  }

  // Postal code validation
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }
    
    // Nigerian postal codes are 6 digits
    final cleaned = value.replaceAll(RegExp(r'\s'), '');
    
    if (cleaned.length != 6) {
      return 'Postal code must be 6 digits';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(cleaned)) {
      return 'Postal code must contain only digits';
    }
    
    return null;
  }

  // Date validation
  static String? validateDate(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Date'} is required';
    }
    return null;
  }

  // Age validation (minimum age requirement)
  static String? validateAge(DateTime? date, int minAge) {
    if (date == null) {
      return 'Date of birth is required';
    }
    
    final today = DateTime.now();
    final age = today.year - date.year;
    final monthDiff = today.month - date.month;
    final dayDiff = today.day - date.day;
    
    final actualAge = age - (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0) ? 1 : 0);
    
    if (actualAge < minAge) {
      return 'You must be at least $minAge years old';
    }
    
    return null;
  }

  // Password strength validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // URL validation
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  // Business name validation
  static String? validateBusinessName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Business name is required';
    }
    
    if (value.length < 3) {
      return 'Business name must be at least 3 characters';
    }
    
    if (value.length > 100) {
      return 'Business name must not exceed 100 characters';
    }
    
    return null;
  }

  // ID number validation (basic)
  static String? validateIDNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'ID number is required';
    }
    
    if (value.length < 5) {
      return 'Please enter a valid ID number';
    }
    
    return null;
  }

  // CAC registration number validation
  static String? validateCACNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'CAC registration number is required';
    }
    
    // Nigerian CAC numbers typically start with RC or BN
    if (!RegExp(r'^(RC|BN)\d+$', caseSensitive: false).hasMatch(value)) {
      return 'Please enter a valid CAC number (e.g., RC123456)';
    }
    
    return null;
  }
}
