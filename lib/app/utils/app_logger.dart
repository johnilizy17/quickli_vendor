import 'package:flutter/foundation.dart';

void appLog(dynamic message, [dynamic extra]) {
  if (kDebugMode) {
    debugPrint('[Quickli-Vendor] $message${extra != null ? ' | $extra' : ''}');
  }
}
