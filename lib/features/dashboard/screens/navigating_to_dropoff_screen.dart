import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/end_trip_screen.dart';

class NavigatingToDropoffScreen extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const NavigatingToDropoffScreen({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Navigating to Drop-off',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer to balance the back arrow
              ],
            ),
          ),

          // ── Map / Navigation Placeholder ─────────────────────────────────
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                // Map background with custom paint
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFE0F2FE),
                        Color(0xFFBAE6FD),
                        Color(0xFFFEF08A),
                        Color(0xFFFEF9C3),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _DropoffMapPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),

                // Pickup Pin Label
                Positioned(
                  bottom: 70,
                  left: 40,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          pickup,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.location_on, color: AppColors.primaryNavy, size: 30),
                    ],
                  ),
                ),

                // Drop-off Pin Label
                Positioned(
                  top: 70,
                  right: 40,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          dropoff,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.location_on, color: AppColors.offlineRed, size: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Info Cards & Arrived Button ──────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: [
                // Distance and ETA Row
                Row(
                  children: [
                    Expanded(
                      child: _RouteInfoCard(
                        icon: Icons.map_outlined,
                        iconColor: AppColors.onlineGreen,
                        text: distance,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RouteInfoCard(
                        icon: Icons.access_time_filled,
                        iconColor: AppColors.onlineGreen,
                        text: '8 mins',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Heading Destination Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.navigation_rounded, color: Colors.blueAccent, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Heading to Drop-off',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dropoff,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Arrived at Drop-off Button (Green, No Arrow)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EndTripScreen(
                            pickup: pickup,
                            dropoff: dropoff,
                            distance: distance,
                            fare: fare,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.onlineGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Arrived at Drop-off',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _RouteInfoCard({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Drop-off Map Route Painter ──────────────────────────────────────────────
class _DropoffMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final routePaint = Paint()
      ..color = const Color(0xFF10B981) // Green route for trip progress
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final borderPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 32
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Road path from bottom-left to top-right
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..cubicTo(
        size.width * 0.3, size.height * 0.5,
        size.width * 0.7, size.height * 0.6,
        size.width * 0.8, size.height * 0.2,
      );

    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path, routePaint);

    // Green space trees
    final treePaint = Paint()..color = const Color(0xFF22C55E).withValues(alpha: 0.45);
    final treePositions = [
      Offset(size.width * 0.1, size.height * 0.3),
      Offset(size.width * 0.55, size.height * 0.25),
      Offset(size.width * 0.35, size.height * 0.75),
      Offset(size.width * 0.9, size.height * 0.6),
    ];
    for (final pos in treePositions) {
      canvas.drawCircle(pos, 16, treePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
