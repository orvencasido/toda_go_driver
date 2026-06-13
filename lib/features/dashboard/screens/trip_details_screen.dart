import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class TripDetailsScreen extends StatelessWidget {
  final String passengerName;
  final String pickup;
  final String pickupSub;
  final String dropoff;
  final String dropoffSub;
  final String distance;
  final String duration;
  final String fare;
  final String paymentMethod;
  final String status;
  final String dateTime;

  const TripDetailsScreen({
    super.key,
    required this.passengerName,
    required this.pickup,
    required this.pickupSub,
    required this.dropoff,
    required this.dropoffSub,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.paymentMethod,
    required this.status,
    required this.dateTime,
  });

  String get _pickupTime {
    final parts = dateTime.split('•');
    if (parts.length > 1) {
      return parts[1].trim();
    }
    return '8:15 AM';
  }

  String get _dropoffTime {
    try {
      final pickupStr = _pickupTime;
      final timeParts = pickupStr.split(' ');
      final hm = timeParts[0].split(':');
      int hour = int.parse(hm[0]);
      int minute = int.parse(hm[1]);
      final isPm = timeParts[1].toLowerCase() == 'pm';
      if (isPm && hour < 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;

      int durMin = 0;
      int durHr = 0;
      if (duration.contains('min')) {
        final digits = duration.replaceAll(RegExp(r'[^0-9]'), '');
        durMin = int.tryParse(digits) ?? 0;
      } else if (duration.contains(':')) {
        final durParts = duration.split(':');
        durMin = int.parse(durParts[1]);
        durHr = int.parse(durParts[0]);
      }

      final pickupDateTime = DateTime(2025, 5, 14, hour, minute);
      final dropoffDateTime = pickupDateTime.add(Duration(hours: durHr, minutes: durMin));
      
      return DateFormat('h:mm a').format(dropoffDateTime);
    } catch (_) {
      return '8:33 AM';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status.toLowerCase() == 'completed';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ─── NAVY HEADER ───────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 8,
              right: 16,
            ),
            color: AppColors.primaryNavy,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Trip Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance the back arrow
              ],
            ),
          ),

          // ─── STATUS & DATETIME BAR ─────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFFE8F8F0)
                        : const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? const Color(0xFF00B050)
                          : const Color(0xFFE53935),
                    ),
                  ),
                ),
                Text(
                  dateTime,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          // ─── MAIN CONTENT ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── MAP CONTAINER ─────────────────────────────────────
                  Container(
                    height: 240,
                    color: const Color(0xFFF1F5F9),
                    child: CustomPaint(
                      painter: _TripDetailsMapPainter(),
                      child: const SizedBox.expand(),
                    ),
                  ),

                  // ─── PASSENGER CARD ────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppColors.primaryNavy,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Passenger Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Passenger',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                passengerName,
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
                        // Call Passenger Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.phone_rounded,
                              color: AppColors.primaryNavy,
                              size: 20,
                            ),
                            onPressed: () => _showActionSnackBar(context, 'Calling $passengerName...'),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ─── TIMELINE & SUMMARY CARD ───────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline layout
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left indicator line
                            Column(
                              children: [
                                const SizedBox(height: 4),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00B050),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 1.5,
                                  height: 52,
                                  color: Colors.grey.shade200,
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE53935),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Addresses and Times
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Pickup Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 75,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _pickupTime,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryNavy,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Pickup',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 11,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pickup,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryNavy,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              pickupSub,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  // Drop-off Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 75,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _dropoffTime,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryNavy,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Drop-off',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 11,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dropoff,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryNavy,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              dropoffSub,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
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
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: Color(0xFFF1F5F9), thickness: 1.5),
                        const SizedBox(height: 12),
                        // Summary info rows
                        _buildSummaryRow(Icons.route_outlined, 'Distance', distance),
                        _buildSummaryRow(Icons.access_time_rounded, 'Duration', duration),
                        _buildSummaryRow(Icons.payment_rounded, 'Payment Method', paymentMethod),
                        _buildSummaryRow(
                          Icons.payments_outlined,
                          'Fare',
                          fare,
                          valueStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
          ),
        ],
      ),
    );
  }

  void _showActionSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _TripDetailsMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw light grey/blue map background
    final bgPaint = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Draw a park (light green area)
    final parkPaint = Paint()
      ..color = const Color(0xFFE2F0D9)
      ..style = PaintingStyle.fill;
    final parkPath = Path()
      ..moveTo(size.width * 0.05, size.height * 0.1)
      ..lineTo(size.width * 0.3, size.height * 0.05)
      ..lineTo(size.width * 0.25, size.height * 0.4)
      ..lineTo(size.width * 0.1, size.height * 0.35)
      ..close();
    canvas.drawPath(parkPath, parkPaint);

    // 3. Draw a river/lake (light blue area)
    final riverPaint = Paint()
      ..color = const Color(0xFFDDEEFE)
      ..style = PaintingStyle.fill;
    final riverPath = Path()
      ..moveTo(size.width * 0.7, 0)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.4, size.width * 0.9, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.95, size.height * 0.8, size.width, size.height * 0.9)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(riverPath, riverPaint);

    // 4. Draw street grid (background roads)
    final paintMinorRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintMinorRoadBorder = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final minorGridPath = Path();
    // Horizontal minor roads
    minorGridPath.moveTo(0, size.height * 0.15);
    minorGridPath.lineTo(size.width, size.height * 0.15);
    minorGridPath.moveTo(0, size.height * 0.5);
    minorGridPath.lineTo(size.width, size.height * 0.5);
    minorGridPath.moveTo(0, size.height * 0.85);
    minorGridPath.lineTo(size.width, size.height * 0.85);
    // Vertical minor roads
    minorGridPath.moveTo(size.width * 0.1, 0);
    minorGridPath.lineTo(size.width * 0.1, size.height);
    minorGridPath.moveTo(size.width * 0.5, 0);
    minorGridPath.lineTo(size.width * 0.5, size.height);
    minorGridPath.moveTo(size.width * 0.9, 0);
    minorGridPath.lineTo(size.width * 0.9, size.height);

    canvas.drawPath(minorGridPath, paintMinorRoadBorder);
    canvas.drawPath(minorGridPath, paintMinorRoad);

    // 5. Draw main roads
    final paintRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintRoadBorder = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final mainGridPath = Path();
    mainGridPath.moveTo(0, size.height * 0.35);
    mainGridPath.lineTo(size.width, size.height * 0.35);
    mainGridPath.moveTo(size.width * 0.3, 0);
    mainGridPath.lineTo(size.width * 0.3, size.height);

    canvas.drawPath(mainGridPath, paintRoadBorder);
    canvas.drawPath(mainGridPath, paintRoad);

    // 6. Draw route path
    final paintRoute = Paint()
      ..color = AppColors.primaryNavy // Deep blue route
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final routePath = Path();
    routePath.moveTo(size.width * 0.2, size.height * 0.7);
    routePath.quadraticBezierTo(
      size.width * 0.3, size.height * 0.65,
      size.width * 0.4, size.height * 0.5,
    );
    routePath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.35,
      size.width * 0.6, size.height * 0.35,
    );
    routePath.lineTo(size.width * 0.8, size.height * 0.35);

    // Draw route glow
    final routeGlow = Paint()
      ..color = AppColors.primaryNavy.withValues(alpha: 0.2)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(routePath, routeGlow);
    canvas.drawPath(routePath, paintRoute);

    // 7. Draw pins
    _drawPin(canvas, Offset(size.width * 0.2, size.height * 0.7), const Color(0xFF00B050)); // Green pickup
    _drawPin(canvas, Offset(size.width * 0.8, size.height * 0.35), const Color(0xFFE53935)); // Red dropoff
  }

  void _drawPin(Canvas canvas, Offset position, Color color) {
    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position + const Offset(0, 4), 6, shadowPaint);

    // Draw pin body (droplet/pin shape)
    final path = Path();
    path.moveTo(position.dx, position.dy);
    path.cubicTo(
      position.dx - 10, position.dy - 10,
      position.dx - 10, position.dy - 24,
      position.dx, position.dy - 24,
    );
    path.cubicTo(
      position.dx + 10, position.dy - 24,
      position.dx + 10, position.dy - 10,
      position.dx, position.dy,
    );
    path.close();

    final pinPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, pinPaint);

    // Draw white inner circle
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position - const Offset(0, 14), 4, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
