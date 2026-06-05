import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isOnline = false;

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isOnline
              ? "You are now ONLINE. Ready to receive bookings!"
              : "You are now OFFLINE. Rest well!",
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            _isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // ─── DARK BLUE HEADER ───
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryNavy,
            ),
            child: const Center(
              child: Text(
                "TODA GO",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ─── SCROLLABLE CONTENT ───
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── PROFILE CARD ───
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar circle
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.profileCardBg,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.shade100,
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: profile.imagePath != null
                                ? Image.file(
                                    File(profile.imagePath!),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: AppColors.primaryNavy,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Name and team
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Team: ${profile.todaNumber}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── GO ONLINE BUTTON ───
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _toggleOnlineStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onlineGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _isOnline ? "GO Offline" : "GO Online",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── UPCOMING RIDES HEADER ───
                  const Text(
                    "Upcoming Rides",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ─── UPCOMING RIDES CARD ───
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isOnline
                        ? const Column(
                            children: [
                              Icon(
                                Icons.hourglass_empty,
                                size: 40,
                                color: AppColors.textLight,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Waiting for ride requests",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "You'll be notified when a passenger books.",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : const Column(
                            children: [
                              Icon(
                                Icons.cloud_outlined,
                                size: 40,
                                color: AppColors.textLight,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "You are currently offline",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Go online to start receiving ride requests in Tayabas.",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
