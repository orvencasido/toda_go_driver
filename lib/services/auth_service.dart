import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AppSession {
  static AppUser? _currentUser;

  static AppUser? get currentUser => _currentUser;

  static void setUser(AppUser? user) => _currentUser = user;

  static String? get currentUid => _currentUser?.uid;
}

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  AppUser? get currentUser => AppSession.currentUser;

  Stream<AppUser?> get authStateChanges async* {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      AppSession.setUser(null);
      yield null;
      return;
    }
    yield await getDriverData(authUser.id);
  }

  Future<String?> signIn(String emailOrPhone, String password) async {
    try {
      var email = emailOrPhone;
      if (!emailOrPhone.contains('@')) {
        final profile = await _client
            .from('profiles')
            .select('email')
            .eq('phone_number', emailOrPhone)
            .eq('role', 'driver')
            .maybeSingle();
        if (profile == null) return 'No driver account found for that contact number.';
        email = profile['email'];
      }

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final authUser = response.user;
      if (authUser == null) return 'Invalid login credentials.';

      final driver = await getDriverData(authUser.id);
      if (driver == null) {
        await _client.auth.signOut();
        return 'This account is not registered as a driver.';
      }
      AppSession.setUser(driver);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Login failed. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    AppSession.setUser(null);
  }

  Future<AppUser?> getDriverData(String uid) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', uid)
        .eq('role', 'driver')
        .eq('status', 'Active')
        .maybeSingle();
    if (row == null) return null;
    final driver = AppUser.fromMap(row);
    AppSession.setUser(driver);
    return driver;
  }
}
