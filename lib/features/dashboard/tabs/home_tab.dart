import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';

import 'package:toda_go_driver/features/dashboard/screens/all_ride_requests_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/new_ride_request_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/earnings_report_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/ratings_reviews_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/online_time_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  bool _isOnline = true;

  late final AnimationController _toggleAnimController;

  @override
  void initState() {
    super.initState();
    _toggleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: _isOnline ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _toggleAnimController.dispose();
    super.dispose();
  }

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
    if (_isOnline) {
      _toggleAnimController.forward();
    } else {
      _toggleAnimController.reverse();
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isOnline
              ? ' You are now ONLINE. Ready to receive bookings!'
              : ' You are now OFFLINE. Rest well!',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        backgroundColor:
            _isOnline ? const Color(0xFF43A047) : const Color(0xFFC00000),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleViewDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NewRideRequestScreen(
          pickup: '123 Main St., Arnings',
          dropoff: 'Rizal Boulevard',
          distance: '1.2 km',
          fare: '₱86.00',
        ),
      ),
    );
  }



  void _handleViewAllTrips() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AllRideRequestsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // Curved Blue Header Background Extension
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.primaryNavy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── PROFILE CARD (White card overlapping header) ────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ── Avatar + Name + ID Row ─────────────────────────
                        Row(
                          children: [
                            // Profile avatar with online indicator
                            Stack(
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCFEAF7),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFB3D4F0),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: profile.imagePath != null
                                        ? Image.file(
                                            File(profile.imagePath!),
                                            width: 62,
                                            height: 62,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.person_rounded,
                                            size: 38,
                                            color: AppColors.primaryNavy,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _isOnline
                                          ? const Color(0xFF00B050)
                                          : Colors.grey.shade400,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
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
                                  const SizedBox(height: 2),
                                  Text(
                                    'Driver ID: ${profile.todaNumber.replaceAll(' ', '')}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ── Rating Row ─────────────────────────────────────
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RatingsReviewsScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFF1F5F9),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFC107),
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '4.8',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '(128 reviews)',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey.shade400,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── ONLINE STATUS TOGGLE ─────────────────────────────────
                  GestureDetector(
                    onTap: _toggleOnlineStatus,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _isOnline
                            ? const Color(0xFFEEFBF2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isOnline
                              ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                              : Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Power button circle
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _isOnline
                                  ? const Color(0xFF43A047)
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.power_settings_new_rounded,
                              color: _isOnline
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Text(
                                    _isOnline
                                        ? 'You are Online'
                                        : 'You are Offline',
                                    key: ValueKey(_isOnline),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: _isOnline
                                          ? const Color(0xFF2E7D32)
                                          : AppColors.primaryNavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _isOnline
                                      ? 'Ready to receive booking'
                                      : 'Tap to go online and accept rides',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: _isOnline
                                        ? const Color(0xFF22C55E).withValues(alpha: 0.85)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey.shade400,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── UPCOMING RIDE HEADER ─────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Ride',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleViewAllTrips,
                        child: const Text(
                          'View all',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── UPCOMING RIDE CARD ───────────────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _isOnline
                        ? _buildUpcomingRideCard()
                        : _buildOfflineCard(),
                  ),

                  const SizedBox(height: 24),

                  // ── TODAY'S SUMMARY HEADER ───────────────────────────────
                  const Text(
                    "Today's Summary",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── TODAY'S SUMMARY CARD ─────────────────────────────────
                  _buildTodaySummaryCards(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── UPCOMING RIDE CARD (ONLINE) ─────────────────────────────────────────
  Widget _buildUpcomingRideCard() {
    return Container(
      key: const ValueKey('online_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with PICK UP and ETA
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('PICK UP', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(width: 10),
              const Text('in 5 min', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          // Locations (Pickup and Dropoff)
          _buildLocationRow(Icons.location_on_rounded, const Color(0xFF43A047), '123 Main St.', 'Arnings'),
          Padding(
            padding: const EdgeInsets.only(left: 13, top: 4, bottom: 4),
            child: Container(width: 2, height: 16, color: Colors.grey.shade300),
          ),
          _buildLocationRow(Icons.location_on_rounded, const Color(0xFFE53935), 'Rizal Boulevard', 'City Center'),
          
          const SizedBox(height: 18),
          
          // Metrics (Fare and Distance)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Est. Fare', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      const Text('₱86.00', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Distance', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      const Text('1.2 km', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 18),

          // Only View Details Button
          SizedBox(
            width: double.infinity,
            child: _buildOutlineActionButton(
              icon: Icons.info_outline_rounded,
              label: 'View Details',
              onTap: _handleViewDetails,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, Color color, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // ── OFFLINE PLACEHOLDER CARD ────────────────────────────────────────────
  Widget _buildOfflineCard() {
    return Container(
      key: const ValueKey('offline_card'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.cloud_off_outlined,
                size: 36, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 14),
          const Text(
            'You are currently offline',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Go online to start receiving\nride requests.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── TODAY'S SUMMARY CARDS (Side by side) ────────────────────────────────
  Widget _buildTodaySummaryCards() {
    return Row(
      children: [
        // Earnings Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EarningsReportScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F2FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Color(0xFF2563EB),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '₱1,250.00',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        Text(
                          "Today's Earnings",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Online Time Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OnlineTimeScreen(),
                ),
              );
            },
            child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F2FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '5h 30m',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      Text(
                        'Online Time',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10.5,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ],
    );
  }

  // ── OUTLINED ACTION BUTTON ──────────────────────────────────────────────
  Widget _buildOutlineActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF2563EB)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
