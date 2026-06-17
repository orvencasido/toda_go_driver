import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/trip_completed_receipt_screen.dart';

class EndTripScreen extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const EndTripScreen({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    final double topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── Header Block (matching mockup) ───────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryNavy,
            padding: EdgeInsets.only(
              top: topPad + 8,
              left: 4,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Trip Completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer to balance back button
              ],
            ),
          ),

          // ── Scrollable Body content ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Checkmark badge
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Thank you for riding with us!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Pickup & Dropoff Address Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 24),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pickup',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pickup,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Dotted line
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 11),
                              width: 2,
                              height: 30,
                              child: CustomPaint(
                                painter: _DottedLinePainter(color: const Color(0xFF94A3B8)),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 24),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Drop-off',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Color(0xFF2563EB),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dropoff,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metrics list Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMetricRow(
                          icon: Icons.navigation_outlined,
                          label: 'Distance',
                          value: distance,
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 28, thickness: 1),
                        _buildMetricRow(
                          icon: Icons.access_time_rounded,
                          label: 'Duration',
                          value: '00:18:24',
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 28, thickness: 1),
                        _buildMetricRow(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Fare',
                          value: fare,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Confirm End Trip Button (changed to "Confirm Trip Completed")
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripCompletedReceiptScreen(
                              pickup: pickup,
                              dropoff: dropoff,
                              distance: distance,
                              fare: fare,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm Trip Completed',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
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
          child: Icon(icon, color: const Color(0xFF2563EB), size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.5,
            color: Color(0xFF64748B),
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

class _DottedLinePainter extends CustomPainter {
  final Color color;
  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 4, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    while (startY < size.height) {
      canvas.drawRect(
        Rect.fromLTWH(0, startY, size.width, dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
