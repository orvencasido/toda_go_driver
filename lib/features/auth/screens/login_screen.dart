import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/core/services/auth_service.dart';
import 'package:toda_go_driver/features/dashboard/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // Persist the login flag — no password is stored.
      await AuthService.setLoggedIn(true);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.white.withValues(alpha: 0.65),
        fontSize: 13.0,
      ),
      prefixIcon: Icon(prefixIcon, color: Colors.white, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.primaryNavy,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Colors.white24, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: AppColors.offlineRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: AppColors.offlineRed, width: 1),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.offlineRed,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height:100),

                // ── Logo ──────────────────────────────────────────────────
                Transform.translate(
  offset: const Offset(0, 20),
  child: Image.asset(
    'assets/icons/logo.png',
    height: 90,
    width: 90,
    errorBuilder: (context, error, stackTrace) => const Icon(
      Icons.directions_bike,
      size: 90,
      color: AppColors.primaryNavy,
    ),
  ),
),
                const SizedBox(height: 1),

                // ── App name ──────────────────────────────────────────────
                const Text(
                  'Tayabas TODA Go',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const Text(
                  'Booking App',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryNavy,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Welcome heading ───────────────────────────────────────
                const Text(
                  'Welcome Driver',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Log in to your driver account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryNavy,
                  ),
                ),

                const SizedBox(height: 36),

                // ── Email / Phone field ───────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Enter Email or Phone Number',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  decoration: _fieldDecoration(
                    hint: 'Enter your email or phone number',
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Password field ────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Password',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  decoration: _fieldDecoration(
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outline_rounded,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 4) {
                      return 'Password must be at least 4 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // ── Login button ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onlineGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
