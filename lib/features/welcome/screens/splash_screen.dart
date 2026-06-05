import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/core/services/auth_service.dart';
import 'package:toda_go_driver/features/auth/screens/login_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideRoute();
  }

  Future<void> _decideRoute() async {
    // Keep the splash visible for at least 3 seconds, then check login state.
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            loggedIn ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Center(
        child: Transform.translate(
          offset: const Offset(0, -20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Transform.translate(
  offset: const Offset(0, 50),
  child: Image.asset(
    'assets/icons/logo.png',
    height: 120,
    width: 120,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(
        Icons.directions_bike,
        size: 120,
        color: AppColors.primaryNavy,
      );
    },
  ),
),
                const SizedBox(height: 24),
                const Text(
                  'Tayabas TODA Go',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Booking App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryNavy,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}