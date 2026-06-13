import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class TripCompletedReceiptScreen extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const TripCompletedReceiptScreen({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
  });

  double _parseFare(String fareStr) {
    final digits = fareStr.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(digits) ?? 120.0;
  }

  @override
  Widget build(BuildContext context) {
    final double totalFare = _parseFare(fare);
    final double fixedFareVal = (totalFare * 2 / 3).roundToDouble();
    final double distanceFareVal = (totalFare * 1 / 4).roundToDouble();
    final double tipFareVal = totalFare - fixedFareVal - distanceFareVal;

    final String fixedFareStr = '₱${fixedFareVal.toStringAsFixed(2)}';
    final String distanceFareStr = '₱${distanceFareVal.toStringAsFixed(2)}';
    final String tipFareStr = '₱${tipFareVal.toStringAsFixed(2)}';

    final double topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: Column(
        children: [
          // ── Top Blue Banner ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, topPad + 40, 24, 40),
            color: AppColors.primaryNavy,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular Check Badge
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Trip Completed Text
                const Text(
                  'Trip Completed',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                // Thank you! Subtext
                const Text(
                  'Thank you!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Sheet Area ──────────────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fare Breakdown',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Fixed Fare row
                          _buildBreakdownRow(
                            icon: Icons.directions_car_rounded,
                            title: 'Fixed Fare',
                            value: fixedFareStr,
                          ),
                          const Divider(color: Color(0xFFF1F5F9), height: 28, thickness: 1),

                          // Distance row
                          _buildBreakdownRow(
                            icon: Icons.location_on_rounded,
                            title: 'Distance ($distance)',
                            value: distanceFareStr,
                          ),
                          const Divider(color: Color(0xFFF1F5F9), height: 28, thickness: 1),

                          // Tip row
                          _buildBreakdownRow(
                            icon: Icons.redeem_rounded,
                            title: 'Tip',
                            value: tipFareStr,
                          ),
                          const Divider(color: Color(0xFFF1F5F9), height: 28, thickness: 1),

                          const SizedBox(height: 16),

                          // Total Fare
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Fare',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                              Text(
                                fare,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Back to Home Button
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      12,
                      24,
                      MediaQuery.of(context).padding.bottom + 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Goes back to Dashboard (first screen in stack)
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home_rounded, color: Colors.white, size: 22),
                        label: const Text(
                          'Back to Home',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
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

  Widget _buildBreakdownRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryNavy, size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.5,
            color: AppColors.primaryNavy,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }
}
