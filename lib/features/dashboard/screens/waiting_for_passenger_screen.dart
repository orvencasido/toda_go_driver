import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/navigating_to_dropoff_screen.dart';

class WaitingForPassengerScreen extends StatefulWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const WaitingForPassengerScreen({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
  });

  @override
  State<WaitingForPassengerScreen> createState() => _WaitingForPassengerScreenState();
}

class _WaitingForPassengerScreenState extends State<WaitingForPassengerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _waitingTimeSeconds = 0;
  late final javaTimer = Stream<int>.periodic(const Duration(seconds: 1), (x) => x + 1);
  late final _timerSubscription = javaTimer.listen((val) {
    if (mounted) {
      setState(() {
        _waitingTimeSeconds = val;
      });
    }
  });

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timerSubscription.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Map Background ────────────────────────────────────────────────
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF1F5F9), // Light background for grid
              child: CustomPaint(
                painter: _SubtleMapPainter(),
              ),
            ),
          ),

          // ── Top Gradient Overlay for Header ───────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Back Button (No Bell Icon) ────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // ── Animated Pulsing Pin on Map ──────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse ripples
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 80 * _pulseController.value,
                          height: 80 * _pulseController.value,
                          decoration: BoxDecoration(
                            color: AppColors.onlineGreen.withValues(alpha: 0.35 * (1 - _pulseController.value)),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 50 * _pulseController.value,
                          height: 50 * _pulseController.value,
                          decoration: BoxDecoration(
                            color: AppColors.onlineGreen.withValues(alpha: 0.5 * (1 - _pulseController.value)),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                    // Active pin container
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.directions_walk,
                          color: AppColors.onlineGreen,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Passenger is here",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Panel ──────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title / Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Waiting for Passenger",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.onlineGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatDuration(_waitingTimeSeconds),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onlineGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Location Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBackground.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.lightBlueBackground.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.offlineRed, size: 26),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pickup Point",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.pickup,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Start Trip Button (Green, Full-width, Arrow on right)
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NavigatingToDropoffScreen(
                              pickup: widget.pickup,
                              dropoff: widget.dropoff,
                              distance: widget.distance,
                              fare: widget.fare,
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
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          // Empty spacer to center text relative to icon
                          SizedBox(width: 24),
                          Text(
                            "Start Trip",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                        ],
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
}

// ── Subtle Map Painter for Background Grid & Roads ──────────────────────────
class _SubtleMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    // Draw grid lines
    const int step = 40;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw mock roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final roadBorderPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.05)
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final road1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.4);

    final road2 = Path()
      ..moveTo(size.width * 0.5, 0)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.5, size.width * 0.65, size.height);

    canvas.drawPath(road1, roadBorderPaint);
    canvas.drawPath(road1, roadPaint);

    canvas.drawPath(road2, roadBorderPaint);
    canvas.drawPath(road2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
