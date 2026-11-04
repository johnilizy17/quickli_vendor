import 'package:flutter/services.dart';

/// Phone number formatter for Nigerian numbers
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove all non-digits
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 11 digits (for Nigerian numbers starting with 0)
    // or 13 digits (for numbers starting with +234)
    if (digitsOnly.length > 11 && !digitsOnly.startsWith('234')) {
      return oldValue;
    }
    
    return newValue;
  }
}

/// Account number formatter (10 digits for Nigerian banks)
class AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove all non-digits
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 10 digits
    if (digitsOnly.length > 10) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

/// BVN formatter (11 digits)
class BVNFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove all non-digits
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 11 digits
    if (digitsOnly.length > 11) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

/// Postal code formatter (6 digits)
class PostalCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove all non-digits
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    
    // Limit to 6 digits
    if (digitsOnly.length > 6) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

/// Uppercase formatter
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Currency formatter (for amounts)
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Remove all non-digits and non-decimal points
    final cleaned = text.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Ensure only one decimal point
    final parts = cleaned.split('.');
    if (parts.length > 2) {
      return oldValue;
    }
    
    // Limit decimal places to 2
    if (parts.length == 2 && parts[1].length > 2) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}

/// Name formatter (capitalize first letter of each word)
class NameFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Only allow letters, spaces, hyphens, and apostrophes
    if (text.isNotEmpty && !RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(text)) {
      return oldValue;
    }
    
    return newValue;
  }
}

/// CAC number formatter
class CACNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase();
    
    // CAC numbers start with RC or BN followed by digits
    if (text.isNotEmpty && !RegExp(r'^(RC|BN)?\d*$').hasMatch(text)) {
      return oldValue;
    }
    
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
