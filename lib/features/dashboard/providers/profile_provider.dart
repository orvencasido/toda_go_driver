import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toda_go_driver/core/models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel _profile = ProfileModel(
    name: 'Joross A. Buera',
    contact: '0912 345 6789',
    email: 'jorossbuera@email.com',
    address: '123 Barangay Street, Quezon City',
    todaNumber: 'TODA 321',
    licenseNumber: 'N02-00-123456',
    vehicleDetails: 'Honda Wave 125 – ABC 1234',
    verificationStatus: 'Verified',
    accountStatus: 'Active',
    password: 'password123',
    imagePath: null,
  );

  bool _isLoading = false;

  ProfileModel get profile => _profile;
  bool get isLoading => _isLoading;

  static const String _prefsKey = 'driver_profile_data';

  /// Fetches the profile from the server/caching.
  /// Simulates an API call (HTTP GET /profile) with delay.
  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    // Simulate backend network latency
    await Future.delayed(const Duration(milliseconds: 700));

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_prefsKey);
      
      if (cachedData != null) {
        _profile = ProfileModel.fromJson(cachedData);
      } else {
        // First run: persist the default profile details
        await prefs.setString(_prefsKey, _profile.toJson());
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates profile contact, email, and address.
  /// Simulates calling the backend server API (HTTP PUT /profile/update).
  Future<bool> updateProfile({
    required String contact,
    required String email,
    required String address,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate backend network latency
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Simulate API server validation rules
      if (contact.trim().isEmpty || email.trim().isEmpty || address.trim().isEmpty) {
        throw Exception("Validation failed: fields cannot be empty");
      }
      if (!email.contains('@')) {
        throw Exception("Validation failed: invalid email format");
      }

      // Simulated successful API response
      // In a real application, we would call:
      // final response = await http.put(Uri.parse('https://api.tayabastodago.com/driver/profile'), body: {...});
      // if (response.statusCode != 200) return false;

      // Update state
      _profile = _profile.copyWith(
        contact: contact.trim(),
        email: email.trim(),
        address: address.trim(),
      );

      // Persist to local cache (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, _profile.toJson());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("API update profile failed: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Changes the profile password.
  /// Simulates calling the backend server API (HTTP POST /profile/change-password).
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      if (currentPassword != _profile.password) {
        throw Exception("Incorrect current password");
      }
      if (newPassword.length < 6) {
        throw Exception("Password is too short");
      }

      // Simulated successful API response
      _profile = _profile.copyWith(password: newPassword);

      // Persist locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, _profile.toJson());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("API change password failed: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Updates profile photo path.
  Future<void> updateProfileImage(String path) async {
    _profile = _profile.copyWith(imagePath: path);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _profile.toJson());
    notifyListeners();
  }
}
