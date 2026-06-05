import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _currentObscure = true;
  bool _newObscure = true;
  bool _confirmObscure = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await context.read<ProfileProvider>().changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password updated successfully',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.onlineGreen,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update password. Please verify current password.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.offlineRed,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // ── Dark Navy Header ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryNavy,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 8,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Change Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Lock icon header
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 40,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Update your password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Fields card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Current Password
                          _PasswordField(
                            controller: _currentPasswordController,
                            label: 'Current Password',
                            isObscure: _currentObscure,
                            onToggle: () => setState(() => _currentObscure = !_currentObscure),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Current password is required';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // New Password
                          _PasswordField(
                            controller: _newPasswordController,
                            label: 'New Password',
                            isObscure: _newObscure,
                            onToggle: () => setState(() => _newObscure = !_newObscure),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'New password is required';
                              if (v.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Confirm New Password
                          _PasswordField(
                            controller: _confirmPasswordController,
                            label: 'Confirm New Password',
                            isObscure: _confirmObscure,
                            onToggle: () => setState(() => _confirmObscure = !_confirmObscure),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please confirm your new password';
                              if (v != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onlineGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 3,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Password Field ────────────────────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isObscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.isObscure,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          validator: validator,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryNavy, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.offlineRed, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.offlineRed, width: 1.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textLight,
                size: 20,
              ),
              onPressed: onToggle,
            ),
            errorStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
