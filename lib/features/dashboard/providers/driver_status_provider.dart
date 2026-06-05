import 'package:flutter/material.dart';

/// Simple provider to manage driver online/offline status.
class DriverStatusProvider with ChangeNotifier {
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  void toggleStatus() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  /// Optionally set status directly.
  void setOnline(bool online) {
    if (_isOnline != online) {
      _isOnline = online;
      notifyListeners();
    }
  }
}
