import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/waiting_for_passenger_screen.dart';

class NavigatingToPickupScreen extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const NavigatingToPickupScreen({
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
                    'Navigating to Pickup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Spacer to balance the back arrow
                const SizedBox(width: 48),
              ],
            ),
          ),

          // ── Map / Navigation Placeholder ─────────────────────────────────
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                // Map placeholder with gradient
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF87CEEB),
                        Color(0xFFB0D4E8),
                        Color(0xFFD4E9C5),
                        Color(0xFFB8D4A0),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _MapPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),

                // Pickup location pin label
                Positioned(
                  top: 60,
                  left: 30,
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
                      const Icon(Icons.location_on, color: AppColors.primaryNavy, size: 32),
                    ],
                  ),
                ),

                // Gradient fade at the bottom of the map
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info Cards Panel ─────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Distance and ETA row
                Row(
                  children: [
                    Expanded(
                      child: _RouteInfoCard(
                        icon: Icons.location_on,
                        iconColor: AppColors.onlineGreen,
                        text: distance,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RouteInfoCard(
                        icon: Icons.access_time,
                        iconColor: AppColors.onlineGreen,
                        text: '4 mins',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Heading card
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
                      const Icon(Icons.location_on, color: Colors.red, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Heading to Pickup',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pickup,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
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

                const SizedBox(height: 14),

                // Arrived at Pickup Button (Green, no arrow)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingForPassengerScreen(
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
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Arrived at Pickup',
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

// ── Route Info Card ──────────────────────────────────────────────────────────
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

// ── Custom Map Painter ───────────────────────────────────────────────────────
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final routePaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final roadBorderPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 32
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw road
    final roadPath = Path()
      ..moveTo(size.width * 0.15, size.height)
      ..cubicTo(
        size.width * 0.2, size.height * 0.7,
        size.width * 0.4, size.height * 0.5,
        size.width * 0.55, size.height * 0.3,
      )
      ..cubicTo(
        size.width * 0.65, size.height * 0.15,
        size.width * 0.75, size.height * 0.1,
        size.width * 0.85, 0,
      );

    canvas.drawPath(roadPath, roadBorderPaint);
    canvas.drawPath(roadPath, roadPaint);

    // Draw blue route arrow on top of road
    final routePath = Path()
      ..moveTo(size.width * 0.15, size.height)
      ..cubicTo(
        size.width * 0.2, size.height * 0.7,
        size.width * 0.4, size.height * 0.5,
        size.width * 0.55, size.height * 0.3,
      )
      ..cubicTo(
        size.width * 0.65, size.height * 0.15,
        size.width * 0.75, size.height * 0.1,
        size.width * 0.85, 0,
      );

    canvas.drawPath(routePath, routePaint);

    // Draw trees (green circles)
    final treePaint = Paint()..color = const Color(0xFF4CAF50).withValues(alpha: 0.6);
    final treePositions = [
      Offset(size.width * 0.05, size.height * 0.4),
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.75, size.height * 0.55),
      Offset(size.width * 0.85, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.45),
    ];
    for (final pos in treePositions) {
      canvas.drawCircle(pos, 18, treePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
