import 'package:shared_preferences/shared_preferences.dart';

/// Handles persistent login state using SharedPreferences.
/// Only stores a simple boolean flag — no passwords are saved.
class AuthService {
  AuthService._(); // prevent instantiation

  static const String _keyIsLoggedIn = 'isLoggedIn';

  /// Returns true if the driver is currently logged in.
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Call this after a successful login to persist the session.
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  /// Clears the login flag. Call this on Log Out.
  static Future<void> logout() async {
    await setLoggedIn(false);
  }
}
