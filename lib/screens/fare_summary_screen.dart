import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'searching_tricycle_screen.dart';

class FareSummaryScreen extends StatelessWidget {
  final int tripFare;
  final int doorToDoorFare;

  const FareSummaryScreen({
    super.key,
    required this.tripFare,
    required this.doorToDoorFare,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);
    int totalFare = tripFare + doorToDoorFare;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Modern Header synchronized with Dashboard
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  darkBlue,
                  Color(0xFF1A237E),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SafeArea(
              child: Row(
                children: [
                  // Left-aligned Logo consistent with Dashboard
                  Container(
                    height: 115,
                    width: 115,
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/toda_go_white.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.receipt_long_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Branding & Title
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODA GO',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'FARE SUMMARY',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Back Button on Right Side
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Route Preview Card
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: const Size(double.infinity, 180),
                            painter: MapRoutePainter(),
                          ),
                          const Center(
                            child: Icon(Icons.map_rounded, color: Colors.white24, size: 80),
                          ),
                          Positioned(
                            top: 40,
                            left: 40,
                            child: _buildMapPin(Icons.my_location_rounded, Colors.blue),
                          ),
                          Positioned(
                            bottom: 40,
                            right: 40,
                            child: _buildMapPin(Icons.location_on_rounded, Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Fare Breakdown Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header section with Total
                        Container(
                          padding: const EdgeInsets.all(25),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: darkBlue.withOpacity(0.02),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL FARE',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '₱${totalFare.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  color: darkBlue,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        
                        // Breakdown Rows
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              _buildSummaryRow('Trip Base Fare', '₱$tripFare'),
                              const SizedBox(height: 16),
                              _buildSummaryRow('Service Fee', '₱$doorToDoorFare'),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(height: 1, color: Color(0xFFF5F5F5)),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.payment_rounded, color: darkBlue, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Cash Payment',
                                    style: GoogleFonts.poppins(
                                      color: darkBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // FIND TRICYCLE Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchingTricycleScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        shadowColor: darkBlue.withOpacity(0.3),
                      ),
                      child: Text(
                        'FIND TRICYCLE',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
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

  Widget _buildMapPin(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildSummaryRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.poppins(
            color: const Color(0xFF000080),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRoad = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.fill;
    
    final paintPark = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 60, size.width, 30), paintRoad);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.4, 0, 30, size.height), paintRoad);
    canvas.drawRRect(RRect.fromLTRBR(10, 10, 100, 50, const Radius.circular(10)), paintPark);
    canvas.drawRRect(RRect.fromLTRBR(size.width - 100, size.height - 50, size.width - 10, size.height - 10, const Radius.circular(10)), paintPark);

    final paintRoute = Paint()
      ..color = const Color(0xFF000080)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(40, 40);
    path.quadraticBezierTo(size.width * 0.5, 40, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.height - 40, size.width - 40, size.height - 40);

    canvas.drawPath(path, paintRoute);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
