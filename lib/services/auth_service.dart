import '../models/user_model.dart';

/// Simple in-memory driver session — local auth state manager.
class AppSession {
  static AppUser? _currentUser;

  static AppUser? get currentUser => _currentUser;

  static void setUser(AppUser? user) => _currentUser = user;

  static String? get currentUid => _currentUser?.uid;
}

class AuthService {
  // In-memory driver store: uid -> AppUser
  static final Map<String, AppUser> _drivers = {};

  // Convenience getter matching the former auth API shape
  AppUser? get currentUser => AppSession.currentUser;

  // Stream of auth changes (simplified — emits once on call)
  Stream<AppUser?> get authStateChanges async* {
    yield AppSession.currentUser;
  }

  // Driver Sign Up
  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String tricycleNumber,
    required String plateNumber,
  }) async {
    if (_drivers.values.any((u) => u.email == email)) {
      return 'The email address is already in use.';
    }

    final uid = DateTime.now().millisecondsSinceEpoch.toString();
    final appUser = AppUser(
      uid: uid,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      tricycleNumber: tricycleNumber,
      plateNumber: plateNumber,
      createdAt: DateTime.now(),
    );

    _drivers[uid] = appUser;
    AppSession.setUser(appUser);
    return null; // Success
  }

  // Sign In
  Future<String?> signIn(String email, String password) async {
    try {
      final user = _drivers.values.firstWhere((u) => u.email == email);
      AppSession.setUser(user);
      return null; // Success
    } catch (_) {
      return 'No account found for that email address.';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    AppSession.setUser(null);
  }

  // Get Driver Data
  Future<AppUser?> getDriverData(String uid) async {
    return _drivers[uid];
  }
}
