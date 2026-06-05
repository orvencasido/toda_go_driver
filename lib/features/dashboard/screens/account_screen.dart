import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/core/services/auth_service.dart';
import 'package:toda_go_driver/features/auth/screens/login_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/personal_information_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/change_password_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/earnings_report_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/support_help_screen.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log Out',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(100, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: AppColors.primaryNavy),
            ),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'No',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNavy,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 44),
              backgroundColor: AppColors.offlineRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Yes',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await AuthService.logout();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
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
            child: const Center(
              child: Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // ── Scrollable Content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                children: [
                  // Profile card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Stack(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppColors.profileCardBg,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.primaryNavy, width: 2.5),
                              ),
                              child: ClipOval(
                                child: profile.imagePath != null
                                    ? Image.file(
                                        File(profile.imagePath!),
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 48,
                                        color: AppColors.primaryNavy,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: AppColors.onlineGreen,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.white, size: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      size: 13, color: AppColors.textLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    profile.contact,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.email_outlined,
                                      size: 13, color: AppColors.textLight),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      profile.email,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: AppColors.textLight,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.onlineGreen
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.verified,
                                            size: 12,
                                            color: AppColors.onlineGreen),
                                        const SizedBox(width: 4),
                                        Text(
                                          profile.verificationStatus,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onlineGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryNavy
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      profile.todaNumber,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryNavy,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu items
                  _MenuCard(
                    children: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        iconBg: const Color(0xFF4CAF50),
                        title: 'Personal Information',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const PersonalInformationScreen()),
                        ),
                      ),
                      const _Divider(),
                      _MenuItem(
                        icon: Icons.lock_outline,
                        iconBg: const Color(0xFF2196F3),
                        title: 'Change Password',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen()),
                        ),
                      ),
                      const _Divider(),
                      _MenuItem(
                        icon: Icons.bar_chart_outlined,
                        iconBg: const Color(0xFF607D8B),
                        title: 'Earnings Reports',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EarningsReportScreen()),
                        ),
                      ),
                      const _Divider(),
                      _MenuItem(
                        icon: Icons.help_outline,
                        iconBg: const Color(0xFF9C27B0),
                        title: 'Support & Help',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SupportHelpScreen()),
                        ),
                      ),
                      const _Divider(),
                      _MenuItem(
                        icon: Icons.logout,
                        iconBg: const Color(0xFFE53935),
                        title: 'Log Out',
                        titleColor: AppColors.offlineRed,
                        onTap: () => _confirmLogout(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Menu Card ────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ── Menu Item ────────────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.title,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppColors.textDark,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 22,
      ),
      onTap: onTap,
    );
  }
}

// ── Divider ──────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      endIndent: 0,
      color: Colors.grey.shade100,
    );
  }
}
